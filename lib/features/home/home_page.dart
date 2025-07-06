// lib/features/home/home_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/screens/chat_page.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20symptoms%20checker/widget/ai_symptoms_card.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/services/doctor_search_service.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/widgets/nearby_doctors_list.dart';
import 'package:synovia_ai_telehealth_app/features/profile%20page/screens/profile_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/progress_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/report_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/chat_bot_widget.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/user_profile_card.dart';
import 'package:synovia_ai_telehealth_app/features/resources/widget/resources_article.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late UniqueKey _homeTabKey; // Keep this for animation restart

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DoctorSearchService _doctorSearchService = DoctorSearchService();

  String _lastRecommendedSpecialist = 'General Physician'; // Default specialist
  List<Doctor> _nearbyDoctors = [];
  bool _isLoadingDoctors = false;
  String? _doctorSearchError;

  @override
  void initState() {
    super.initState();
    _homeTabKey = UniqueKey();
    checkCurrentUser();
    // Start by loading cached specialist, which will then trigger _checkLocationAndFetchDoctors
    _loadCachedSpecialistAndFetchDoctors();
  }

  /// Loads the last recommended specialist from SharedPreferences
  /// and then proceeds to fetch the latest data from Firestore.
  Future<void> _loadCachedSpecialistAndFetchDoctors() async {
    developer.log('HomePage: Attempting to load cached specialist.');
    final prefs = await SharedPreferences.getInstance();
    final cachedSpecialist = prefs.getString('lastRecommendedSpecialist');
    if (cachedSpecialist != null && cachedSpecialist.isNotEmpty) {
      setState(() {
        _lastRecommendedSpecialist = cachedSpecialist;
        developer.log(
          'HomePage: Loaded cached specialist: "$_lastRecommendedSpecialist"',
        );
      });
    } else {
      developer.log('HomePage: No cached specialist found. Using default.');
    }
    // Now that _lastRecommendedSpecialist is set (either from cache or default),
    // proceed to check location and fetch the latest doctors.
    _checkLocationAndFetchDoctors();
  }

  void checkCurrentUser() {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      developer.log('HomePage: User is logged in: ${user.uid}');
    } else {
      developer.log('HomePage: No user is logged in.');
    }
  }

  Future<void> _checkLocationAndFetchDoctors() async {
    developer.log('HomePage: _checkLocationAndFetchDoctors called.');
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Services Disabled'),
              content: const Text(
                'Please enable location services to find nearby doctors.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Go to Settings'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openLocationSettings();
                    _checkLocationAndFetchDoctors(); // Recursive call to re-check
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _doctorSearchError =
                          'Location services are required to find doctors.';
                      _isLoadingDoctors = false;
                    });
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Location Permission Denied'),
                content: const Text(
                  'Location access is required to find nearby doctors. Please grant permission.',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Grant Permission'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _checkLocationAndFetchDoctors(); // Recursive call to re-check
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _doctorSearchError =
                            'Location permissions are required to find doctors.';
                        _isLoadingDoctors = false;
                      });
                    },
                  ),
                ],
              );
            },
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Permission Permanently Denied'),
              content: const Text(
                'Location access is permanently denied. Please enable it in app settings.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Open App Settings'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openAppSettings();
                    _checkLocationAndFetchDoctors(); // Recursive call to re-check
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _doctorSearchError =
                          'Location permissions are permanently denied.';
                      _isLoadingDoctors = false;
                    });
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }

    _fetchAndSearchDoctorsInternal();
  }

  Future<void> _fetchAndSearchDoctorsInternal() async {
    developer.log('HomePage: _fetchAndSearchDoctorsInternal called.');
    setState(() {
      _isLoadingDoctors = true;
      _doctorSearchError = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      String currentSpecialistToSearch = 'General Physician'; // Default

      final user = _auth.currentUser;
      if (user != null) {
        developer.log('HomePage: Fetching user document for UID: ${user.uid}');
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null && data.containsKey('recommendedSpecialist')) {
            currentSpecialistToSearch =
                data['recommendedSpecialist'] ?? 'General Physician';
            developer.log(
              'HomePage: Fetched recommended specialist from Firestore: "$currentSpecialistToSearch"',
            );
          } else {
            developer.log(
              'HomePage: Firestore user doc does not contain "recommendedSpecialist". Using default.',
            );
          }
        } else {
          developer.log(
            'HomePage: Firestore user doc not found for UID: ${user.uid}. Using default specialist.',
          );
        }
      } else {
        developer.log('HomePage: No user logged in. Using default specialist.');
      }

      developer.log(
        'HomePage: Specialist determined for search (before setState): "$currentSpecialistToSearch"',
      );

      // Update UI with the newly fetched specialist
      setState(() {
        _lastRecommendedSpecialist = currentSpecialistToSearch;
      });

      // Save the newly fetched specialist to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'lastRecommendedSpecialist',
        currentSpecialistToSearch,
      );
      developer.log(
        'HomePage: Saved specialist to cache: "$currentSpecialistToSearch"',
      );

      developer.log(
        'HomePage: _lastRecommendedSpecialist after setState: "$_lastRecommendedSpecialist"',
      );

      developer.log(
        'HomePage: Calling DoctorSearchService with specialist: "$_lastRecommendedSpecialist"',
      );
      final doctors = await _doctorSearchService.searchNearbyDoctors(
        _lastRecommendedSpecialist,
      );
      setState(() {
        _nearbyDoctors = doctors;
      });
      developer.log(
        'HomePage: Found ${doctors.length} nearby doctors for "$_lastRecommendedSpecialist".',
      );
    } catch (e) {
      developer.log('HomePage: Error in _fetchAndSearchDoctorsInternal: $e');
      setState(() {
        _doctorSearchError = 'Failed to load nearby doctors: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoadingDoctors = false;
      });
      stopwatch.stop();
      developer.log('HomePage: Total _fetchAndSearchDoctorsInternal duration: ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  // Removed the redundant _fetchAndSearchDoctors method.
  // The onRefresh callback in NearbyDoctorsList now directly calls _checkLocationAndFetchDoctors.

  // --- CRITICAL FIX: Changed _screens from a late variable to a getter ---
  List<Widget> get _screensList {
    return [
      // Home tab content
      Column(
        key: _homeTabKey, // Keep this key for animation restart logic
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // UserProfileCard slides down from top
          AnimatedEntrance(
            child: UserProfileCard(
              onProfileTap: () {
                setState(() {
                  _selectedIndex = 4; // Profile tab index
                });
              },
            ),
            slideBegin: const Offset(0, -0.5), // Slide down from top
            delay: const Duration(milliseconds: 500),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // AI Symptoms Checker slides up
                    AnimatedEntrance(
                      child: Text(
                        'AI Symptoms Checker',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      slideBegin: const Offset(0, 0.5), // Slide up from bottom
                      delay: const Duration(milliseconds: 500),
                    ),
                    AnimatedEntrance(
                      child: AiSymptomsCard(),
                      slideBegin: const Offset(0, 0.5),
                      delay: const Duration(milliseconds: 600),
                    ),
                    SizedBox(height: 15),
                    // AI ChatBot slides in from left
                    AnimatedEntrance(
                      child: Text(
                        'AI ChatBot',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      slideBegin: const Offset(-0.5, 0), // Slide in from left
                      delay: const Duration(milliseconds: 700),
                    ),
                    AnimatedEntrance(
                      child: ChatBotWidget(
                        onChatTap: () async {
                          // Navigate to ChatPage and await its return
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                          // Once ChatPage is popped, refresh doctors list
                          _checkLocationAndFetchDoctors();

                          setState(() {
                            _selectedIndex = 2; // Chat tab index
                          });
                        },
                      ),
                      slideBegin: const Offset(-0.5, 0),
                      delay: const Duration(milliseconds: 750),
                    ),
                    SizedBox(height: 15),
                    // Find Nearby Doctors slides in from right
                    AnimatedEntrance(
                      child: Text(
                        'Find Nearby Doctors',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      slideBegin: const Offset(0.5, 0), // Slide in from right
                      delay: const Duration(milliseconds: 800),
                    ),
                    SizedBox(height: 10),

                    AnimatedEntrance(
                      child: NearbyDoctorsList(
                        // This will now always use the current _lastRecommendedSpecialist
                        recommendedSpecialist: _lastRecommendedSpecialist,
                        doctors: _nearbyDoctors,
                        isLoading: _isLoadingDoctors,
                        errorMessage: _doctorSearchError,
                        onRefresh:
                            _checkLocationAndFetchDoctors, // Pass the refresh callback
                      ),
                      slideBegin: const Offset(0.5, 0),
                      delay: const Duration(milliseconds: 850),
                    ),

                    SizedBox(height: 15),
                    // Resources and Articles fade in
                    AnimatedEntrance(
                      child: Text(
                        'Resources and Articles',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      slideBegin: Offset.zero,
                      delay: const Duration(milliseconds: 900),
                      // Only fade, no slide
                    ),
                    SizedBox(height: 10),
                    AnimatedEntrance(
                      child: ResourcesArticle(),
                      slideBegin: Offset.zero,
                      delay: const Duration(milliseconds: 1000),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // progress page, chat screen, reports screen, profile screen
      ProgressPage(),
      ChatPage(),
      ReportPage(),
      ProfilePage(),
    ];
  }
  // --- END CRITICAL FIX: Changed _screens to a getter ---

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _restartHomeTabAnimation() {
    developer.log('HomePage: _restartHomeTabAnimation called (tab change).');
    setState(() {
      _homeTabKey = UniqueKey();
      // Removed _buildScreens() call here, as _screensList getter handles it
      _checkLocationAndFetchDoctors(); // Re-check location and fetch doctors
    });
  }

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Color(0xFF212C24),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: darkBackgroundColor,
          // --- CRITICAL FIX: Use the _screensList getter here ---
          body: IndexedStack(index: _selectedIndex, children: _screensList),
          bottomNavigationBar: GNav(
            curve: Curves.easeInOut,
            tabMargin: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            hoverColor: Color.fromARGB(255, 65, 73, 65),
            backgroundColor: Color(0xff343A34),
            haptic: true,
            gap: 10,
            activeColor: Colors.white,
            tabBorderRadius: 30,
            tabActiveBorder: Border.all(color: Colors.white, width: 2),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                if (index == 0) {
                  _restartHomeTabAnimation();
                }
              });
            },

            tabs: [
              GButton(
                icon: Icons.home,
                leading: SvgPicture.asset(SvgAssets.nav_home),
                backgroundColor: Color(0xFF4B524B),
              ),
              GButton(
                icon: Icons.search,
                leading: SvgPicture.asset(SvgAssets.nav_chart),
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: Icons.notifications,
                leading: SvgPicture.asset(SvgAssets.nav_chat),
                iconColor: lightTextColor,
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: Icons.assessment,
                leading: SvgPicture.asset(SvgAssets.nav_document),
                iconColor: lightTextColor,
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),
              GButton(
                icon: Icons.settings,
                leading: SvgPicture.asset(SvgAssets.nav_user),
                iconColor: lightTextColor,
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

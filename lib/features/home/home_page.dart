import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/screens/chat_page.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/services/doctor_search_service.dart';
import 'package:synovia_ai_telehealth_app/features/home/controller/doctor_fetch_controller.dart';
import 'package:synovia_ai_telehealth_app/features/home/services/location_permission_handler.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/tab_screens_list.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late UniqueKey _homeTabKey; // Keep this for animation restart

  String _lastRecommendedSpecialist = 'General Physician'; // Default specialist
  List<Doctor> _nearbyDoctors = [];
  bool _isLoadingDoctors = false;
  String? _doctorSearchError;

  final DoctorFetchController _doctorFetchController = DoctorFetchController(
    auth: firebase_auth.FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    doctorSearchService: DoctorSearchService(),
  );

  final LocationPermissionHandler _locationPermissionHandler =
      LocationPermissionHandler();

  @override
  void initState() {
    super.initState();
    _homeTabKey = UniqueKey();
    checkCurrentUser();
    // Start by loading cached specialist, which will then trigger _checkLocationAndFetchDoctors
    _loadCachedSpecialistAndFetchDoctors();
    // Load active symptoms
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomsHistoryProvider>().loadActiveSymptoms();
    });
  }

  /// Loads the last recommended specialist from SharedPreferences
  /// and then proceeds to fetch the latest data from Firestore.
  Future<void> _loadCachedSpecialistAndFetchDoctors() async {
    final cachedSpecialist =
        await _doctorFetchController.loadCachedSpecialist();
    setState(() => _lastRecommendedSpecialist = cachedSpecialist);
    await _checkLocationAndFetchDoctors();
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
    final hasPermission = await _locationPermissionHandler
        .checkAndRequestLocationPermissions(context);
    if (!hasPermission) {
      setState(() {
        _doctorSearchError = 'Location permission denied.';
        _isLoadingDoctors = false;
      });
      return;
    }

    await _fetchAndSearchDoctorsInternal();
  }

  Future<void> _fetchAndSearchDoctorsInternal() async {
    setState(() {
      _isLoadingDoctors = true;
      _doctorSearchError = null;
    });

    try {
      final specialist =
          await _doctorFetchController.fetchSpecialistFromFirestore();
      setState(() => _lastRecommendedSpecialist = specialist);
      await _doctorFetchController.cacheSpecialist(specialist);

      final doctors = await _doctorFetchController.searchNearbyDoctors(
        specialist,
      );
      setState(() => _nearbyDoctors = doctors);
    } catch (e) {
      setState(
        () =>
            _doctorSearchError =
                'Failed to load nearby doctors: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoadingDoctors = false);
    }
  }

  List<Widget> get _screensList => buildTabScreens(
    specialist: _lastRecommendedSpecialist,
    doctors: _nearbyDoctors,
    isLoading: _isLoadingDoctors,
    error: _doctorSearchError,
    onRefresh: _checkLocationAndFetchDoctors,
    onProfileTap: () => setState(() => _selectedIndex = 4),
    onChatTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatPage()),
      );
      _checkLocationAndFetchDoctors();
      setState(() => _selectedIndex = 2);
    },
    homeTabKey: _homeTabKey,
  );

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _restartHomeTabAnimation() {
    developer.log('HomePage: _restartHomeTabAnimation called (tab change).');
    setState(() {
      _homeTabKey = UniqueKey();
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
                leading: SvgPicture.asset(SvgAssets.nav_document),
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
                leading: SvgPicture.asset(SvgAssets.nav_chart),
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

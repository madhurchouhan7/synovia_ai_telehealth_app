import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/screens/chat_page.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20symptoms%20checker/widget/ai_symptoms_card.dart';
import 'package:synovia_ai_telehealth_app/features/profile%20page/screens/profile_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/progress_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/report_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/chat_bot_widget.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/find_nearby_doctors.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/user_profile_card.dart';
import 'package:synovia_ai_telehealth_app/features/resources/widget/resources_article.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<Widget> _screens = [];
  late UniqueKey _homeTabKey;

  @override
  void initState() {
    super.initState();
    _homeTabKey = UniqueKey();

    _buildScreens();
  }

  void _buildScreens() {
    _screens.clear();
    _screens.addAll([
      // Home tab content
      Column(
        key: _homeTabKey,
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
                        onChatTap: () {
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
                      child: FindNearbyDoctors(),
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
    ]);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No-op, but you could trigger _buildScreens() here if needed
  }

  void _restartHomeTabAnimation() {
    setState(() {
      _homeTabKey = UniqueKey();
      _buildScreens();
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
          body: IndexedStack(index: _selectedIndex, children: _screens),
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

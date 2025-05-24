import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/ai_symptoms_checker.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/chat_bot_widget.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/find_nearby_doctors.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/resources_article.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/user_profile_card.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // user profile card (fixed)
              UserProfileCard(),

              // scrollable content
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
                        // AI Symptoms Checker
                        Text(
                          'AI Symptoms Checker',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        AiSymptomsChecker(),

                        SizedBox(height: 15),

                        // AI Chatbot
                        Text(
                          'AI ChatBot',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        ChatBotWidget(),

                        // find nearby doctors
                        SizedBox(height: 15),

                        // Find Nearby Doctors
                        Text(
                          'Find Nearby Doctors',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        FindNearbyDoctors(),

                        // resources and articles
                        SizedBox(height: 15),

                        // Resources and Articles
                        Text(
                          'Resources and Articles',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        ResourcesArticle(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: GNav(
            activeColor: Colors.white,
            backgroundColor: nav_bar_backgroundColor,
            tabs: [
              // Home
              GButton(
                icon: Icons.home,
                leading: SvgPicture.asset(SvgAssets.nav_home),
                backgroundColor: Color(0xFF4B524B),
              ),

              // Progress
              GButton(
                icon: Icons.search,
                leading: SvgPicture.asset(SvgAssets.nav_chart),
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),

              // Chat
              GButton(
                icon: Icons.notifications,
                leading: SvgPicture.asset(SvgAssets.nav_chat),
                iconColor: lightTextColor,
                backgroundColor: Color(0xFF4B524B),
                iconActiveColor: Colors.white,
              ),

              // Reports
              GButton(
                icon: Icons.assessment,
                leading: SvgPicture.asset(SvgAssets.nav_document),
                iconColor: lightTextColor,
                backgroundColor: Color(0xFF4B524B),

                iconActiveColor: Colors.white,
              ),

              // Profile
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

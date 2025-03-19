import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_in_page.dart';
import 'package:synovia_ai_telehealth_app/features/onboarding_screen/presentation/screens/on_boarding_screen.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // variable
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBackgroundColor,
        body: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // logo
                    SvgPicture.asset(SvgAssets.welcome_logo),

                    SizedBox(height: screenWidth * 0.05),

                    // title
                    Text(
                      'Welcome to the Synovia AI Telehealth App',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40 * fontSize,
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.07),

                    // subtext
                    Text(
                      'Your intelligent Telehealth AI Solution! 🚀',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: lightTextColor,
                        fontSize: 25 * fontSize,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.07),

                // svg
                SvgPicture.asset(SvgAssets.welcome_robot),

                SizedBox(height: screenWidth * 0.1),

                // button CTA
                InkWell(
                  onTap: () {
                    Navigator.push(context, pageRoute(OnBoardingScreen()));
                  },
                  splashColor: darkBackgroundColor,
                  highlightColor: darkBackgroundColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: screenWidth * 0.55,
                    height: screenWidth * 0.15,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // text
                          Text(
                            'Get Started',
                            style: GoogleFonts.nunito(
                              fontSize: 28 * fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // icon
                          SvgPicture.asset(
                            SvgAssets.solid_arrow_right_sm,
                            color: Colors.black,
                            height: 40 * fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.1),

                // Row -> Already have an account, sign in
                SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?\t\t',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 25 * fontSize,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            pageRoute(SignInPage()),
                          );
                        },
                        child: Text(
                          'Sign In.',
                          style: GoogleFonts.nunito(
                            color: brandColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25 * fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

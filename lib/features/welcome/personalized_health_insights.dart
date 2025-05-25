import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/home/home_page.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class PersonalizedHealthInsights extends StatelessWidget {
  const PersonalizedHealthInsights({super.key});

  @override
  Widget build(BuildContext context) {
    // variable
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // Header
                  Text(
                    'Personalized Health Insights',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 50 * fontSize,
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.1),

                  // subtext
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'We will ask a few Questions to understand your health better. This Helps us to provide more accurate insights and suggestions.',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 28 * fontSize,
                      ),
                    ),
                  ),
                ],
              ),

              // row -> 2 Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Card 1
                  Container(
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Icon
                          Icon(
                            Icons.warning_amber_rounded,
                            color: brandColor,
                            size: fontSize * 100,
                          ),

                          // Text
                          Text(
                            textAlign: TextAlign.center,
                            'Your data is Totally Secure',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 23 * fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card 2
                  Container(
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Icon
                          Icon(
                            Icons.timer,
                            color: brandColor,
                            size: fontSize * 100,
                          ),

                          // Text
                          Text(
                            'It Takes only 2-3 minutes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 23 * fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // get Started
              CtaButton(
                text: 'Get Started',
                svgAssets: SvgAssets.solid_arrow_right_sm,
                onTap: () {
                  Navigator.push(context, pageRoute(HomePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

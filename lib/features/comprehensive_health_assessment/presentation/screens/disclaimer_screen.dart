import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double pushUpAmount = screenWidth * 0.2;
    final fontSize = screenWidth / 600;
    final double visibleSvgContainerHeight = screenHeight * 0.3;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: visibleSvgContainerHeight,
                width: screenWidth, // Or double.infinity
                child: Stack(
                  // 2. IMPORTANT: Set clipBehavior to Clip.none
                  //    This allows children of the Stack to render outside its bounds.
                  clipBehavior: Clip.none,
                  children: [
                    // 3. Position the SvgPicture using Positioned
                    Positioned(
                      // Use a negative 'top' value to push the SVG upwards.
                      // The more negative the value, the higher it goes (more off-screen).
                      top:
                          -pushUpAmount, // Adjust this value based on how much you want to hide
                      left: 0,
                      right:
                          0, // This will center the SVG if its width is less than stack width
                      child: SvgPicture.asset(
                        SvgAssets.ai_onboarding,
                        width: screenWidth, // Keep your desired width
                        // You generally don't need to specify height here if width is set,
                        // as it will scale proportionally.
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'AI Health Insights \nDisclaimer',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 40 * fontSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'This app is in development. AI insights may be inaccurate and are not medical advice. Consult a professional for diagnosis and treatment.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: 25 * fontSize,
                  ),
                ),
              ),

              CtaButton(
                text: 'I Understood & Proceed',
                svgAssets: SvgAssets.pills,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

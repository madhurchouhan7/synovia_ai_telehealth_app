import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/error/widget/flag_info.dart';
import 'package:synovia_ai_telehealth_app/features/home/home_page.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class NoInternetError extends StatelessWidget {
  const NoInternetError({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_off,
                  size: screenWidth * 0.3,
                  color: brandColor.withOpacity(0.7),
                ),

                SizedBox(height: screenWidth * 0.15),

                Text(
                  'No Internet Connection',
                  style: GoogleFonts.nunito(
                    fontSize: fontSize * 34,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'It Seems you dont have active internet.',
                  style: GoogleFonts.nunito(
                    fontSize: fontSize * 24,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: screenWidth * 0.2),

                FlagInfo(flagText: 'Please refresh or try again.',),
                SizedBox(height: screenWidth * 0.1),
                CtaButton(
                  text: 'Take me Home',
                  svgAssets: SvgAssets.nav_home,
                  onTap: () {
                    Navigator.push(context, pageRoute(HomePage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

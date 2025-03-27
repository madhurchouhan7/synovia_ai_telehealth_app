import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.text,
    required this.svgAssets,
    required this.onTap,
  });

  final String text;
  final String svgAssets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;
    return InkWell(
      onTap: onTap,
      splashColor: darkBackgroundColor,
      highlightColor: darkBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: brandColor,
          borderRadius: BorderRadius.circular(20),
        ),
        width: screenWidth - 80,
        height: screenWidth * 0.15,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // text
              Text(
                '${text} \t\t',
                style: GoogleFonts.nunito(
                  fontSize: 28 * fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),

              // icon
              SvgPicture.asset(
                svgAssets,
                color: Colors.black,
                height: 40 * fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

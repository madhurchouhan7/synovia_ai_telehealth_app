import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class ForgotMethods extends StatelessWidget {
  const ForgotMethods({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.svgAssets,
  });
  final String primaryText;
  final String secondaryText;
  final String svgAssets;
  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 5, top: 20, bottom: 20, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //mainAxisAlignment: ,
          children: [
            // Icon Container
            Container(
              child: Container(
                decoration: BoxDecoration(
                  color: darkBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset(svgAssets, width: 30),
                ),
              ),
            ),

            // Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // primary text
                Text(
                  primaryText,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 32 * fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // secondary text
                Text(
                  secondaryText,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: 22 * fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

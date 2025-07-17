import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class CustomProfilePageOptions extends StatelessWidget {
  final String text;
  final Widget child;
  final VoidCallback? onTap;

  CustomProfilePageOptions({
    super.key,
    required this.text,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.0),
      child: Card(
        color: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Doctor's Image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // svg icon
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: darkBackgroundColor,
                      ),
                      width: screenWidth / 8,
                      height: screenWidth / 8,

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: child,
                      ),
                    ),

                    SizedBox(width: screenWidth / 30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Doctor's Name
                        Text(
                          text,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: fontSize * 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Doctor's Details icon
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: SvgPicture.asset(
                  SvgAssets.left_back_icon,
                  // ignore: deprecated_member_use
                  color: Color(0xFFA4A9A4),
                  height: screenWidth * 0.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

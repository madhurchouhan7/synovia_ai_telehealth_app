import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class SocialMediaSigninButton extends StatelessWidget {
  const SocialMediaSigninButton({super.key, required this.svgAssets, required this.onTap});

  final String svgAssets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: darkBackgroundColor,
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: EdgeInsets.all(fontSize * 25),
        child: SvgPicture.asset(
          svgAssets,
          height: fontSize * 40,
          width: fontSize * 40,
        ),
      ),
    );
  }
}

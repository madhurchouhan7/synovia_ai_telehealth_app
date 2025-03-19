import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class CustomOnboardingButton extends StatelessWidget {
  const CustomOnboardingButton({
    super.key,
    required this.svgAssets,
    required this.onTap,
  });
  final String svgAssets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: darkBackgroundColor,
      highlightColor: darkBackgroundColor,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: onTap == null ? Colors.black : backgroundColor,
          borderRadius: BorderRadius.circular(40),
        ),
        width: screenWidth * 0.43,
        height: screenWidth * 0.22,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SvgPicture.asset(svgAssets),
        ),
      ),
    );
  }
}

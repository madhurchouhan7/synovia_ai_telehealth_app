import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(SvgAssets.left_back_icon),
        ),
        decoration: BoxDecoration(
          color: Color(0xff50FFFFFF),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

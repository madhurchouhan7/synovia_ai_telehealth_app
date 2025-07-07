import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Duration delay;
  final Offset slideFrom;

  const SectionTitle({
    required this.title,
    this.delay = const Duration(milliseconds: 500),
    this.slideFrom = Offset.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedEntrance(
      delay: delay,
      slideBegin: slideFrom,
      child: Text(
        title,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

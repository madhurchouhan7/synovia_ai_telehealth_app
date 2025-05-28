import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlagInfo extends StatelessWidget {
  final String flagText;

  FlagInfo({super.key, required this.flagText});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;

    return Card(
      color: Color(0xFF8B0000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Icon(Icons.replay_outlined, color: Colors.white, size: 24),

              SizedBox(width: screenWidth * 0.02),
              // text
              Text(
                flagText,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: fontSize * 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class FindNearbyDoctors extends StatelessWidget {
  const FindNearbyDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;
    return Card(
      color: const Color(0xFF414B44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 30+
                    Text(
                      '1+',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: fontSize * 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // doctors available
                    Text(
                      'Doctors Available',
                      style: GoogleFonts.nunito(
                        color: lightTextColor,
                        fontSize: fontSize * 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // stethoscope icon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size:
                        screenWidth /
                        10, // Adjust icon size based on screen width
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6.0),
          ],
        ),
      ),
    );
  }
}

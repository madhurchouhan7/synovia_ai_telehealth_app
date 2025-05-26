import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialization;
  final String doctorRating;
  final String doctorTiming;
  final String doctorImageUrl;
  

  DoctorCard({
    super.key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorRating,
    required this.doctorTiming,
    required this.doctorImageUrl,
    
  });

  // This widget represents a card displaying doctor's information.

  // on tap, navigate to doctor's details page

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;
    return Card(
      color: Color(0xFF1B201D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                  CircleAvatar(
                    radius: screenWidth / 13,
                    backgroundImage: NetworkImage(doctorImageUrl),
                  ),
                  SizedBox(width: screenWidth / 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Doctor's Name
                      Text(
                        doctorName,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: fontSize * 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: screenWidth / 60),

                      // 2. Doctor's Specialization
                      Text(
                        '🩺 ${doctorSpecialization}',
                        style: GoogleFonts.nunito(
                          color: lightTextColor,
                          fontSize: fontSize * 20,
                        ),
                      ),

                      // 3. Doctor's Rating
                      Text(
                        '⭐ ${doctorRating}',
                        style: GoogleFonts.nunito(
                          color: lightTextColor,
                          fontSize: fontSize * 20,
                        ),
                      ),

                      // 4. Doctor's timing
                      Text(
                        '🕛 ${doctorTiming}',
                        style: GoogleFonts.nunito(
                          color: lightTextColor,
                          fontSize: fontSize * 20,
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
                height: screenWidth * 0.07,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

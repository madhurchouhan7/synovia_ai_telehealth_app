import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/widgets/doctor_card.dart';

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
                      '30+',
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

            DoctorCard(
              doctorName: 'Dr. John Doe',
              doctorSpecialization: 'Cardiologist',
              doctorRating: '4.5',
              doctorTiming: '9 AM - 5 PM',
              doctorImageUrl:
                  'https://media.istockphoto.com/id/177373093/photo/indian-male-doctor.jpg?s=612x612&w=0&k=20&c=5FkfKdCYERkAg65cQtdqeO_D0JMv6vrEdPw3mX1Lkfg=', // Replace with actual image URL
            ),

            const SizedBox(height: 5.0),

            DoctorCard(
              doctorName: 'Dr. Jane Smith',
              doctorSpecialization: 'Dermatologist',
              doctorRating: '4.8',
              doctorTiming: '10 AM - 6 PM',
              doctorImageUrl:
                  'https://thumbs.dreamstime.com/b/confident-anime-woman-doctor-portrait-professional-medical-expert-healthcare-clinic-concept-328870439.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class BloodTypeCard extends StatelessWidget {
  final String? selectedBloodType;
  final ValueChanged<String> onSelected;

  const BloodTypeCard({
    super.key,
    required this.selectedBloodType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    final bloodTypes = ['A', 'B', 'AB', 'O'];

    return Card(
      color: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  bloodTypes.map((type) {
                    final isSelected = selectedBloodType == type;
                    return GestureDetector(
                      onTap: () => onSelected(type),
                      child: Container(
                        width: fontSize * 130,
                        height: fontSize * 95,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF313A34)
                                  : secondaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: GoogleFonts.nunito(
                              fontSize: 40 * fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            // +ve or -ve
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

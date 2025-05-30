// lib/features/comprehensive_health_assessment/presentation/widgets/gender_selection_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart'; // Assuming these colors are defined
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/gender_option.dart';

class GenderSelectionCard extends StatelessWidget {
  final GenderOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth / 4; 
    final fontSize = screenWidth / 600 * 20;

    // Determine colors based on selection state
    final cardBackgroundColor =
        isSelected
            ? secondaryColor
            : Colors
                .grey
                .shade800; // Example: bright green for selected, dark grey for unselected
    final cardBorderColor =
        isSelected
            ? brandColor
            : Colors.transparent; // Example: brandColor border for selected
    final cardBorderWidth = isSelected ? 4.0 : 0.0;

    final imageBackgroundColor =
        isSelected
            ? option.selectedBackgroundColor
            : option.unselectedBackgroundColor;
    final imageColor =
        isSelected ? option.selectedIconColor : option.unselectedIconColor;
    final textColor = isSelected ? Colors.white : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        // Use AnimatedContainer for smooth transitions
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: screenWidth * 0.4,
        height: screenWidth * 0.4,
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: cardBorderColor, width: cardBorderWidth),
          boxShadow: [
            if (isSelected) // Add a subtle shadow for selected state
              BoxShadow(
                color: brandColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  iconSize / 2,
                ), // Make it circular
                color: imageBackgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(iconSize * 0.15), // Adjust padding
                // Use SvgPicture.asset for local assets, not network
                child: SvgPicture.asset(
                  option.iconPath,
                  colorFilter: ColorFilter.mode(imageColor, BlendMode.srcIn),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              option.label,
              style: GoogleFonts.nunito(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

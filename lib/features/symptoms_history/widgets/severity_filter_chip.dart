import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeverityFilterChip extends StatelessWidget {
  final String selectedSeverity;
  final Function(String) onSeverityChanged;

  const SeverityFilterChip({
    super.key,
    required this.selectedSeverity,
    required this.onSeverityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            'All',
            'all',
            Icons.all_inclusive,
            Colors.grey,
            fontSize,
          ),
          SizedBox(width: 8),
          _buildFilterChip(
            'Low',
            'low',
            Icons.check_circle,
            Colors.green,
            fontSize,
          ),
          SizedBox(width: 8),
          _buildFilterChip(
            'Mild',
            'mild',
            Icons.warning,
            Colors.orange,
            fontSize,
          ),
          SizedBox(width: 8),
          _buildFilterChip('Risky', 'risky', Icons.error, Colors.red, fontSize),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String severity,
    IconData icon,
    Color color,
    double fontSize,
  ) {
    final isSelected = selectedSeverity == severity;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: fontSize * 24, // Fixed size
            color: isSelected ? Colors.white : color,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: isSelected ? Colors.white : color,
              fontSize: fontSize * 20, // Fixed size
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        onSeverityChanged(severity);
      },
      backgroundColor: Color(0xFF2A332A),
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? color : color.withOpacity(0.3),
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

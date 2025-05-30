// lib/features/comprehensive_health_assessment/model/gender_option.dart

import 'package:flutter/material.dart';

class GenderOption {
  final String label;
  final String iconPath; // Path to your SVG asset
  final Color selectedBackgroundColor;
  final Color selectedIconColor;
  final Color unselectedBackgroundColor; // For the greyed-out state
  final Color unselectedIconColor; // For the greyed-out state
  final String value; // The actual value to save (e.g., 'Male', 'Female', 'Other')

  GenderOption({
    required this.label,
    required this.iconPath,
    required this.selectedBackgroundColor,
    required this.selectedIconColor,
    required this.unselectedBackgroundColor,
    required this.unselectedIconColor,
    required this.value,
  });
}
// lib/utils/opening_hours_util.dart
import 'package:flutter/material.dart'; // For debugPrint
import 'package:intl/intl.dart'; // For DateFormat
import 'dart:developer' as developer; // For developer.log

class OpeningHoursUtil {
  /// Determines the current opening status of a clinic based on its opening hours.
  /// Returns "Open Now", "Currently Closed", "Hours not available", or "Hours parsing error".
  static String getOpeningStatus(List<String>? openingHours) {
    if (openingHours == null || openingHours.isEmpty) {
      return 'Hours not available';
    }

    final now = DateTime.now();
    final currentDay = DateFormat('EEEE').format(now); // e.g., "Monday"

    String? todayHoursString;
    for (var hourEntry in openingHours) {
      if (hourEntry.startsWith('$currentDay:')) {
        todayHoursString = hourEntry;
        break;
      }
    }

    if (todayHoursString == null) {
      return 'Hours not available for today';
    }

    final rawHours = todayHoursString.substring('$currentDay:'.length).trim();

    if (rawHours.toLowerCase() == 'closed') {
      return 'Currently Closed';
    }
    if (rawHours.toLowerCase() == '24 hours') {
      return 'Open Now (24 hours)';
    }

    // Use a regular expression to split by common dashes and surrounding whitespace
    // This regex matches:
    // \s* : zero or more whitespace characters (handles regular space, non-breaking space, thin space, etc.)
    // [-–—] : any of the common dash characters (hyphen-minus, en dash, em dash)
    // \s* : zero or more whitespace characters again
    final RegExp splitPattern = RegExp(r'\s*[-–—]\s*');
    final parts = rawHours.split(splitPattern);

    if (parts.length != 2) {
      developer.log('OpeningHoursUtil: Unexpected hours format for "$rawHours". Parts found: ${parts.length}. Actual parts: $parts');
      return 'Hours format unknown';
    }

    try {
      String openTimeStr = parts[0].trim();
      String closeTimeStr = parts[1].trim();

      // --- CRITICAL FIX: Normalize all whitespace characters to a single space ---
      // This replaces any sequence of whitespace characters (including non-breaking space, thin space, etc.)
      // with a single regular space. This is more robust than replacing specific Unicode characters.
      openTimeStr = openTimeStr.replaceAll(RegExp(r'\s+'), ' ');
      closeTimeStr = closeTimeStr.replaceAll(RegExp(r'\s+'), ' ');
      // --- END CRITICAL FIX ---

      developer.log('OpeningHoursUtil: Attempting to parse cleaned openTimeStr: "$openTimeStr", closeTimeStr: "$closeTimeStr"');

      final DateFormat timeFormat = DateFormat('h:mm a'); // e.g., "9:00 AM"

      final DateTime openTime = timeFormat.parse(openTimeStr);
      final DateTime closeTime = timeFormat.parse(closeTimeStr);

      final DateTime todayOpen = DateTime(now.year, now.month, now.day, openTime.hour, openTime.minute);
      DateTime todayClose = DateTime(now.year, now.month, now.day, closeTime.hour, closeTime.minute);

      // Handle cases where closing time is on the next day (e.g., 9 PM - 1 AM)
      if (todayClose.isBefore(todayOpen)) {
        todayClose = todayClose.add(const Duration(days: 1));
      }

      // Convert TimeOfDay to minutes since midnight for easy comparison
      final TimeOfDay currentTime = TimeOfDay.fromDateTime(now);
      int currentMinutes = currentTime.hour * 60 + currentTime.minute;
      int openMinutes = TimeOfDay.fromDateTime(todayOpen).hour * 60 + TimeOfDay.fromDateTime(todayOpen).minute;
      int closeMinutes = TimeOfDay.fromDateTime(todayClose).hour * 60 + TimeOfDay.fromDateTime(todayClose).minute;

      if (closeMinutes < openMinutes) { // Handles closing past midnight
        if (currentMinutes >= openMinutes || currentMinutes <= closeMinutes) {
          return 'Open Now';
        }
      } else { // Standard opening hours within the same day
        if (currentMinutes >= openMinutes && currentMinutes <= closeMinutes) {
          return 'Open Now';
        }
      }

      return 'Currently Closed';

    } catch (e) {
      developer.log('OpeningHoursUtil: Caught error parsing times: $e. Raw string: "$rawHours"');
      return 'Hours parsing error';
    }
  }
}
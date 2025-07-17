import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPermissionHandler {
  Future<bool> checkAndRequestLocationPermissions(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationDisabledDialog(context);
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showPermissionDeniedDialog(context);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermanentlyDeniedDialog(context);
      return false;
    }

    return true;
  }

  Future<void> _showLocationDisabledDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Location Services Disabled',
              style: GoogleFonts.nunito(),
            ),
            content: Text(
              'Please enable location services to find nearby doctors.',
              style: GoogleFonts.nunito(),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();
                },
                child: const Text('Go to Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Location Permission Denied',
              style: GoogleFonts.nunito(),
            ),
            content: Text(
              'Please allow location access to find nearby doctors.',
              style: GoogleFonts.nunito(),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.requestPermission();
                },
                child: const Text('Grant Permission'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  Future<void> _showPermanentlyDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Permission Permanently Denied'),
            content: const Text(
              'Please enable location access in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }
}

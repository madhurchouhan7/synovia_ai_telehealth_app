// lib/services/doctor_search_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';

class DoctorSearchService {
  final String _placesApiKey =
      dotenv
          .env['GOOGLE_PLACES_API_KEY']!; // Ensure this matches your .env key name

  // Function to get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
        'Location services are disabled. Please enable them.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          'Location permissions are denied. Please grant them in settings.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Doctor?> _fetchPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId&'
        'fields=name,formatted_address,vicinity,geometry,rating,user_ratings_total,photos,formatted_phone_number,opening_hours/weekday_text&'
        'key=$_placesApiKey';

    developer.log(
      'DoctorSearchService: Calling Place Details API for $placeId',
    ); // Changed from print
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          return Doctor.fromPlaceDetailsJson(data['result']);
        } else {
          developer.log(
            // Changed from print
            'DoctorSearchService: Google Place Details API Error for $placeId: ${data['status']} - ${data['error_message']}',
          );
          return null;
        }
      } else {
        developer.log(
          // Changed from print
          'DoctorSearchService: HTTP Error from Place Details API for $placeId: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      developer.log(
        'DoctorSearchService: Error fetching place details for $placeId: $e',
      ); // Changed from print
      return null;
    }
  }

  Future<List<Doctor>> searchNearbyDoctors(String specialistType) async {
    developer.log(
      'DoctorSearchService: Starting search for: "$specialistType"',
    );
    final overallStopwatch = Stopwatch()..start(); // Overall stopwatch

    List<Doctor> doctors = [];
    try {
      final positionStopwatch = Stopwatch()..start();
      final position = await _getCurrentLocation();
      positionStopwatch.stop();
      developer.log(
        'DoctorSearchService: _getCurrentLocation took: ${positionStopwatch.elapsedMilliseconds}ms',
      );

      final lat = position.latitude;
      final lng = position.longitude;

      final String textSearchUrl =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?'
          'query=${Uri.encodeComponent(specialistType)} doctor near me&'
          'location=$lat,$lng&'
          'radius=5000&'
          'type=doctor&'
          'key=$_placesApiKey';

      developer.log(
        'DoctorSearchService: Calling Places Text Search API: $textSearchUrl',
      );
      final textSearchResponseStopwatch = Stopwatch()..start();
      final response = await http.get(Uri.parse(textSearchUrl));
      textSearchResponseStopwatch.stop();
      developer.log(
        'DoctorSearchService: Places Text Search API took: ${textSearchResponseStopwatch.elapsedMilliseconds}ms',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          developer.log(
            'DoctorSearchService: Found ${data['results'].length} initial places from Text Search.',
          );

          // --- CRITICAL FIX: Parallelize Place Details API calls ---
          List<Future<Doctor?>> detailFutures = [];
          for (var place in data['results']) {
            if (place['place_id'] != null) {
              detailFutures.add(_fetchPlaceDetails(place['place_id']));
            } else {
              // If no place_id, just add a basic doctor object if possible
              detailFutures.add(Future.value(Doctor.fromJson(place)));
            }
          }

          final placeDetailsParallelStopwatch = Stopwatch()..start();
          final List<Doctor?> detailedDoctors = await Future.wait(
            detailFutures,
          );
          placeDetailsParallelStopwatch.stop();
          developer.log(
            'DoctorSearchService: Parallel Place Details API calls took: ${placeDetailsParallelStopwatch.elapsedMilliseconds}ms for ${detailFutures.length} futures.',
          );

          for (var doctor in detailedDoctors) {
            if (doctor != null) {
              doctors.add(doctor);
            }
          }
          // --- END CRITICAL FIX ---

          developer.log(
            'DoctorSearchService: Successfully fetched details for ${doctors.length} doctors.',
          );
          return doctors;
        } else {
          developer.log(
            'DoctorSearchService: Google Places Text Search API Error: ${data['status']} - ${data['error_message']}',
          );
          return [];
        }
      } else {
        developer.log(
          'DoctorSearchService: HTTP Error from Places API: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      developer.log('DoctorSearchService: Overall error searching doctors: $e');
      return []; // Return empty list on error
    } finally {
      overallStopwatch.stop();
      developer.log(
        'DoctorSearchService: Total searchNearbyDoctors duration: ${overallStopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  String? getPhotoUrl(String? photoReference, {int maxWidth = 400}) {
    if (photoReference == null) return null;
    return 'https://maps.googleapis.com/maps/api/place/photo?'
        'maxwidth=$maxWidth&photoreference=$photoReference&key=$_placesApiKey';
  }
}

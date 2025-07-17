// lib/models/doctor.dart
class Doctor {
  final String name;
  final String address;
  final String? formattedAddress;
  final String? vicinity;
  final double latitude;
  final double longitude;
  final double? rating;
  final int? userRatingsTotal;
  final String? photoReference;
  final String? phoneNumber; 
  final List<String>? openingHours; 
  final String? placeId;

  Doctor({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.userRatingsTotal,
    this.photoReference,
    this.phoneNumber, 
    this.openingHours,
    this.formattedAddress,
    this.vicinity,
    this.placeId,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Extract photo reference if available
    String? photoRef;
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      photoRef = json['photos'][0]['photo_reference'];
    }

    return Doctor(
      name: json['name'] ?? 'Unknown Doctor',
      address:
          json['vicinity'] ?? json['formatted_address'] ?? 'Unknown Address',
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      photoReference: photoRef,
      phoneNumber: null,
      openingHours: null,
      formattedAddress: json['formatted_address'],
      vicinity: json['vicinity'],
      placeId: json['place_id'], 
    );
  }

  factory Doctor.fromPlaceDetailsJson(Map<String, dynamic> json) {
    String? photoRef;
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      photoRef = json['photos'][0]['photo_reference'];
    }

    List<String>? hours;
    if (json['opening_hours'] != null &&
        json['opening_hours']['weekday_text'] != null) {
      hours = List<String>.from(json['opening_hours']['weekday_text']);
    }

    return Doctor(
      name: json['name'] ?? 'Unknown Doctor',
      address:
          json['vicinity'] ?? json['formatted_address'] ?? 'Unknown Address',
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      photoReference: photoRef,
      phoneNumber: json['formatted_phone_number'], // Direct phone number
      openingHours: hours, // Weekday text for hours
      formattedAddress: json['formatted_address'],
      vicinity: json['vicinity'],
      placeId: json['place_id'], // Place ID for detailed info
    );
  }
}

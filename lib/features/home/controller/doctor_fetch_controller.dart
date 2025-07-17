import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/services/doctor_search_service.dart';

class DoctorFetchController {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final DoctorSearchService _doctorSearchService;

  DoctorFetchController({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required DoctorSearchService doctorSearchService,
  })  : _auth = auth,
        _firestore = firestore,
        _doctorSearchService = doctorSearchService;

  /// Loads specialist from cache
  Future<String> loadCachedSpecialist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastRecommendedSpecialist') ?? 'General Physician';
  }

  /// Save specialist to cache
  Future<void> cacheSpecialist(String specialist) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastRecommendedSpecialist', specialist);
  }

  /// Gets specialist from Firestore
  Future<String> fetchSpecialistFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return 'General Physician';

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists && userDoc.data()?['recommendedSpecialist'] != null) {
      return userDoc['recommendedSpecialist'];
    }
    return 'General Physician';
  }

  /// Searches for nearby doctors based on specialist
  Future<List<Doctor>> searchNearbyDoctors(String specialist) async {
    return await _doctorSearchService.searchNearbyDoctors(specialist);
  }
}

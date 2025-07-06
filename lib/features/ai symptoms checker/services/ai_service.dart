// lib/features/ai symptoms checker/services/ai_service.dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class AIService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> getPersonalizedMedicalAdvice(String symptoms) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      String? idToken;
      if (currentUser != null) {
        idToken = await currentUser.getIdToken();
        log('AIService: FirebaseAuth currentUser UID: ${currentUser.uid}');
        log('AIService: FirebaseAuth currentUser ID Token (first 20 chars): ${idToken?.substring(0, 20)}...');
      } else {
        log('AIService: FirebaseAuth currentUser is NULL before calling Cloud Function. Cannot get ID token.');
      }

      final HttpsCallable callable = _functions.httpsCallable('getPersonalizedMedicalAdvice');
      log('AIService: Calling Cloud Function with symptoms: $symptoms');

      final Map<String, dynamic> payload = {
        'symptoms': symptoms,
      };
      if (idToken != null) {
        payload['idToken'] = idToken; // Manually add the ID token to the payload
        log('AIService: Manually adding ID token to payload.');
      }

      // --- NEW LOG: Log the final payload before sending ---
      log('AIService: Final payload being sent to Cloud Function: $payload');
      // --- END NEW LOG ---

      final HttpsCallableResult result = await callable.call(payload);

      log('AIService: Cloud Function raw result data: ${result.data}');

      if (result.data is Map<String, dynamic>) {
        return result.data as Map<String, dynamic>;
      } else {
        log('AIService: Unexpected Cloud Function response type: ${result.data.runtimeType}');
        return {'error': 'Unexpected response format from AI service'};
      }
    } on FirebaseFunctionsException catch (e) {
      log('AIService: FirebaseFunctionsException: code=${e.code}, message=${e.message}, details=${e.details}');
      return {'error': 'AI service error: ${e.message}'};
    } catch (e) {
      log('AIService: General error calling Cloud Function: $e');
      return {'error': 'AI service error: INTERNAL'};
    }
  }
}
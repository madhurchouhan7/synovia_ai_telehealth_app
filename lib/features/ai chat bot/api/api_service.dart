// lib/services/api_service.dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> initializeFirebaseIfNeeded() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

Future<Map<String, dynamic>> getPersonalizedMedicalAdvice(
  String symptoms,
) async {
  await initializeFirebaseIfNeeded();

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Error: User not logged in. Cannot get personalized advice.');
    return {
      'error': 'User not logged in. Please log in to get personalized advice.',
    };
  }

  try {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getPersonalizedMedicalAdvice',
    );

    // Pass data directly for https.onCall
    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'symptoms': symptoms,
      // No need to pass idToken explicitly for https.onCall
    });

    // The result.data is directly the map returned by the function
    if (result.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(result.data);
    } else {
      print(
        'Flutter: Unexpected response format from Cloud Function: ${result.data}',
      );
      return {'error': 'Received unexpected data format from AI service.'};
    }
  } on FirebaseFunctionsException catch (e) {
    print(
      'Flutter: Firebase Functions Error: Code: ${e.code}, Message: ${e.message}, Details: ${e.details}',
    );
    return {'error': 'AI service error: ${e.message}'};
  } catch (e) {
    print('Flutter: General Error calling AI service: $e');
    return {
      'error': 'An unexpected error occurred while contacting AI service.',
    };
  }
}

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Needed if you plan to fetch data on client side (though Cloud Function is better)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization

/// Initializes Firebase if it hasn't been already.
/// This should typically be called once at the start of your application (e.g., in main.dart).
Future<void> initializeFirebaseIfNeeded() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

/// Calls the Firebase Cloud Function to get personalized medical advice from Gemini.
///
/// This function handles:
/// 1. Ensuring the user is authenticated.
/// 2. Calling the 'getPersonalizedMedicalAdvice' Cloud Function.
/// 3. Handling potential errors from the Cloud Function or network issues.
///
/// Returns a [Map<String, dynamic>] containing the AI's severity classification
/// and advice, or an 'error' message if something goes wrong.
///
/// The Cloud Function (backend) is responsible for:
/// - Fetching the user's personal health data from Firestore.
/// - Constructing the personalized prompt for Gemini.
/// - Calling the Gemini API.
/// - Parsing Gemini's response.
/// - Updating the user's Firestore document with the latest symptom severity.
/// - Returning the structured AI response to this Flutter client.
Future<Map<String, dynamic>> getPersonalizedMedicalAdvice(String symptoms) async {
  // Ensure Firebase is initialized before making any calls
  await initializeFirebaseIfNeeded();

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // If no user is logged in, return an error.
    // In a real app, you might redirect to a login screen or handle anonymously.
    print('Error: User not logged in. Cannot get personalized advice.');
    return {'error': 'User not logged in. Please log in to get personalized advice.'};
  }

  try {
    // Get an instance of the Cloud Functions callable function.
    // The name 'getPersonalizedMedicalAdvice' must match the name you export in your Firebase Cloud Function.
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getPersonalizedMedicalAdvice');

    // Call the Cloud Function with the user's symptoms.
    // The Cloud Function will use the authenticated user's ID to fetch their personal data.
    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'symptoms': symptoms,
      // No need to send userData from the client; the Cloud Function fetches it securely.
    });

    // The 'result.data' contains the response from your Cloud Function.
    // Ensure your Cloud Function returns a Map<String, dynamic> that can be cast here.
    if (result.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(result.data);
    } else {
      print('Error: Unexpected response format from Cloud Function: ${result.data}');
      return {'error': 'Received unexpected data format from AI service.'};
    }
  } on FirebaseFunctionsException catch (e) {
    // Handle errors specifically from Firebase Cloud Functions
    print('Firebase Functions Error: Code: ${e.code}, Message: ${e.message}, Details: ${e.details}');
    return {'error': 'AI service error: ${e.message}'};
  } catch (e) {
    // Catch any other unexpected errors
    print('General Error calling AI service: $e');
    return {'error': 'An unexpected error occurred while contacting AI service.'};
  }
}

// You might also define a simple model for the AI response if you want more type safety
// class AiResponse {
//   final String severity;
//   final String advice;
//
//   AiResponse({required this.severity, required this.advice});
//
//   factory AiResponse.fromJson(Map<String, dynamic> json) {
//     return AiResponse(
//       severity: json['severity'] as String,
//       advice: json['advice'] as String,
//     );
//   }
// }

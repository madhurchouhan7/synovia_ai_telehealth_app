import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  late final GoogleSignIn _googleSignIn;
  bool _initialized = false;

  Future<void> initializeGoogleSignIn() async {
    if (_initialized) return;

    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '182417883732-5tud5417v5rit6o74e08ti6j5nsj2r34.apps.googleusercontent.com',
      );

      // Assign the singleton instance
      _googleSignIn = GoogleSignIn.instance;
      _initialized = true;
    } catch (e) {
      print('GoogleSignIn initialization failed: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    await initializeGoogleSignIn();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken is not required anymore
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    if (_initialized) await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

//   Future<GoogleSignInAccount?> attemptSilentSignIn() async {
//     await initializeGoogleSignIn();

//     try {
//       final result = _googleSignIn.attemptLightweightAuthentication();
//       final account =
//           result is Future ? await result : result as GoogleSignInAccount?;

//       if (account != null && FirebaseAuth.instance.currentUser == null) {
//         final googleAuth = await account.authentication;
//         final credential = GoogleAuthProvider.credential(
//           idToken: googleAuth.idToken,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//       }

//       return account;
//     } catch (e) {
//       print('Silent sign-in failed: $e');
//       return null;
//     }
//   }
 }

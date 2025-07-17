// import 'package:flutter/material.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseSignInPage extends StatelessWidget {
//   const FirebaseSignInPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SignInScreen(
//       providers: [
//         GoogleProvider(
//           clientId:
//               '182417883732-5tud5417v5rit6o74e08ti6j5nsj2r34.apps.googleusercontent.com',
//         ),
//       ],
//       actions: [
//         AuthStateChangeAction<SignedIn>((context, state) {
//           // Don’t navigate manually anymore.
//           // Let main.dart handle it via StreamBuilder.
//         }),
//         AuthStateChangeAction<AuthFailed>((context, state) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Sign in failed: ${state.exception}')),
//           );
//         }),
//       ],
//     );
//   }
// }

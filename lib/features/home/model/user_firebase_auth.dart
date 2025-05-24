import 'package:firebase_auth/firebase_auth.dart';

class UserFirebaseAuth {
  User? currentUser;

  UserFirebaseAuth(){

    // get photo and name of the logged in user 
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? displayName = currentUser?.displayName;
      String? photoURL = currentUser?.photoURL;

      // Do something with the display name and photo URL
      print('Display Name: $displayName');
      print('Photo URL: $photoURL');
    } else {
      print('No user is currently logged in.');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        backgroundColor: Color(0xFF212C24),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Notifications Screen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Future<void> saveFcmToken(String userId) async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken != null) {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fcmToken': fcmToken,
    });
  }
}

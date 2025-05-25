import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF212C24),
      ),
      body: Center(
        child: Text('Profile Screen', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(
                    'Logout',
                    style: GoogleFonts.nunito(color: Colors.white),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.nunito(color: lightTextColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.nunito(color: brandColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.nunito(color: brandColor),
                      ),
                    ),
                  ],
                ),
          );
          if (shouldLogout == true) {
            await FirebaseAuth.instance.signOut();
          }
        },
        backgroundColor: Color(0xFF212C24),
        child: Icon(Icons.logout_outlined, color: Colors.white),
      ),
    );
  }
}

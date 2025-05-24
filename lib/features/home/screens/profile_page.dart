import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile', style: GoogleFonts.nunito(color: Colors.white)),
        backgroundColor: Color(0xFF212C24),
      ),
      body: Center(
        child: Text('Profile Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

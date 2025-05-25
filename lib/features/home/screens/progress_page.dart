import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Progress',
          style: GoogleFonts.nunito(color: Colors.white),
        ),

        backgroundColor: Color(0xFF212C24),
      ),
      body: Center(
        child: Text('Progress Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

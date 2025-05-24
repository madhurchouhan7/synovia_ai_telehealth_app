import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

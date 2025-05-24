import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Synovia AI',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        backgroundColor: Color(0xFF212C24),
      ),
      body: Center(
        child: Text('Synovia AI Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

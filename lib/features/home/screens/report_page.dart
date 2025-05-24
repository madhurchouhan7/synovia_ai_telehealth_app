import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/boxes.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/chat_history.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/chat_history_widget.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/empty_history_widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Report', style: GoogleFonts.nunito(color: Colors.white)),
        backgroundColor: Color(0xFF212C24),
      ),
      body: ValueListenableBuilder<Box<ChatHistory>>(
        valueListenable: Boxes.getChatHistory().listenable(),
        builder: (context, box, _) {
          final chatHistory =
              box.values.toList().cast<ChatHistory>().reversed.toList();
          return chatHistory.isEmpty
              ? const EmptyHistoryWidget()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = chatHistory[index];
                    return ChatHistoryWidget(chat: chat);
                  },
                ),
              );
        },
      ),
    );
  }
}

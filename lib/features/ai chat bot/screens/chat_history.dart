import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/boxes.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/chat_history.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/chat_history_widget.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/empty_history_widget.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: const Text('Chat history'),
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
        ));
  }
}
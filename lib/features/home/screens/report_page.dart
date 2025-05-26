import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/boxes.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/chat_history.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/chat_history_widget.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/empty_history_widget.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  late UniqueKey _reportTabKey;

  @override
  void initState() {
    super.initState();
    _reportTabKey = UniqueKey();
  }

  @override
  void didUpdateWidget(covariant ReportPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This will trigger animation when the widget is rebuilt (e.g., when navigating back to this tab)
    _restartReportTabAnimation();
  }

  void _restartReportTabAnimation() {
    setState(() {
      _reportTabKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Report',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                  reverse: true,
                  key: _reportTabKey,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = chatHistory[index];
                    return AnimatedEntrance(
                      child: ChatHistoryWidget(chat: chat),
                      slideBegin: const Offset(0, 0.2),
                      delay: Duration(milliseconds: 500 * index),
                    );
                  },
                ),
              );
        },
      ),
    );
  }
}

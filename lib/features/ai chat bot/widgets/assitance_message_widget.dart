import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gemini avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/icons/app_icons/icon.png'),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 8),
              child:
                  message.isEmpty
                      ? const SizedBox(
                        width: 50,
                        child: SpinKitThreeBounce(
                          color: brandColor,
                          size: 20.0,
                        ),
                      )
                      : MarkdownBody(
                        selectable: true,
                        data: message,
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          // You can style other markdown elements here as well
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class AssistantMessageWidget extends StatefulWidget {
  const AssistantMessageWidget({super.key, required this.message});

  final String message;

  @override
  State<AssistantMessageWidget> createState() => _AssistantMessageWidgetState();
}

class _AssistantMessageWidgetState extends State<AssistantMessageWidget> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant AssistantMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _resetTyping();
      _startTyping();
    }
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (_currentIndex < widget.message.length) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.message.substring(0, _currentIndex);
        });
      } else {
        timer.cancel();
        setState(() {
          _showCursor = false;
        });
      }
    });
    // Blinking cursor
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_currentIndex >= widget.message.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  void _resetTyping() {
    _timer?.cancel();
    _currentIndex = 0;
    _displayedText = '';
    _showCursor = true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of main words to highlight
    final mainWords = [
      'classification',
      'Reasoning',
      'Recommended Specialist',
      'Advice',
    ];

    // Function to wrap main words in ** for bold
    String highlightMainWords(String text) {
      String result = text;
      for (final word in mainWords) {
        // Use regex to match the word case-insensitively and not inside other words
        result = result.replaceAllMapped(
          RegExp(
            '(?<![\\w])(' + RegExp.escape(word) + ')(?![\\w])',
            caseSensitive: false,
          ),
          (match) => '**${match[0]}**',
        );
      }
      return result;
    }

    final processedText = highlightMainWords(_displayedText);

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
                  widget.message.isEmpty
                      ? const SizedBox(
                        width: 50,
                        child: SpinKitThreeBounce(
                          color: brandColor,
                          size: 20.0,
                        ),
                      )
                      : MarkdownBody(
                        selectable: true,
                        data:
                            processedText +
                            (_showCursor &&
                                    _currentIndex < widget.message.length
                                ? '|'
                                : ''),
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          strong: GoogleFonts.nunito(
                            color: brandColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

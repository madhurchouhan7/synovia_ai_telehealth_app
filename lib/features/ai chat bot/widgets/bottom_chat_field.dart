import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/models/message.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/chat_provider.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/preview_image_widget.dart';
import 'package:synovia_ai_telehealth_app/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.chatProvider,
    this.onInputControllerReady,
  });

  final ChatProvider chatProvider;
  final void Function(TextEditingController)? onInputControllerReady;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.onInputControllerReady != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInputControllerReady!(textController);
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage({
    required String message,
    required ChatProvider chatProvider,
    required bool isTextOnly,
  }) async {
    textController.clear();
    widget.chatProvider.setImagesFileList(listValue: []);
    textFieldFocus.unfocus(); // Unfocus keyboard immediately

    try {
      await chatProvider.sentMessage(message: message, isTextOnly: isTextOnly);

      final contextToUse = context;
      contextToUse.read<SymptomsHistoryProvider>().loadActiveSymptoms();
      contextToUse.read<SymptomsHistoryProvider>().loadSymptomsHistory();
      // --- END REFRESH ---
    } catch (e) {
      log('error : $e');
    }
  }

  void pickImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      widget.chatProvider.setImagesFileList(listValue: pickedImages);
    } catch (e) {
      log('error : $e');
    }
  }

  Future<void> sendSymptomToFirebase(String message) async {
    try {
      widget.chatProvider.setLoading(value: true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('User not logged in');
        return;
      }

      await user.getIdToken(true);
      final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
      final response = await functions.httpsCallable('analyzeSymptoms').call({
        'uid': user.uid,
        'symptom': message,
      });

      final Map<String, dynamic> result = Map<String, dynamic>.from(
        response.data,
      );

      final chatId = widget.chatProvider.getChatId();

      final userMessage = Message(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        role: Role.user,
        message: StringBuffer(message),
        timeSent: DateTime.now(),
        imagesUrls: [],
      );

      final assistantMessage = Message(
        messageId:
            DateTime.now()
                .add(Duration(seconds: 1))
                .millisecondsSinceEpoch
                .toString(),
        chatId: chatId,
        role: Role.assistant,
        message: StringBuffer(),
        timeSent: DateTime.now(),
        imagesUrls: [],
      );

      widget.chatProvider.inChatMessages.add(userMessage);
      widget.chatProvider.setCurrentChatId(newChatId: chatId);
      widget.chatProvider.notifyListeners();

      widget.chatProvider.inChatMessages.add(assistantMessage);
      widget.chatProvider.notifyListeners();

      await Future.delayed(Duration(milliseconds: 500));

      final responseText = '''Summary: ${result['summary']}

Risk Level: ${result['risk_level']}
Recommendations: ${result['recommendations']}
Doctor Type: ${result['specialization']}''';

      final index = widget.chatProvider.inChatMessages.indexWhere(
        (msg) => msg.messageId == assistantMessage.messageId,
      );

      if (index != -1) {
        widget.chatProvider.inChatMessages[index] = widget
            .chatProvider
            .inChatMessages[index]
            .copyWith(message: StringBuffer(responseText));
        widget.chatProvider.notifyListeners();
      }
    } catch (e) {
      log("Error calling analyzeSymptoms: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze symptoms. Please try again.'),
        ),
      );
    } finally {
      widget.chatProvider.setLoading(value: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImages =
        widget.chatProvider.imagesFileList != null &&
        widget.chatProvider.imagesFileList!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).textTheme.titleLarge!.color!,
        ),
      ),
      child: Column(
        children: [
          if (hasImages) const PreviewImagesWidget(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (hasImages) {
                    showMyAnimatedDialog(
                      context: context,
                      title: 'Delete Images',
                      content: 'Are you sure you want to delete the images?',
                      actionText: 'Delete',
                      onActionPressed: (value) {
                        if (value) {
                          widget.chatProvider.setImagesFileList(listValue: []);
                        }
                      },
                    );
                  } else {
                    pickImage();
                  }
                },
                icon: Icon(hasImages ? Icons.delete_forever : Icons.image),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    focusNode: textFieldFocus,
                    controller: textController,
                    textInputAction: TextInputAction.send,
                    onSubmitted:
                        widget.chatProvider.isLoading
                            ? null
                            : (String value) {
                              if (value.isNotEmpty) {
                                sendChatMessage(
                                  message: textController.text,
                                  chatProvider: widget.chatProvider,
                                  isTextOnly: hasImages ? false : true,
                                );
                              }
                            },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Write a prompt...',
                      hintStyle: GoogleFonts.nunito(fontSize: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap:
                    widget.chatProvider.isLoading
                        ? null
                        : () {
                          if (textController.text.isNotEmpty) {
                            sendChatMessage(
                              message: textController.text,
                              chatProvider: widget.chatProvider,
                              isTextOnly: hasImages ? false : true,
                            );
                          }
                        },
                child: Container(
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/chat_provider.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/bottom_chat_field.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/chat_message.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:synovia_ai_telehealth_app/utils/utilities.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {
  // scroll controller

  final ScrollController _scrollController = ScrollController();
  final List<String> _quickPrompts = [
    'I have mild headache from morning',
    'I am feeling tired and dizzy',
    'I have a sore throat and cough',
  ];
  TextEditingController? _inputController;

  @override
  void dispose() {
    _scrollController.dispose();
    // Don't dispose _inputController here as it's managed by BottomChatField
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load active symptoms when chat page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SymptomsHistoryProvider>().loadActiveSymptoms();
    });
  }

  void _setInputController(TextEditingController controller) {
    _inputController = controller;
  }

  void _onPromptTap(String prompt) {
    if (_inputController != null) {
      _inputController!.text = prompt;
      _inputController!.selection = TextSelection.fromPosition(
        TextPosition(offset: prompt.length),
      );
      FocusScope.of(
        context,
      ).requestFocus(FocusNode()); // Optionally close keyboard
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // Remove addListener from build to avoid performance issues
        if (chatProvider.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }

        // Instead, use an effect to scroll after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (chatProvider.inChatMessages.isNotEmpty) {
            _scrollToBottom();
          }
        });

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF212C24),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: darkBackgroundColor,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: darkBackgroundColor,
            appBar: AppBar(
              backgroundColor: Color(0xFF212C24),
              centerTitle: true,
              title: Text(
                'Synovia AI Chat',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                if (chatProvider.inChatMessages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: brandColor,
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () async {
                          showMyAnimatedDialog(
                            context: context,
                            title: 'Start New Chat',
                            content:
                                'Are you sure you want to start a new chat?',
                            actionText: 'Yes',
                            onActionPressed: (value) async {
                              if (value) {
                                await chatProvider.prepareChatRoom(
                                  isNewChat: true,
                                  chatID: '',
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          chatProvider.inChatMessages.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedEntrance(
                                      child: SvgPicture.asset(
                                        SvgAssets.welcome_logo,
                                      ),
                                      slideBegin: const Offset(0, 0.5),
                                      delay: const Duration(milliseconds: 500),
                                    ),
                                    SizedBox(height: screenWidth * 0.05),
                                    Text(
                                      'Hello, ${displayName.split(' ').first} ! 👋🏻',
                                      style: GoogleFonts.nunito(
                                        fontSize: fontSize * 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: screenWidth * 0.02),
                                    Text(
                                      'How can I assist you today ?',
                                      style: GoogleFonts.nunito(
                                        fontSize: fontSize * 25,
                                        color: lightTextColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: screenWidth * 0.04),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.center,
                                      children:
                                          _quickPrompts
                                              .map(
                                                (prompt) => ActionChip(
                                                  label: Text(
                                                    prompt,
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  backgroundColor: brandColor
                                                      .withOpacity(0.15),
                                                  labelStyle: TextStyle(
                                                    color: brandColor,
                                                  ),
                                                  onPressed:
                                                      () =>
                                                          _onPromptTap(prompt),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              )
                              : ChatMessages(
                                scrollController: _scrollController,
                                chatProvider: chatProvider,
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: BottomChatField(
                      chatProvider: chatProvider,
                      onInputControllerReady: _setInputController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

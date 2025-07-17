import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20symptoms%20checker/services/ai_service.dart';
import 'package:uuid/uuid.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/constant.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/boxes.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/chat_history.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/settings.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/user_model.dart'; // Assuming this is for app user data, not just chat user
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/models/message.dart'; // Your Message model

class ChatProvider extends ChangeNotifier {
  // list of messages displayed in the current chat
  final List<Message> _inChatMessages = [];

  // page controller (for multi-page UI, if applicable)
  final PageController _pageController = PageController();

  // images file list for multi-modal input
  List<XFile>? _imagesFileList = [];

  // index of the current screen (if using PageView)
  int _currentIndex = 0;

  // current active chat ID
  String _currentChatId = '';

  // GenerativeModel instances for direct Gemini API calls (used for vision/image input)
  GenerativeModel?
  _model; // General model, will be vision model when images are present
  GenerativeModel?
  _textModel; // Specific for text-only direct calls (less used now)
  GenerativeModel? _visionModel; // Specific for vision/multi-modal direct calls

  // current model type string
  String _modelType =
      'gemini-pro'; 

  // loading boolean to indicate AI processing
  bool _isLoading = false;
  final AIService _aiService = AIService();

  // --- Getters ---
  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  // --- Setters / Initializers ---

  /// Sets the in-chat messages by loading them from Hive for a given chat ID.
  Future<void> setInChatMessages({required String chatId}) async {
    // Clear existing messages to load fresh history
    _inChatMessages.clear();
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);

    for (var message in messagesFromDB) {
      // Add messages from DB, avoiding duplicates if logic allows (though clear() prevents this)
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  /// Loads messages from the Hive database for a specific chat ID.
  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    // Open the box for this chatID
    final messageBox = await Hive.openBox(
      '${Constants.chatMessagesBox}$chatId',
    );

    final newData =
        messageBox.keys.map((e) {
          final message = messageBox.get(e);
          final messageData = Message.fromMap(
            Map<String, dynamic>.from(message),
          );
          return messageData;
        }).toList();
   
    return newData;
  }

  /// Sets the list of selected images for multi-modal input.
  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  
  Future<void> setModel({required bool isTextOnly}) async {
   
    if (isTextOnly) {
      
      _model =
          _textModel ??= GenerativeModel(
            model: setCurrentModel(
              newModel: 'gemini-2.0-flash',
            ), // Using gemini-pro for text
            apiKey: getApiKey(),
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    } else {
      // This path is for multi-modal (text + image) input, which still uses direct Gemini API.
      _model =
          _visionModel ??= GenerativeModel(
            model: setCurrentModel(
              newModel: 'gemini-2.0-flash',
            ), // Using gemini-1.5-flash for vision
            apiKey: getApiKey(),
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    }
    notifyListeners();
  }

  /// Retrieves the API key from environment variables.
  String getApiKey() {
    return dotenv.env['GEMINI_API_KEY'].toString();
  }

  /// Sets the current page index (for PageView).
  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  /// Sets the current chat ID.
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  /// Sets the loading state.
  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  /// Gets the current chat loading state
  bool get isLoadingChat => _isLoading;

  /// Checks if the chat has any messages
  bool get hasMessages => _inChatMessages.isNotEmpty;

  /// Gets the last message in the chat
  Message? get lastMessage =>
      _inChatMessages.isNotEmpty ? _inChatMessages.last : null;

  /// Clears all messages from current chat
  void clearCurrentChat() {
    _inChatMessages.clear();
    setCurrentChatId(newChatId: '');
    notifyListeners();
  }

  /// Updates a specific message by ID
  void updateMessage(String messageId, Message updatedMessage) {
    final index = _inChatMessages.indexWhere(
      (msg) => msg.messageId == messageId,
    );
    if (index != -1) {
      _inChatMessages[index] = updatedMessage;
      notifyListeners();
    }
  }

  /// Removes a message by ID
  void removeMessage(String messageId) {
    _inChatMessages.removeWhere((msg) => msg.messageId == messageId);
    notifyListeners();
  }

  /// Deletes all messages for a given chat ID from Hive.
  Future<void> deleteChatMessages({required String chatId}) async {
    final boxName = '${Constants.chatMessagesBox}$chatId';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).clear();
      await Hive.box(boxName).close();
    } else {
      await Hive.openBox(boxName);
      await Hive.box(boxName).clear();
      await Hive.box(boxName).close();
    }

    // If the deleted chat is the currently active one, clear in-memory messages
    if (currentChatId.isNotEmpty && currentChatId == chatId) {
      setCurrentChatId(newChatId: '');
      _inChatMessages.clear();
      notifyListeners();
    }
  }

  /// Prepares the chat room by loading history or clearing messages for a new chat.
  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    if (!isNewChat) {
      await setInChatMessages(chatId: chatID); // Load existing messages
      setCurrentChatId(newChatId: chatID);
    } else {
      _inChatMessages.clear(); // Clear for new chat
      setCurrentChatId(newChatId: chatID);
    }
    notifyListeners(); // Notify after preparing the room
  }


  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    setLoading(value: true); // Set loading true at the start

    String chatId = getChatId(); // Get or generate chat ID

    // User message object
    final userMessage = Message(
      messageId: const Uuid().v4(), // Use UUID for unique message ID
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: getImagesUrls(isTextOnly: isTextOnly),
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage); // Add user message to UI immediately
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    if (isTextOnly) {
      // --- PERSONALIZED AI RESPONSE VIA CLOUD FUNCTION ---
      final assistantMessageId = const Uuid().v4(); // Unique ID for AI message
      final assistantMessagePlaceholder = Message(
        messageId: assistantMessageId,
        chatId: chatId,
        role: Role.assistant,
        message: StringBuffer('Thinking...'), // Placeholder text
        imagesUrls: [],
        timeSent: DateTime.now(),
      );
      _inChatMessages.add(assistantMessagePlaceholder);
      notifyListeners();

      try {
        // Call the Cloud Function for personalized advice
        final aiResponse = await _aiService.getPersonalizedMedicalAdvice(message);

        if (aiResponse['error'] != null) {
          // Update the placeholder message with error
          final index = _inChatMessages.indexWhere(
            (msg) => msg.messageId == assistantMessageId,
          );
          if (index != -1) {
            _inChatMessages[index] = _inChatMessages[index].copyWith(
              message: StringBuffer('Error: ${aiResponse['error']}'),
              isError: true,
            );
          }
          log('Error from personalized AI: ${aiResponse['error']}');
        } else {
          // Update the placeholder message with the actual AI response
          final index = _inChatMessages.indexWhere(
            (msg) => msg.messageId == assistantMessageId,
          );
          if (index != -1) {
            _inChatMessages[index] = _inChatMessages[index].copyWith(
              message: StringBuffer(aiResponse['advice']),
              severity: aiResponse['severity'], // Store the severity
            );
          }
          log(
            'Personalized AI response: ${aiResponse['advice']} (Severity: ${aiResponse['severity']})',
          );

          // Save messages to Hive DB
          final messagesBox = await Hive.openBox(
            '${Constants.chatMessagesBox}$chatId',
          );
          await saveMessagesToDB(
            chatID: chatId,
            userMessage: userMessage,
            assistantMessage:
                _inChatMessages[index], // Save the updated AI message
            messagesBox: messagesBox,
          );
        }
      } catch (e) {
        log('Exception calling personalized AI: $e');
        final index = _inChatMessages.indexWhere(
          (msg) => msg.messageId == assistantMessageId,
        );
        if (index != -1) {
          _inChatMessages[index] = _inChatMessages[index].copyWith(
            message: StringBuffer('An unexpected error occurred.'),
            isError: true,
          );
        }
      } finally {
        setLoading(value: false); // Always reset loading
        notifyListeners();
      }
    } else {
      
      await setModel(isTextOnly: false); // Ensure vision model is initialized

      List<Content> history = await getHistory(
        chatId: chatId,
      ); // Get chat history for context

      await sendMessageAndWaitForResponse(
        message: message,
        chatId: chatId,
        isTextOnly: false, // Explicitly false for this branch
        history: history,
        userMessage: userMessage,
        modelMessageId: const Uuid().v4(), // New UUID for assistant message
        messagesBox: await Hive.openBox('${Constants.chatMessagesBox}$chatId'),
      );
      // setLoading and notifyListeners are handled within sendMessageAndWaitForResponse for this path
    }
  }

  /// Sends message to the direct Gemini model and waits for streamed response.
  /// This method is now primarily used for multi-modal (text + image) input.
  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
    required String modelMessageId,
    required Box messagesBox,
  }) async {
    // Ensure the model is ready for direct API calls (especially vision model)
    if (_model == null) {
      log('Error: Gemini model not initialized for direct API call.');
      setLoading(value: false);
      _inChatMessages.add(
        Message(
          messageId: const Uuid().v4(),
          chatId: chatId,
          role: Role.assistant,
          message: StringBuffer(
            'AI model not ready. Please try again or restart the app.',
          ),
          imagesUrls: [],
          timeSent: DateTime.now(),
          isError: true,
        ),
      );
      notifyListeners();
      return;
    }

    // Start the chat session - only send history if it's text-only (though here it's image)
    // For vision models, history might not be fully supported or needed for single turn.
    final chatSession = _model!.startChat(
      history: history.isEmpty || !isTextOnly ? null : history,
    );

    final content = await getContent(message: message, isTextOnly: isTextOnly);

    // Assistant message placeholder
    final assistantMessage = Message(
      messageId: modelMessageId,
      chatId: chatId,
      role: Role.assistant,
      message: StringBuffer(), // Empty StringBuffer to append streamed text
      imagesUrls: [], // AI won't return images in this context
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(assistantMessage);
    notifyListeners();

    try {
      // Listen for streamed response from direct Gemini API
      await for (var event in chatSession.sendMessageStream(content)) {
        if (event.text != null) {
          _inChatMessages
              .firstWhere(
                (element) =>
                    element.messageId == assistantMessage.messageId &&
                    element.role.name == Role.assistant.name,
              )
              .message
              .write(event.text);
          log('Stream event: ${event.text}');
          notifyListeners(); // Update UI with each chunk
        }
      }
      log('Stream done for direct Gemini call.');

      // After stream is done, save the complete message
      await saveMessagesToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: _inChatMessages.firstWhere(
          (element) => element.messageId == assistantMessage.messageId,
        ),
        messagesBox: messagesBox,
      );
    } catch (error, stackTrace) {
      log('Error during direct Gemini stream: $error\n$stackTrace');
      // Update the assistant message with an error
      final index = _inChatMessages.indexWhere(
        (msg) => msg.messageId == assistantMessage.messageId,
      );
      if (index != -1) {
        _inChatMessages[index] = _inChatMessages[index].copyWith(
          message: StringBuffer(
            'Error getting response from AI. Please try again.',
          ),
          isError: true,
        );
      }
      notifyListeners();
    } finally {
      setLoading(value: false); // Reset loading
      notifyListeners();
    }
  }

  /// Saves user and assistant messages to Hive DB and updates chat history.
  Future<void> saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
  }) async {
    // Save the user message
    await messagesBox.add(userMessage.toMap());

    // Save the assistant message
    await messagesBox.add(assistantMessage.toMap());

    // Update chat history summary (for the chat list screen)
    final chatHistoryBox = Boxes.getChatHistory();
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompts: userMessage.message.toString(), // Store user's last prompt
      response: assistantMessage.message.toString(), // Store AI's last response
      imageUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
      // You might want to save the severity here too if ChatHistory needs it
      // severity: assistantMessage.severity,
    );
    await chatHistoryBox.put(
      chatID,
      chatHistory,
    ); // Overwrites if chatID exists

    // Close the messages box (important for Hive)
    await messagesBox.close();
  }

  /// Prepares Content object for Gemini API based on text-only or multi-modal input.
  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = _imagesFileList
          ?.map((imageFile) => imageFile.readAsBytes())
          .toList(growable: false);
      final imageBytes = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts =
          imageBytes
              .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
              .toList();
      return Content.multi([prompt, ...imageParts]);
    }
  }

  /// Extracts image URLs from the selected image files.
  List<String> getImagesUrls({required bool isTextOnly}) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imagesFileList != null) {
      for (var image in imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  /// Retrieves chat history in Gemini's Content format for multi-turn conversations.
  /// This is used for direct Gemini API calls (e.g., multi-modal chat).
  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      // Load messages from DB for the current chat
      final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
      for (var message in messagesFromDB) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }
    return history;
  }

  /// Generates a new UUID for a chat ID if no current chat ID exists.
  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  /// Initializes Hive boxes and registers adapters.
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    // Register adapters and open boxes
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }
  }
}

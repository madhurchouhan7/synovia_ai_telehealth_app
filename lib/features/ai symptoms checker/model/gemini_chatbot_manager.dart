import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20symptoms%20checker/service/chatbot_service.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/data/user_health_model.dart';

class GeminiChatbotManager {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'].toString();
  final ChatbotService _userService = ChatbotService();
  late final GenerativeModel _geminiModel;

  GeminiChatbotManager() {
    _geminiModel = GenerativeModel(apiKey: _apiKey, model: 'gemini-2.0-flash');
  }

  
}

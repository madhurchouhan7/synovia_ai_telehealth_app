import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIService {
  final apiKey = dotenv.env['API_KEY'];

  APIService() {
    if (apiKey == null || apiKey!.isEmpty) {
      throw Exception(
        'API key not found or empty. Check your .env file and dotenv loading.',
      );
    }
  }
}

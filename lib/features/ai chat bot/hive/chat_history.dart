import 'package:hive/hive.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final String prompts;

  @HiveField(2)
  final String response;

  @HiveField(3)
  final List<String> imageUrls;

  @HiveField(4)
  final DateTime timestamp;

  ChatHistory({
    required this.chatId,
    required this.prompts,
    required this.response,
    required this.imageUrls,
    required this.timestamp,
  });
}

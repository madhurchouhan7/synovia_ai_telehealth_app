
import 'package:hive/hive.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/constant.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/chat_history.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/settings.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/hive/user_model.dart';

class Boxes {
  // get the caht history box
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

  // get user box
  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);

  // get settings box
  static Box<Settings> getSettings() =>
      Hive.box<Settings>(Constants.settingsBox);
}

import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/screens/chat_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/progress_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/screens/report_page.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/home_tab_content.dart';
import 'package:synovia_ai_telehealth_app/features/profile%20page/screens/profile_page.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';

List<Widget> buildTabScreens({
  required String specialist,
  required List<Doctor> doctors,
  required bool isLoading,
  required String? error,
  required VoidCallback onRefresh,
  required VoidCallback onProfileTap,
  required VoidCallback onChatTap,
  required Key homeTabKey,
}) {
  return [
    HomeTabContent(
      key: homeTabKey,
      recommendedSpecialist: specialist,
      doctors: doctors,
      isLoading: isLoading,
      errorMessage: error,
      onRefresh: onRefresh,
      onProfileTap: onProfileTap,
      onChatTap: onChatTap,
    ),
    ProgressPage(),
    const ChatPage(),
    const ReportPage(),
    const ProfilePage(),
  ];
}

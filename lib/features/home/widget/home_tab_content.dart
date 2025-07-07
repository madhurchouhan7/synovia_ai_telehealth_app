import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20symptoms%20checker/widget/ai_symptoms_card.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/models/doctor_model.dart';
import 'package:synovia_ai_telehealth_app/features/find%20nearby%20doctors/widgets/nearby_doctors_list.dart';
import 'package:synovia_ai_telehealth_app/features/home/animations/animated_entrance.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/chat_bot_widget.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/section_title.dart';
import 'package:synovia_ai_telehealth_app/features/home/widget/user_profile_card.dart';
import 'package:synovia_ai_telehealth_app/features/resources/widget/resources_article.dart';

class HomeTabContent extends StatelessWidget {
  final String recommendedSpecialist;
  final List<Doctor> doctors;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;
  final VoidCallback onProfileTap;
  final VoidCallback onChatTap;
  final Key? key;

  const HomeTabContent({
    required this.recommendedSpecialist,
    required this.doctors,
    required this.isLoading,
    required this.errorMessage,
    required this.onRefresh,
    required this.onProfileTap,
    required this.onChatTap,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedEntrance(
          child: UserProfileCard(onProfileTap: onProfileTap),
          slideBegin: const Offset(0, -0.5),
          delay: const Duration(milliseconds: 500),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle(
                    title: 'AI Symptoms Checker',
                    delay: Duration(milliseconds: 500),
                    slideFrom: Offset(0, 0.5),
                  ),
                  AnimatedEntrance(
                    child: const AiSymptomsCard(),
                    slideBegin: const Offset(0, 0.5),
                    delay: const Duration(milliseconds: 600),
                  ),
                  const SizedBox(height: 15),
                  const SectionTitle(
                    title: 'AI ChatBot',
                    delay: Duration(milliseconds: 700),
                    slideFrom: Offset(-0.5, 0),
                  ),
                  AnimatedEntrance(
                    child: ChatBotWidget(onChatTap: onChatTap),
                    slideBegin: const Offset(-0.5, 0),
                    delay: const Duration(milliseconds: 750),
                  ),
                  const SizedBox(height: 15),
                  const SectionTitle(
                    title: 'Find Nearby Doctors',
                    delay: Duration(milliseconds: 800),
                    slideFrom: Offset(0.5, 0),
                  ),
                  const SizedBox(height: 10),
                  AnimatedEntrance(
                    child: NearbyDoctorsList(
                      recommendedSpecialist: recommendedSpecialist,
                      doctors: doctors,
                      isLoading: isLoading,
                      errorMessage: errorMessage,
                      onRefresh: onRefresh,
                    ),
                    slideBegin: const Offset(0.5, 0),
                    delay: const Duration(milliseconds: 850),
                  ),
                  const SizedBox(height: 15),
                  const SectionTitle(
                    title: 'Resources and Articles',
                    delay: Duration(milliseconds: 900),
                    slideFrom: Offset.zero,
                  ),
                  const SizedBox(height: 10),
                  AnimatedEntrance(
                    child: ResourcesArticle(),
                    slideBegin: Offset.zero,
                    delay: Duration(milliseconds: 1000),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

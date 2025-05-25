import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/models/message.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/widgets/preview_image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl =
        user?.photoURL ??
        'https://img.freepik.com/free-photo/closeup-young-female-professional-making-eye-contact-against-colored-background_662251-651.jpg?semt=ais_hybrid&w=740'; // Place your default user avatar here

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  if (message.imagesUrls.isNotEmpty)
                    PreviewImagesWidget(message: message),
                  MarkdownBody(
                    selectable: true,
                    data: message.message.toString(),
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      // You can style other markdown elements here as well
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundImage:
                photoUrl.startsWith('http')
                    ? NetworkImage(photoUrl)
                    : NetworkImage(
                      'https://img.freepik.com/free-photo/closeup-young-female-professional-making-eye-contact-against-colored-background_662251-651.jpg?semt=ais_hybrid&w=740',
                    ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

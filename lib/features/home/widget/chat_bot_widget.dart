import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:synovia_ai_telehealth_app/core/colors.dart';

class ChatBotWidget extends StatelessWidget {
  final VoidCallback? onChatTap;
  const ChatBotWidget({super.key, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: brandColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // column => 1. text, 2. button
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. text
                Text(
                  "Ask anything, anytime! \nGet instant responses \npowered by AI",
                  style: GoogleFonts.nunito(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                // 2. button
                InkWell(
                  onTap: onChatTap,
                  splashColor: darkBackgroundColor,
                  highlightColor: darkBackgroundColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // text
                          Text(
                            ' Lets Talk !',
                            style: GoogleFonts.nunito(
                              fontSize: 24 * fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Image.asset(
              'assets/icons/custom/ai_robot.png',
              width: screenWidth * 0.31,
              height: screenWidth * 0.31,
            ),
          ],
        ),
      ),
    );
  }
}

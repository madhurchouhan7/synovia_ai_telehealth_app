// animated dialog
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

void showMyAnimatedDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required Function(bool) onActionPressed,
}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onActionPressed(false);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(color: brandColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  onActionPressed(true);
                  Navigator.of(context).pop();
                },
                child: Text(
                  actionText,
                  style: GoogleFonts.nunito(color: brandColor),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

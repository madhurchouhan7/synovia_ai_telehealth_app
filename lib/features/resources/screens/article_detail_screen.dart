import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/resources/model/article.dart'; // Import your Article model

class ArticleDetailScreen extends StatelessWidget {
  final Article article; // The article object to display

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor, // Use your app's background color
      appBar: AppBar(
        backgroundColor: darkBackgroundColor,
        foregroundColor: Colors.white,
        title: Text(
          article.title,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image (Optional)
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: lightTextColor, // Placeholder for broken image
                      child: Center(
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 15),

            // Article Title (if not already in AppBar)
            Text(
              article.title,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Article Content
            Text(
              article.content,
              style: GoogleFonts.nunito(
                color: lightTextColor, // Use a lighter color for body text
                fontSize: 16,
                height: 1.5, // Line height for readability
              ),
            ),
            const SizedBox(height: 20), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}

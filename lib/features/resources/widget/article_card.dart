import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/resources/model/article.dart'; // Import your Article model

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap; // Callback when the card is tapped

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap, // The callback is handled by the parent (ResourcesArticle)
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: screenWidth * 0.6, // Each card takes about 60% of screen width
        margin: const EdgeInsets.only(right: 18), // Space between cards
        decoration: BoxDecoration(
          color: cardBackgroundColor, // A suitable background for the card
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image (if available)
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  article.imageUrl,
                  height: screenWidth * 0.3, // Fixed height for card image
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: screenWidth * 0.3,
                      color: lightTextColor, // Placeholder for broken image
                      child: Center(
                        child: Icon(Icons.image, color: Colors.white54),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                article.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(color: lightTextColor, fontSize: 13),
              ),
            ),
            const Spacer(), // Pushes content to the top
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Read More',
                  style: GoogleFonts.nunito(
                    color: brandColor, // Your accent color
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

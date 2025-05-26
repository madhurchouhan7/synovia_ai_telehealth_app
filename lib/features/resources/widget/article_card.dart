import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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
                child: CachedNetworkImage(
                  // <--- Replaced Image.network
                  imageUrl: article.imageUrl,
                  height: screenWidth * 0.3, // Fixed height for card image
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        // <--- SHIMMER EFFECT
                        baseColor:
                            Colors.grey[800]!, // Base color of the shimmer
                        highlightColor:
                            Colors.grey[700]!, // Highlight color of the shimmer
                        child: Container(
                          height: screenWidth * 0.3,
                          width: double.infinity,
                          color:
                              Colors
                                  .black54, // Color of the shimmering content area
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        // <--- ERROR WIDGET
                        height: screenWidth * 0.3,
                        width: double.infinity,
                        color: lightTextColor, // Placeholder for broken image
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
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

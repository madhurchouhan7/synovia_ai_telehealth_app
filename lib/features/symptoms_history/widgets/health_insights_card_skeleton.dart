import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthInsightsCardSkeleton extends StatelessWidget {
  const HealthInsightsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, height: 18, color: Colors.grey[800]),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 8),
            Container(width: 180, height: 16, color: Colors.grey[800]),
          ],
        ),
      ),
    );
  }
}

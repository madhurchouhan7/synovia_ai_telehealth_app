import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SymptomCardSkeleton extends StatelessWidget {
  const SymptomCardSkeleton({super.key});

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 16, color: Colors.grey[800]),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 14, color: Colors.grey[800]),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

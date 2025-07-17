import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromoSliderShimmer extends StatelessWidget {
  const PromoSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // same as your banner height
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemCount: 3, // number of shimmer banners
        ),
      ),
    );
  }
}

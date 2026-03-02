import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgSurface,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class NovelCardShimmer extends StatelessWidget {
  const NovelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 130, height: 195, borderRadius: 12),
          const SizedBox(height: 8),
          ShimmerBox(width: 120, height: 14),
          const SizedBox(height: 4),
          ShimmerBox(width: 80, height: 12),
        ],
      ),
    );
  }
}

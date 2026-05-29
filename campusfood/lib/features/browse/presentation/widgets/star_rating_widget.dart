import 'package:flutter/material.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final int? totalRatings;
  final double iconSize;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.totalRatings,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: iconSize, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (totalRatings != null)
          Text(' ($totalRatings)', style: AppTextStyles.bodySmall),
      ],
    );
  }
}

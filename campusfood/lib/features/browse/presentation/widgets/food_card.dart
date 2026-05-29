import 'package:flutter/material.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/utils/formatters.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/sharedWidgets/availability_badge.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final bool showVendor;

  const FoodCard({super.key, required this.food, this.showVendor = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/foods/${food.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16:9 Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: food.imageUrl ?? '',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            Container(color: AppColors.background),
                    errorWidget:
                        (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.fastfood,
                            color: AppColors.textMuted,
                          ),
                        ),
                  ),
                  if (!food.isAvailable)
                    Container(
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Text(
                        'SOLD OUT',
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        food.categoryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFormatters.formatPrice(food.price),
                        style: AppTextStyles.price.copyWith(fontSize: 16),
                      ),
                      AvailabilityBadge(isAvailable: food.isAvailable),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRatingWidget(
                        rating: food.avgRating,
                        totalRatings: food.totalRatings,
                      ),
                      if (showVendor) ...[
                        const Spacer(),
                        const Icon(
                          Icons.store,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            food.vendorName,
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
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

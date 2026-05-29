import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/utils/formatters.dart';
import 'package:campusfood/features/browse/presentation/providers/foods_provider.dart';
import 'package:campusfood/features/browse/presentation/providers/ratings_provider.dart';
import 'package:campusfood/features/sharedWidgets/availability_badge.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FoodDetailScreen extends ConsumerWidget {
  final int foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simplified: fetch food item from existing list or specific lookup
    final foodAsync = ref.watch(foodsListProvider()).whenData(
      (foods) => foods.firstWhere((f) => f.id == foodId),
    );

    return foodAsync.when(
      data: (food) {
        final ratingsAsync = ref.watch(foodRatingsProvider(foodId));

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'food_image_${food.id}',
                    child: CachedNetworkImage(
                      imageUrl: food.imageUrl ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(color: AppColors.background),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(food.categoryName, style: AppTextStyles.label.copyWith(color: AppColors.primaryDark)),
                          ),
                          AvailabilityBadge(isAvailable: food.isAvailable),
                        ],
                      ),
                      const Gap(12),
                      Text(food.name, style: AppTextStyles.h1),
                      const Gap(4),
                      Text(AppFormatters.formatPrice(food.price), style: AppTextStyles.price.copyWith(fontSize: 24)),
                      const Gap(16),
                      Text('Description', style: AppTextStyles.h3),
                      const Gap(4),
                      Text(food.description ?? 'No description available.', style: AppTextStyles.bodyLarge),
                      const Gap(16),
                      if (food.servingSize != null || food.calories != null)
                        Row(
                          children: [
                            if (food.servingSize != null)
                              _InfoChip(label: 'Serving', value: food.servingSize!),
                            if (food.calories != null)
                              _InfoChip(label: 'Calories', value: '${food.calories} kcal'),
                          ],
                        ),
                      const Gap(24),
                      _VendorTile(
                        name: food.vendorName,
                        location: food.vendorLocation ?? '',
                        onTap: () => context.push('/vendors/${food.vendorSlug}'),
                      ),
                      const Gap(32),
                      const Text('Ratings & Reviews', style: AppTextStyles.h3),
                      const Gap(12),
                      ratingsAsync.when(
                        data: (data) {
                          final ratings = data['ratings'] as List;
                          if (ratings.isEmpty) return const Text('No reviews yet.');
                          return Column(
                            children: ratings.take(3).map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(r.reviewerName ?? 'Anonymous'),
                              subtitle: Text(r.comment ?? ''),
                              trailing: StarRatingWidget(rating: r.stars.toDouble()),
                            )).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Text('Error loading ratings'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: AppErrorWidget(message: err.toString(), onRetry: () => ref.invalidate(foodsListProvider))),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label, value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _VendorTile extends StatelessWidget {
  final String name, location;
  final VoidCallback onTap;
  const _VendorTile({required this.name, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.store, color: Colors.white)),
            const Gap(12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                Text(location, style: AppTextStyles.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/browse/presentation/providers/foods_provider.dart';
import 'package:campusfood/features/browse/presentation/providers/vendors_provider.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:campusfood/features/sharedWidgets/shimmer_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  final String slug;
  const VendorProfileScreen({super.key, required this.slug});

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(vendorsListProvider());
    final currentUser = ref.watch(authStateProvider);

    return vendorsAsync.when(
      data: (vendors) {
        final vendor = vendors.firstWhere(
          (v) => v.slug == widget.slug,
          orElse: () => throw Exception('Vendor not found'),
        );

        final isOwner = currentUser?.vendor?.id == vendor.id;

        final foodsAsync = ref.watch(
          foodsListProvider(
            vendorId: vendor.id,
            categoryId: selectedCategoryId,
          ),
        );
        final categoriesAsync = ref.watch(categoriesListProvider);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                actions: [
                  if (isOwner)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.push('/vendor/profile'),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black26,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: vendor.bannerImage ?? '',
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) =>
                            Container(color: AppColors.background),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                vendor.profileImage != null
                                    ? CachedNetworkImageProvider(
                                      vendor.profileImage!,
                                    )
                                    : null,
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendor.businessName,
                                  style: AppTextStyles.h2,
                                ),
                                Text(
                                  vendor.location,
                                  style: AppTextStyles.bodyMedium,
                                ),
                                const Gap(8),
                                _StatusChip(isOpen: vendor.isOpen ?? false),
                                StarRatingWidget(
                                  rating: vendor.avgRating,
                                  totalRatings: vendor.totalRatings,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      if (vendor.description != null)
                        Text(
                          vendor.description!,
                          style: AppTextStyles.bodyMedium,
                        ),
                      const Gap(24),
                      const Text('Menu', style: AppTextStyles.h3),
                      const Gap(8),
                      categoriesAsync.when(
                        data:
                            (categories) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('All'),
                                    selected: selectedCategoryId == null,
                                    onSelected:
                                        (_) => setState(
                                          () => selectedCategoryId = null,
                                        ),
                                  ),
                                  const Gap(8),
                                  ...categories.map(
                                    (c) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(c.name),
                                        selected: selectedCategoryId == c.id,
                                        onSelected:
                                            (_) => setState(
                                              () => selectedCategoryId = c.id,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        loading:
                            () => const ShimmerLoader(
                              width: double.infinity,
                              height: 40,
                            ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              foodsAsync.when(
                data:
                    (foods) => SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.8,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              FoodCard(food: foods[index], showVendor: false),
                          childCount: foods.length,
                        ),
                      ),
                    ),
                loading:
                    () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (err, _) => SliverToBoxAdapter(
                      child: AppErrorWidget(
                        message: err.toString(),
                        onRetry: () => ref.invalidate(foodsListProvider),
                      ),
                    ),
              ),
            ],
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, _) => Scaffold(
            body: AppErrorWidget(
              message: err.toString(),
              onRetry: () => ref.invalidate(vendorsListProvider),
            ),
          ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isOpen;
  const _StatusChip({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isOpen
                ? AppColors.success.withOpacity(0.9)
                : AppColors.error.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? 'OPEN' : 'CLOSED',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

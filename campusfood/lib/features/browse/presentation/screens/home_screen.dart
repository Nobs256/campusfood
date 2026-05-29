import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_strings.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/browse/presentation/providers/foods_provider.dart';
import 'package:campusfood/features/browse/presentation/providers/vendors_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/category_chip.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/browse/presentation/widgets/vendor_card.dart';
import 'package:campusfood/features/sharedWidgets/shimmer_loader.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final featuredFoodsAsync = ref.watch(featuredFoodsProvider);
    final vendorsAsync = ref.watch(vendorsListProvider());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoriesListProvider);
          ref.invalidate(featuredFoodsProvider);
          ref.invalidate(vendorsListProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Search Bar Placeholder
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () => context.go('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        Gap(8),
                        Text(
                          AppStrings.searchPlaceholder,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Category Filter
            SliverToBoxAdapter(
              child: categoriesAsync.when(
                data:
                    (categories) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children:
                            categories
                                .map(
                                  (cat) => CategoryChip(
                                    category: cat,
                                    isSelected: selectedCategoryId == cat.id,
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryId =
                                            selectedCategoryId == cat.id
                                                ? null
                                                : cat.id;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                loading:
                    () => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ShimmerLoader(width: double.infinity, height: 40),
                    ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Featured Foods
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Featured Today', style: AppTextStyles.h3),
              ),
            ),
            SliverToBoxAdapter(
              child: featuredFoodsAsync.when(
                data:
                    (foods) => SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: foods.length,
                        itemBuilder:
                            (context, index) => SizedBox(
                              width: 280,
                              child: FoodCard(food: foods[index]),
                            ),
                      ),
                    ),
                loading:
                    () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (err, _) => const Center(
                      child: Text('Error loading featured foods'),
                    ),
              ),
            ),

            // All Vendors
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Our Vendors', style: AppTextStyles.h3),
              ),
            ),
            vendorsAsync.when(
              data:
                  (vendors) => SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VendorCard(vendor: vendors[index]);
                      }, childCount: vendors.length),
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
                      onRetry: () => ref.invalidate(vendorsListProvider),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusfood/features/student/presentation/providers/student_provider.dart';
import 'package:campusfood/features/browse/presentation/providers/foods_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:campusfood/features/sharedWidgets/shimmer_loader.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final favoritesAsync = ref.watch(studentFavoritesProvider);
    final ratingsAsync = ref.watch(studentRatingsProvider);
    final featuredAsync = ref.watch(featuredFoodsProvider);

    final firstName = user?.fullName.split(' ').first ?? 'Student';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studentFavoritesProvider);
          ref.invalidate(studentRatingsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Good morning, $firstName!', style: AppTextStyles.h2),
            const Gap(24),
            
            _SectionHeader(
              title: 'Your Favorites', 
              onSeeAll: () => context.go('/student/favorites'),
            ),
            const Gap(8),
            favoritesAsync.when(
              data: (favs) => favs.isEmpty 
                ? const Text('No favorites saved yet.')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: favs.length > 4 ? 4 : favs.length,
                    itemBuilder: (ctx, i) => FoodCard(food: favs[i]),
                  ),
              loading: () => const ShimmerLoader(width: double.infinity, height: 200),
              error: (_, __) => const Text('Error loading favorites'),
            ),

            const Gap(32),
            _SectionHeader(
              title: 'Discover something new',
              onSeeAll: () => context.go('/home'),
            ),
            const Gap(8),
            featuredAsync.when(
              data: (foods) => foods.isEmpty 
                ? const SizedBox.shrink() 
                : FoodCard(food: (foods..shuffle()).first),
              loading: () => const FoodCardShimmer(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const Gap(32),
            _SectionHeader(
              title: 'Your Recent Ratings',
              onSeeAll: () => context.go('/student/ratings'),
            ),
            const Gap(8),
            ratingsAsync.when(
              data: (ratings) => ratings.isEmpty
                ? const Text('You haven\'t rated any meals yet.')
                : Column(
                    children: ratings.take(3).map((r) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(r.foodName ?? 'Food Item'),
                      subtitle: Text(r.comment ?? 'No comment'),
                      trailing: StarRatingWidget(rating: r.stars.toDouble()),
                      onTap: () => r.foodId != null ? context.push('/foods/${r.foodId}') : null,
                    )).toList(),
                  ),
              loading: () => const ShimmerLoader(width: double.infinity, height: 100),
              error: (_, __) => const Text('Error loading ratings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3),
        TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}
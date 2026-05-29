import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/student/presentation/providers/student_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyRatingsScreen extends ConsumerWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingsAsync = ref.watch(studentRatingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Ratings')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(studentRatingsProvider.future),
        child: ratingsAsync.when(
          data: (ratings) {
            if (ratings.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Ratings Yet',
                message: 'You haven\'t reviewed any meals. Start exploring!',
                icon: Icons.rate_review_outlined,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ratings.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final r = ratings[index];
                return InkWell(
                  onTap:
                      () =>
                          r.foodId != null
                              ? context.push('/foods/${r.foodId}')
                              : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.foodName ?? 'Food Item',
                              style: AppTextStyles.h3.copyWith(fontSize: 16),
                            ),
                            const Gap(4),
                            StarRatingWidget(rating: r.stars.toDouble()),
                            if (r.comment != null && r.comment!.isNotEmpty) ...[
                              const Gap(8),
                              Text(r.comment!, style: AppTextStyles.bodyMedium),
                            ],
                            const Gap(8),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(DateTime.parse(r.createdAt)),
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(studentRatingsProvider),
              ),
        ),
      ),
    );
  }
}

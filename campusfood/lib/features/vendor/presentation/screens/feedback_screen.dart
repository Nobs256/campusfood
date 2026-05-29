import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/vendor/presentation/providers/vendor_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackAsync = ref.watch(vendorFeedbackProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Feedback')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vendorFeedbackProvider.future),
        child: feedbackAsync.when(
          data: (ratings) {
            if (ratings.isEmpty) {
              return const EmptyStateWidget(
                title: 'No feedback yet',
                message: 'Reviews from students will appear here.',
                icon: Icons.chat_bubble_outline,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final r = ratings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(r.reviewerName ?? 'Anonymous', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          Text(timeago.format(DateTime.parse(r.createdAt)), style: AppTextStyles.bodySmall),
                        ]),
                        const Gap(4),
                        Text('On: ${r.foodName ?? "Unknown Item"}', style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                        const Gap(8),
                        StarRatingWidget(rating: r.stars.toDouble()),
                        if (r.comment != null && r.comment!.isNotEmpty) ...[const Gap(8), Text(r.comment!, style: AppTextStyles.bodyMedium)],
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => AppErrorWidget(message: err.toString(), onRetry: () => ref.invalidate(vendorFeedbackProvider)),
        ),
      ),
    );
  }
}
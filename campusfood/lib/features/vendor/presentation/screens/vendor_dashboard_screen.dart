import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/vendor/presentation/providers/vendor_provider.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';

class VendorDashboardScreen extends ConsumerWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(vendorDashboardProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vendorDashboardProvider.future),
        child: dashboardAsync.when(
          data: (data) {
            final stats = data['stats'] as Map<String, dynamic>;
            final recentRatings = data['recent_ratings'] as List? ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Dashboard Overview', style: AppTextStyles.h2),
                const Gap(16),
                _buildStatsGrid(stats),
                const Gap(32),
                const Text('Recent Ratings', style: AppTextStyles.h3),
                const Gap(8),
                if (recentRatings.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No ratings yet.'),
                    ),
                  )
                else
                  ...recentRatings.map((r) => _buildRatingTile(r)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => AppErrorWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(vendorDashboardProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Items', stats['total_items']?.toString() ?? '0', AppColors.info),
        _buildStatCard('Available', stats['available_items']?.toString() ?? '0', AppColors.success),
        _buildStatCard('Avg Rating', stats['avg_rating']?.toString() ?? '0.0', AppColors.warning),
        _buildStatCard('Views Today', stats['views_today']?.toString() ?? '0', AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
          Text(label, style: AppTextStyles.label.copyWith(color: color.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildRatingTile(dynamic rating) {
    return ListTile(
      title: Text(rating['food_name'] ?? 'Unknown Item'),
      subtitle: Text(rating['comment'] ?? 'No comment'),
      trailing: Text('${rating['stars']} ★'),
    );
  }
}
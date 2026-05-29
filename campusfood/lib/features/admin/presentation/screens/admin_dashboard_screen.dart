import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/admin/presentation/providers/admin_provider.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(adminDashboardProvider.future),
        child: dashboardAsync.when(
          data: (data) {
            final stats = data['stats'] as Map<String, dynamic>;
            final pendingVendors = data['pending_vendors'] as List? ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Platform Stats', style: AppTextStyles.h2),
                const Gap(16),
                _buildStatsGrid(stats),
                const Gap(32),
                const Text('Pending Approvals', style: AppTextStyles.h3),
                const Gap(12),
                if (pendingVendors.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('No pending applications')),
                    ),
                  )
                else
                  ...pendingVendors.map((v) => _PendingVendorCard(vendor: v)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(adminDashboardProvider),
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
      childAspectRatio: 1.6,
      children: [
        _StatCard(
          label: 'Approved Vendors',
          value: stats['approved_vendors'].toString(),
          color: AppColors.success,
        ),
        _StatCard(
          label: 'Pending Approval',
          value: stats['pending_vendors'].toString(),
          color: AppColors.warning,
        ),
        _StatCard(
          label: 'Students',
          value: stats['students'].toString(),
          color: AppColors.studentColor,
        ),
        _StatCard(
          label: 'Total Items',
          value: stats['food_items'].toString(),
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _PendingVendorCard extends ConsumerWidget {
  final dynamic vendor;
  const _PendingVendorCard({required this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vendor['business_name'],
              style: AppTextStyles.h3.copyWith(fontSize: 18),
            ),
            const Gap(4),
            Text(
              'Owner: ${vendor['full_name']} (${vendor['email']})',
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Location: ${vendor['location']}',
              style: AppTextStyles.bodySmall,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => ref
                            .read(adminVendorActionNotifierProvider.notifier)
                            .performAction(vendor['id'], 'approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        () => _showRejectDialog(context, ref, vendor['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, int id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Reject Application'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Reason for rejection',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(adminVendorActionNotifierProvider.notifier)
                      .performAction(id, 'reject', reason: controller.text);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Reject',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }
}

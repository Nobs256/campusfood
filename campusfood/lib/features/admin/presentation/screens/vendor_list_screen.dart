import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/admin/presentation/providers/admin_provider.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VendorListScreen extends ConsumerStatefulWidget {
  const VendorListScreen({super.key});

  @override
  ConsumerState<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends ConsumerState<VendorListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statuses = [
    '',
    'pending',
    'approved',
    'rejected',
    'blocked',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Vendors'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
            Tab(text: 'Blocked'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _statuses
                .map((status) => _VendorStatusList(status: status))
                .toList(),
      ),
    );
  }
}

class _VendorStatusList extends ConsumerWidget {
  final String status;
  const _VendorStatusList({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(adminVendorsProvider(status: status));

    return RefreshIndicator(
      onRefresh: () => ref.refresh(adminVendorsProvider(status: status).future),
      child: vendorsAsync.when(
        data: (data) {
          final List<Vendor> vendors = data['vendors'];
          if (vendors.isEmpty) {
            return const Center(child: Text('No vendors found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return _AdminVendorCard(vendor: vendor);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => AppErrorWidget(
              message: err.toString(),
              onRetry:
                  () => ref.invalidate(adminVendorsProvider(status: status)),
            ),
      ),
    );
  }
}

class _AdminVendorCard extends ConsumerWidget {
  final Vendor vendor;
  const _AdminVendorCard({required this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(vendor.businessName, style: AppTextStyles.h3),
                ),
                _StatusBadge(status: vendor.status),
              ],
            ),
            const Gap(8),
            Text('Owner: ${vendor.ownerName ?? "Unknown"}'),
            Text('Email: ${vendor.ownerEmail ?? "N/A"}'),
            Text('Location: ${vendor.location}'),
            const Gap(8),
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                const Gap(4),
                Text('${vendor.foodCount ?? 0} Items'),
                const Gap(16),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const Gap(4),
                Text(vendor.avgRating.toStringAsFixed(1)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.push('/admin/vendors/${vendor.id}'),
                  child: const Text('View Details'),
                ),
                if (vendor.status == 'pending') ...[
                  const Gap(8),
                  ElevatedButton(
                    onPressed:
                        () => ref
                            .read(adminVendorActionNotifierProvider.notifier)
                            .performAction(vendor.id, 'approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve'),
                  ),
                ],
                if (vendor.status == 'approved') ...[
                  const Gap(8),
                  OutlinedButton(
                    onPressed:
                        () => ref
                            .read(adminVendorActionNotifierProvider.notifier)
                            .performAction(vendor.id, 'block'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Block'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    switch (status) {
      case 'approved':
        color = AppColors.success;
        break;
      case 'pending':
        color = AppColors.warning;
        break;
      case 'rejected':
        color = AppColors.error;
        break;
      case 'blocked':
        color = Colors.black87;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

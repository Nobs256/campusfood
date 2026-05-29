import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/admin/presentation/providers/admin_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/browse/presentation/widgets/star_rating_widget.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class VendorDetailScreen extends ConsumerWidget {
  final int vendorId;
  const VendorDetailScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorDetailAsync = ref.watch(adminVendorDetailProvider(vendorId));

    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Details')),
      body: vendorDetailAsync.when(
        data: (data) {
          final vendor = data['vendor'] as Vendor;
          final foods = data['foods'] as List<FoodItem>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Banner Image and Profile Picture
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: vendor.bannerImage ?? '',
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, url, error) =>
                              Container(color: AppColors.background),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      backgroundImage:
                          vendor.profileImage != null
                              ? CachedNetworkImageProvider(vendor.profileImage!)
                              : null,
                      child:
                          vendor.profileImage == null
                              ? const Icon(Icons.store, size: 50)
                              : null,
                    ),
                  ),
                ],
              ),
              const Gap(60),

              // Vendor Info
              Text(
                vendor.businessName,
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              Text(
                vendor.location,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StarRatingWidget(
                    rating: vendor.avgRating,
                    totalRatings: vendor.totalRatings,
                  ),
                  const Gap(16),
                  _StatusBadge(status: vendor.status),
                ],
              ),
              const Gap(16),
              if (vendor.description != null && vendor.description!.isNotEmpty)
                Text(
                  vendor.description!,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              const Gap(24),

              // Contact & Timing
              _buildInfoRow(Icons.person, 'Owner', vendor.ownerName ?? 'N/A'),
              _buildInfoRow(
                Icons.email,
                'Email',
                vendor.ownerEmail ?? 'N/A',
                onTap: () => _launchUrl('mailto:${vendor.ownerEmail}'),
              ),
              _buildInfoRow(
                Icons.phone,
                'Phone',
                vendor.phone ?? 'N/A',
                onTap: () => _launchUrl('tel:${vendor.phone}'),
              ),
              _buildInfoRow(
                Icons.phone,
                'WhatsApp',
                vendor.whatsapp ?? 'N/A',
                onTap: () => _launchUrl('https://wa.me/${vendor.whatsapp}'),
              ),
              _buildInfoRow(
                Icons.access_time,
                'Hours',
                '${vendor.openingTime ?? 'N/A'} - ${vendor.closingTime ?? 'N/A'}',
              ),
              _buildInfoRow(
                Icons.event,
                'Registered',
                vendor.createdAt != null
                    ? DateFormat(
                      'MMM dd, yyyy',
                    ).format(DateTime.parse(vendor.createdAt!))
                    : 'N/A',
              ),
              const Gap(24),

              // Admin Actions
              const Text('Admin Actions', style: AppTextStyles.h3),
              const Gap(12),
              _buildAdminActions(context, ref, vendor),
              const Gap(32),

              // Food Items
              const Text('Food Items', style: AppTextStyles.h3),
              const Gap(12),
              if (foods.isEmpty)
                const Text('No food items registered yet.')
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: foods.length,
                  itemBuilder:
                      (context, index) =>
                          FoodCard(food: foods[index], showVendor: false),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => AppErrorWidget(
              message: err.toString(),
              onRetry:
                  () => ref.invalidate(adminVendorDetailProvider(vendorId)),
            ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 20),
          const Gap(12),
          Text(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: onTap != null ? AppColors.info : AppColors.textPrimary,
                  decoration:
                      onTap != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(
    BuildContext context,
    WidgetRef ref,
    Vendor vendor,
  ) {
    final notifier = ref.read(adminVendorActionNotifierProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (vendor.status == 'pending')
          ElevatedButton(
            onPressed: () => notifier.performAction(vendor.id, 'approve'),
            child: const Text('Approve'),
          ),
        if (vendor.status == 'pending' || vendor.status == 'approved')
          OutlinedButton(
            onPressed: () => _showRejectDialog(context, notifier, vendor.id),
            child: const Text('Reject'),
          ),
        if (vendor.status != 'blocked')
          ElevatedButton(
            onPressed: () => notifier.performAction(vendor.id, 'block'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Block'),
          ),
        if (vendor.status == 'blocked')
          OutlinedButton(
            onPressed: () => notifier.performAction(vendor.id, 'unblock'),
            child: const Text('Unblock'),
          ),
      ],
    );
  }

  void _showRejectDialog(
    BuildContext context,
    AdminVendorActionNotifier notifier,
    int vendorId,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Reject Vendor'),
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
              ElevatedButton(
                onPressed: () {
                  notifier.performAction(
                    vendorId,
                    'reject',
                    reason: controller.text,
                  );
                  Navigator.pop(ctx);
                },
                child: const Text('Reject'),
              ),
            ],
          ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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

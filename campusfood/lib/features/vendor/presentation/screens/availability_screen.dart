import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/features/vendor/presentation/providers/vendor_provider.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';

class AvailabilityScreen extends ConsumerWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(vendorMenuProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quick Availability')),
      body: menuAsync.when(
        data: (foods) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: foods.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final food = foods[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: AppColors.background, child: const Icon(Icons.fastfood, size: 20)),
                ),
              ),
              title: Text(food.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text(food.categoryName),
              trailing: Switch(
                value: food.isAvailable,
                activeColor: AppColors.success,
                onChanged: (val) async {
                  try {
                    await ref.read(apiServiceProvider).patch('/foods/${food.id}/availability');
                    ref.invalidate(vendorMenuProvider);
                    ref.invalidate(vendorDashboardProvider);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
                  }
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(vendorMenuProvider),
        ),
      ),
    );
  }
}
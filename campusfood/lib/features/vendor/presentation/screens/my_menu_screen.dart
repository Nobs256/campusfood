import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/features/vendor/presentation/providers/vendor_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:go_router/go_router.dart';

class MyMenuScreen extends ConsumerWidget {
  const MyMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(vendorMenuProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Menu')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(vendorMenuProvider.future),
        child: menuAsync.when(
          data: (foods) {
            if (foods.isEmpty) {
              return EmptyStateWidget(
                title: 'Your menu is empty',
                message: 'Start adding delicious meals to your menu.',
                icon: Icons.restaurant_menu,
                actionLabel: 'Add Food',
                onActionPressed: () => context.push('/vendor/foods/add'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Stack(
                    children: [
                      FoodCard(food: food, showVendor: false),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filledTonal(
                          onPressed:
                              () =>
                                  context.push('/vendor/foods/${food.id}/edit'),
                          icon: const Icon(Icons.edit, size: 20),
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
                onRetry: () => ref.invalidate(vendorMenuProvider),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vendor/foods/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

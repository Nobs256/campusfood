import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/features/browse/presentation/providers/compare_provider.dart';
import 'package:go_router/go_router.dart';

class CompareBottomBar extends ConsumerWidget {
  const CompareBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareList = ref.watch(compareListProvider);
    if (compareList.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${compareList.length} items selected for comparison',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => ref.read(compareListProvider.notifier).clear(),
              child: const Text('Clear'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed:
                  compareList.length < 2
                      ? null
                      : () => context.push('/compare'),
              child: const Text('Compare Now'),
            ),
          ],
        ),
      ),
    );
  }
}

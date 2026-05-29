import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/utils/formatters.dart';
import 'package:campusfood/features/browse/presentation/providers/compare_provider.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareList = ref.watch(compareListProvider);

    if (compareList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Compare Foods')),
        body: const EmptyStateWidget(
          title: 'No items to compare',
          message:
              'Add up to 4 items from the food detail screens to compare them side-by-side.',
          icon: Icons.compare_arrows,
        ),
      );
    }

    const double labelWidth = 100;
    const double columnWidth = 180;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Foods'),
        actions: [
          TextButton(
            onPressed: () => ref.read(compareListProvider.notifier).clear(),
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Fixed Labels column
          Container(
            width: labelWidth,
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: ListView(
              children: [
                const Gap(220), // Matches header height
                _buildLabel('Price'),
                _buildLabel('Vendor'),
                _buildLabel('Category'),
                _buildLabel('Rating'),
                _buildLabel('Status'),
                _buildLabel('Serving'),
                _buildLabel('Calories'),
              ],
            ),
          ),
          // Horizontal scrollable data columns
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: compareList.length * columnWidth,
                child: ListView(
                  children: [
                    Row(
                      children:
                          compareList
                              .map(
                                (food) => _buildHeader(
                                  food,
                                  ref,
                                  context,
                                  columnWidth,
                                ),
                              )
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map(
                                (food) => _buildData(
                                  AppFormatters.formatPrice(food.price),
                                  columnWidth,
                                  textStyle: AppTextStyles.bodyMedium.copyWith(
                                    color:
                                        (food.isCheapest ?? false)
                                            ? AppColors.success
                                            : null,
                                    fontWeight:
                                        (food.isCheapest ?? false)
                                            ? FontWeight.bold
                                            : null,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map((f) => _buildData(f.vendorName, columnWidth))
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map(
                                (f) => _buildData(f.categoryName, columnWidth),
                              )
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList.map((food) {
                            final isHighest = food.isHighestRated ?? false;
                            return _buildDataWidget(
                              columnWidth,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: isHighest ? Colors.amber : Colors.grey,
                                  ),
                                  Text(
                                    ' ${food.avgRating}',
                                    style: TextStyle(
                                      color:
                                          isHighest ? Colors.amber[800] : null,
                                      fontWeight:
                                          isHighest ? FontWeight.bold : null,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map(
                                (f) => _buildData(
                                  f.isAvailable ? 'Available' : 'Sold Out',
                                  columnWidth,
                                ),
                              )
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map(
                                (f) => _buildData(
                                  f.servingSize ?? '-',
                                  columnWidth,
                                ),
                              )
                              .toList(),
                    ),
                    Row(
                      children:
                          compareList
                              .map(
                                (f) => _buildData(
                                  f.calories?.toString() ?? '-',
                                  columnWidth,
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Text(text, style: AppTextStyles.label),
    );
  }

  Widget _buildData(String text, double width, {TextStyle? textStyle}) {
    return Container(
      height: 60,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Text(
        text,
        style: textStyle ?? AppTextStyles.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataWidget(double width, {required Widget child}) {
    return Container(
      height: 60,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: child,
    );
  }

  Widget _buildHeader(
    dynamic food,
    WidgetRef ref,
    BuildContext context,
    double width,
  ) {
    return Container(
      width: width,
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: food.imageUrl ?? '',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget:
                      (context, url, error) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.fastfood,
                          color: AppColors.textMuted,
                        ),
                      ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 12, color: Colors.white),
                    onPressed:
                        () => ref
                            .read(compareListProvider.notifier)
                            .remove(food.id),
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            food.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/foods/${food.id}'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Details', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
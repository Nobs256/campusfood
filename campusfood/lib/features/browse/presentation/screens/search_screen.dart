import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_strings.dart';
import 'package:campusfood/features/browse/presentation/providers/search_provider.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:campusfood/features/sharedWidgets/error_widget.dart';
import 'package:campusfood/features/sharedWidgets/empty_state_widget.dart';
import 'package:gap/gap.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchResultsProvider());

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.searchPlaceholder,
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                ref
                    .read(searchFiltersNotifierProvider.notifier)
                    .updateQuery('');
              },
            ),
          ),
          onChanged: (value) {
            ref.read(searchFiltersNotifierProvider.notifier).updateQuery(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: searchResultsAsync.when(
        data: (data) {
          final foods = data['foods'] as List;
          if (foods.isEmpty) {
            return const EmptyStateWidget(
              title: 'No results found',
              message: 'Try adjusting your filters or search terms.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            itemBuilder:
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FoodCard(food: foods[index]),
                ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => AppErrorWidget(
              message: err.toString(),
              onRetry: () => ref.refresh(searchResultsProvider()),
            ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _FilterPanel(),
    );
  }
}

class _FilterPanel extends ConsumerWidget {
  const _FilterPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
          const Gap(16),
          DropdownButton<String>(
            value: filters.sort,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'newest', child: Text('Newest First')),
              DropdownMenuItem(
                value: 'price_asc',
                child: Text('Price: Low to High'),
              ),
              DropdownMenuItem(
                value: 'price_desc',
                child: Text('Price: High to Low'),
              ),
              DropdownMenuItem(value: 'rating', child: Text('Top Rated')),
            ],
            onChanged: (val) {
              if (val != null) {
                ref
                    .read(searchFiltersNotifierProvider.notifier)
                    .updateSort(val);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

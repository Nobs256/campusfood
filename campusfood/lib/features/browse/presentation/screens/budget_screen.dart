import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusfood/core/constants/app_colors.dart';
import 'package:campusfood/core/constants/app_strings.dart';
import 'package:campusfood/core/constants/app_text_styles.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/browse/presentation/widgets/food_card.dart';
import 'package:gap/gap.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final _budgetController = TextEditingController();
  Map<String, dynamic>? _recommendations;
  bool _isLoading = false;

  Future<void> _getRecommendations() async {
    final budget = double.tryParse(_budgetController.text);
    if (budget == null || budget <= 0) return;

    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.get('/recommend', params: {'budget': budget});
      setState(() => _recommendations = res['data']);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Recommend')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.budgetPlaceholder,
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _getRecommendations(),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getRecommendations,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Find Food'),
            ),
            if (_recommendations != null && !_isLoading) ...[
              _RecommendationSection(
                title: 'Best Value',
                foods:
                    ((_recommendations!['best_value'] ?? []) as List)
                        .map((e) => FoodItem.fromJson(e))
                        .toList(),
              ),
              _RecommendationSection(
                title: 'Cheapest',
                foods:
                    ((_recommendations!['cheapest'] ?? []) as List)
                        .map((e) => FoodItem.fromJson(e))
                        .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  final String title;
  final List<FoodItem> foods;

  const _RecommendationSection({required this.title, required this.foods});

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(24),
        Text(title, style: AppTextStyles.h3),
        const Gap(8),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder:
                (context, index) =>
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(width: 260, child: FoodCard(food: foods[index])),
                    ),
          ),
        ),
      ],
    );
  }
}

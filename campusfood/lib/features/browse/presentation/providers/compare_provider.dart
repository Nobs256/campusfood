import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';

part 'compare_provider.g.dart';

@riverpod
class CompareList extends _$CompareList {
  @override
  List<FoodItem> build() => [];

  void toggle(FoodItem item) {
    if (state.any((element) => element.id == item.id)) {
      state = state.where((element) => element.id != item.id).toList();
    } else {
      if (state.length < 4) {
        state = [...state, item];
      }
    }
  }

  void remove(int id) => state = state.where((item) => item.id != id).toList();

  void clear() => state = [];
}

@riverpod
List<FoodItem> processedCompareList(ProcessedCompareListRef ref) {
  final list = ref.watch(compareListProvider);
  if (list.isEmpty) return [];

  final minPrice = list.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  final maxRating = list.map((e) => e.avgRating).reduce((a, b) => a > b ? a : b);

  return list.map((food) {
    final isHigh = food.avgRating == maxRating && food.avgRating > 0;
    return food.copyWith(
      isCheapest: food.price == minPrice,
      isHighestRated: isHigh,
    );
  }).toList();
}

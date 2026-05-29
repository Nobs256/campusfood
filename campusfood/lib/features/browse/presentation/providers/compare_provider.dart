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

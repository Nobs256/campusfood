import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/browse/domainModels/category.dart';

part 'foods_provider.g.dart';

@riverpod
Future<List<Category>> categoriesList(CategoriesListRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/categories');

  final List<dynamic> data = response['data'];
  return data.map((json) => Category.fromJson(json)).toList();
}

@riverpod
Future<List<FoodItem>> featuredFoods(FeaturedFoodsRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/foods/featured');

  final List<dynamic> data = response['data'];
  return data.map((json) => FoodItem.fromJson(json)).toList();
}

@riverpod
Future<List<FoodItem>> foodsList(
  FoodsListRef ref, {
  int? vendorId,
  int? categoryId,
  String? sort,
}) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get(
    '/foods',
    params: {
      if (vendorId != null) 'vendor_id': vendorId,
      if (categoryId != null) 'category_id': categoryId,
      if (sort != null) 'sort': sort,
    },
  );

  final List<dynamic> data = response['data'];
  return data.map((json) => FoodItem.fromJson(json)).toList();
}

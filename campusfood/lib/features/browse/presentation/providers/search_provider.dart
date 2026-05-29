import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';

part 'search_provider.freezed.dart';
part 'search_provider.g.dart';

@freezed
class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? availableOnly,
    int? vendorId,
    @Default('newest') String sort,
  }) = _SearchFilters;
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void updateQuery(String? q) => state = state.copyWith(query: q);
  void updateCategory(int? id) => state = state.copyWith(categoryId: id);
  void updatePriceRange(double? min, double? max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);
  void toggleAvailable(bool? val) => state = state.copyWith(availableOnly: val);
  void updateSort(String s) => state = state.copyWith(sort: s);
  void reset() => state = const SearchFilters();
}

@riverpod
Future<List<dynamic>> searchAutocomplete(
  SearchAutocompleteRef ref,
  String query,
) async {
  if (query.length < 2) return [];
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/search/autocomplete', params: {'q': query});
  return response['data'] ?? [];
}

@riverpod
Future<Map<String, dynamic>> searchResults(
  SearchResultsRef ref, {
  int page = 1,
}) async {
  final filters = ref.watch(searchFiltersNotifierProvider);
  final api = ref.watch(apiServiceProvider);

  final response = await api.get(
    '/search',
    params: {
      if (filters.query != null && filters.query!.isNotEmpty)
        'q': filters.query,
      if (filters.categoryId != null) 'category_id': filters.categoryId,
      if (filters.minPrice != null) 'min_price': filters.minPrice,
      if (filters.maxPrice != null) 'max_price': filters.maxPrice,
      if (filters.availableOnly == true) 'available': 1,
      if (filters.vendorId != null) 'vendor_id': filters.vendorId,
      'sort': filters.sort,
      'page': page,
    },
  );

  final List<dynamic> foodsData = response['data'];
  final foods = foodsData.map((json) => FoodItem.fromJson(json)).toList();
  return {...response['meta'] ?? {}, 'foods': foods};
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/browse/domainModels/rating.dart';

part 'student_provider.g.dart';

@riverpod
Future<List<FoodItem>> studentFavorites(StudentFavoritesRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/favorites');
  final List<dynamic> data = response['data'];
  return data.map((json) => FoodItem.fromJson(json)).toList();
}

@riverpod
Future<List<Rating>> studentRatings(StudentRatingsRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/student/ratings');
  final List<dynamic> data = response['data'];
  return data.map((json) => Rating.fromJson(json)).toList();
}

@riverpod
class FavoriteToggleNotifier extends _$FavoriteToggleNotifier {
  @override
  void build() {}

  Future<void> toggle(int foodId) async {
    final api = ref.read(apiServiceProvider);
    try {
      await api.post('/favorites/$foodId');
      ref.invalidate(studentFavoritesProvider);
    } catch (e) {
      rethrow;
    }
  }
}
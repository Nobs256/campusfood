import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/rating.dart';

part 'ratings_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> foodRatings(
  FoodRatingsRef ref,
  int foodId, {
  int page = 1,
}) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get(
    '/foods/$foodId/ratings',
    params: {'page': page},
  );

  final List<dynamic> ratingsData = response['data']['ratings'];
  final ratings = ratingsData.map((json) => Rating.fromJson(json)).toList();
  return {...response['data'], 'ratings': ratings};
}

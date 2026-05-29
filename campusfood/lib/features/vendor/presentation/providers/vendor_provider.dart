import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';
import 'package:campusfood/features/browse/domainModels/rating.dart';

part 'vendor_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> vendorDashboard(VendorDashboardRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/vendor/dashboard');
  return response['data'];
}

@riverpod
Future<List<FoodItem>> vendorMenu(VendorMenuRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/vendor/menu');
  
  final List<dynamic> data = response['data'];
  return data.map((json) => FoodItem.fromJson(json)).toList();
}

@riverpod
Future<List<Rating>> vendorFeedback(VendorFeedbackRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/vendor/feedback');
  
  final List<dynamic> data = response['data'];
  return data.map((json) => Rating.fromJson(json)).toList();
}
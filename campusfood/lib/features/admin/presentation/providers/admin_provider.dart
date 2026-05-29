import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';
import 'package:campusfood/features/browse/domainModels/food_item.dart';

import 'package:campusfood/features/browse/domainModels/category.dart';
part 'admin_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> adminDashboard(AdminDashboardRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/admin/dashboard');
  return response['data'];
}

@riverpod
Future<Map<String, dynamic>> adminVendors(
  AdminVendorsRef ref, {
  String status = '',
  int page = 1,
}) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get(
    '/admin/vendors',
    params: {if (status.isNotEmpty) 'status': status, 'page': page},
  );

  final List<dynamic> list = response['data'];
  final vendors = list.map((e) => Vendor.fromJson(e)).toList();

  return {'vendors': vendors, 'meta': response['meta']};
}

@riverpod
Future<Map<String, dynamic>> adminVendorDetail(
  AdminVendorDetailRef ref,
  int vendorId,
) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/admin/vendors/$vendorId');
  final vendor = Vendor.fromJson(response['data']);
  final List<dynamic> foodsData = response['data']['foods'] ?? [];
  final foods = foodsData.map((json) => FoodItem.fromJson(json)).toList();
  return {'vendor': vendor, 'foods': foods};
}

@riverpod
Future<Map<String, dynamic>> adminReports(
  AdminReportsRef ref, {
  required String startDate,
  required String endDate,
}) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get(
    '/admin/reports',
    params: {'from': startDate, 'to': endDate},
  );
  return response['data'];
}

@riverpod
Future<List<Category>> adminCategoriesList(AdminCategoriesListRef ref) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get(
    '/categories',
  ); // Reusing public categories endpoint
  final List<dynamic> data = response['data'];
  return data.map((json) => Category.fromJson(json)).toList();
}

@riverpod
class AdminCategoryActionNotifier extends _$AdminCategoryActionNotifier {
  @override
  void build() {}

  Future<void> addCategory(String name, String icon) async {
    final api = ref.read(apiServiceProvider);
    await api.post('/categories', data: {'name': name, 'icon': icon});
    ref.invalidate(adminCategoriesListProvider);
  }

  Future<void> updateCategory(int id, String name, String icon) async {
    final api = ref.read(apiServiceProvider);
    await api.put('/categories/$id', data: {'name': name, 'icon': icon});
    ref.invalidate(adminCategoriesListProvider);
  }

  Future<void> deleteCategory(int id) async {
    final api = ref.read(apiServiceProvider);
    await api.delete('/categories/$id');
    ref.invalidate(adminCategoriesListProvider);
  }
}

@riverpod
class AdminVendorActionNotifier extends _$AdminVendorActionNotifier {
  @override
  void build() {}

  Future<void> performAction(
    int vendorId,
    String action, {
    String? reason,
  }) async {
    final api = ref.read(apiServiceProvider);
    try {
      await api.post(
        '/admin/vendors/$vendorId/action',
        data: {'action': action, if (reason != null) 'reason': reason},
      );
      // Refresh dashboard and lists after action
      ref.invalidate(adminDashboardProvider);
    } catch (e) {
      rethrow;
    }
  }
}

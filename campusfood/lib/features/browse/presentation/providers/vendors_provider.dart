import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';

part 'vendors_provider.g.dart';

@riverpod
Future<List<Vendor>> vendorsList(
  VendorsListRef ref, {
  String status = 'approved',
}) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/vendors', params: {'status': status});

  final List<dynamic> data = response['data'];
  return data.map((json) => Vendor.fromJson(json)).toList();
}

@riverpod
Future<Vendor> vendorDetail(VendorDetailRef ref, int id) async {
  final api = ref.watch(apiServiceProvider);
  final response = await api.get('/vendors/$id');

  return Vendor.fromJson(response['data']);
}

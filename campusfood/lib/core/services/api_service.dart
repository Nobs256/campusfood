import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/storage_service.dart';

part 'api_service.g.dart';

class ApiService {
  static const baseUrl =
      'https://music.onlineincomehub.org/cumpusfoodapi/api/v1';
  late final Dio _dio;
  final StorageService _storage;

  ApiService(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read('access_token');
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            if (await _refreshToken()) {
              final token = await _storage.read('access_token');
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              return handler.resolve(await _dio.fetch(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final rt = await _storage.read('refresh_token');
      if (rt == null) return false;
      final res = await Dio().post(
        '$baseUrl/auth/refresh',
        data: {'refresh_token': rt},
      );
      await _storage.write('access_token', res.data['data']['access_token']);
      await _storage.write('refresh_token', res.data['data']['refresh_token']);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    final res = await _dio.get(path, queryParameters: params);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    final res = await _dio.post(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    final res = await _dio.put(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(String path, {dynamic data}) async {
    final res = await _dio.patch(path, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final res = await _dio.delete(path);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadFile(
    String path,
    File file,
    String field, {
    Map<String, dynamic>? extra,
  }) async {
    final form = FormData.fromMap({
      field: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      ...?extra,
    });
    final res = await _dio.post(path, data: form);
    return res.data as Map<String, dynamic>;
  }
}

@riverpod
ApiService apiService(ApiServiceRef ref) =>
    ApiService(ref.watch(storageServiceProvider));

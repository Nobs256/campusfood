import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/api_service.dart';
import 'package:campusfood/core/services/storage_service.dart';
import 'package:campusfood/features/auth/domainModels/user.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';

part 'auth_service.g.dart';

class AuthService {
  final ApiService _api;
  final StorageService _storage;
  AppUser? _currentUser;

  AuthService(this._api, this._storage);

  AppUser? get currentUser => _currentUser;

  Future<bool> isLoggedIn() async {
    final token = await _storage.read('access_token');
    if (token == null) return false;

    if (_currentUser == null) {
      final userData = await _storage.read('user_data');
      if (userData != null) {
        _currentUser = AppUser.fromJson(jsonDecode(userData));
      }
    }
    return _currentUser != null;
  }

  Future<void> login(String email, String password) async {
    final response = await _api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final data = response['data'];
    await _storage.write('access_token', data['access_token']);
    await _storage.write('refresh_token', data['refresh_token']);

    _currentUser = AppUser.fromJson(data['user']);

    // If they are a vendor, the backend returns vendor data in the login response
    if (data['vendor'] != null) {
      _currentUser = _currentUser!.copyWith(
        vendor: Vendor.fromJson(data['vendor']),
      );
    }

    await _storage.write('user_data', jsonEncode(_currentUser!.toJson()));
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String type,
    String? phone,
    String? businessName,
    String? location, String? profileImagePath, String? avatarPath, String? bannerImagePath,
  }) async {
    await _api.post(
      '/auth/register',
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'type': type,
        if (phone != null) 'phone': phone,
        if (businessName != null) 'business_name': businessName,
        if (location != null) 'location': location,
      },
    );
  }

  Future<void> logout() async {
    final rt = await _storage.read('refresh_token');
    if (rt != null) {
      try {
        await _api.post('/auth/logout', data: {'refresh_token': rt});
      } catch (_) {}
    }
    await _storage.deleteAll();
    _currentUser = null;
  }
}

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) => AuthService(
  ref.watch(apiServiceProvider),
  ref.watch(storageServiceProvider),
);

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:campusfood/core/services/auth_service.dart';
import 'package:campusfood/features/auth/domainModels/user.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  AppUser? build() {
    return ref.watch(authServiceProvider).currentUser;
  }

  Future<void> login(String email, String password) async {
    await ref.read(authServiceProvider).login(email, password);
    state = ref.read(authServiceProvider).currentUser;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String type,
    String? phone,
    String? businessName,
    String? location,
    String? avatarPath,
    String? profileImagePath,
    String? bannerImagePath,
  }) async {
    await ref
        .read(authServiceProvider)
        .register(
          fullName: fullName,
          email: email,
          password: password,
          type: type,
          phone: phone,
          businessName: businessName,
          location: location,
          avatarPath: avatarPath,
          profileImagePath: profileImagePath,
          bannerImagePath: bannerImagePath,
        );
    // Sync state if registration auto-logged in or updated local user data
    state = ref.read(authServiceProvider).currentUser;
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = null;
  }

  bool get isAuthenticated => state != null;

  bool get isAdmin => state?.role == 'admin';
  bool get isVendor => state?.role == 'vendor';
  bool get isStudent => state?.role == 'student';
  bool get isGuest => state == null;
}

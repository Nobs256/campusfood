import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:campusfood/features/browse/domainModels/vendor.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    String? phone,
    required String role,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    Vendor? vendor,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

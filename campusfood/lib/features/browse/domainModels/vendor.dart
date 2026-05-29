import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

@freezed
class Vendor with _$Vendor {
  const factory Vendor({
    required int id,
    @JsonKey(name: 'business_name') required String businessName,
    required String slug,
    String? description,
    required String location,
    String? phone,
    String? whatsapp,
    @JsonKey(name: 'opening_time') String? openingTime,
    @JsonKey(name: 'closing_time') String? closingTime,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'banner_image') String? bannerImage,
    required String status,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) required double avgRating,
    @JsonKey(name: 'total_ratings') required int totalRatings,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'food_count') int? foodCount,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'owner_email') String? ownerEmail,
    @JsonKey(name: 'owner_phone') String? ownerPhone,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _Vendor;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return value as double;
}

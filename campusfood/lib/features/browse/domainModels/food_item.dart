import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required int id,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'is_featured') bool? isFeatured,
    @JsonKey(name: 'serving_size') String? servingSize,
    int? calories,
    List<String>? tags,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) required double avgRating,
    @JsonKey(name: 'total_ratings') required int totalRatings,
    required int views,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    @JsonKey(name: 'vendor_id') required int vendorId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'vendor_name') required String vendorName,
    @JsonKey(name: 'vendor_slug') required String vendorSlug,
    @JsonKey(name: 'vendor_location') String? vendorLocation,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'is_cheapest') bool? isCheapest,
    @JsonKey(name: 'is_highest_rated') bool? isHighestRated,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return value as double;
}

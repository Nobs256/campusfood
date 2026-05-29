// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] as bool,
      isFeatured: json['is_featured'] as bool?,
      servingSize: json['serving_size'] as String?,
      calories: (json['calories'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      avgRating: _toDouble(json['avg_rating']),
      totalRatings: (json['total_ratings'] as num).toInt(),
      views: (json['views'] as num).toInt(),
      categoryName: json['category_name'] as String,
      categoryIcon: json['category_icon'] as String?,
      vendorId: (json['vendor_id'] as num).toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      vendorName: json['vendor_name'] as String,
      vendorSlug: json['vendor_slug'] as String,
      vendorLocation: json['vendor_location'] as String?,
      isOpen: json['is_open'] as bool?,
      isCheapest: json['is_cheapest'] as bool?,
      isHighestRated: json['is_highest_rated'] as bool?,
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'is_available': instance.isAvailable,
      'is_featured': instance.isFeatured,
      'serving_size': instance.servingSize,
      'calories': instance.calories,
      'tags': instance.tags,
      'avg_rating': instance.avgRating,
      'total_ratings': instance.totalRatings,
      'views': instance.views,
      'category_name': instance.categoryName,
      'category_icon': instance.categoryIcon,
      'vendor_id': instance.vendorId,
      'category_id': instance.categoryId,
      'vendor_name': instance.vendorName,
      'vendor_slug': instance.vendorSlug,
      'vendor_location': instance.vendorLocation,
      'is_open': instance.isOpen,
      'is_cheapest': instance.isCheapest,
      'is_highest_rated': instance.isHighestRated,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingImpl _$$RatingImplFromJson(Map<String, dynamic> json) => _$RatingImpl(
  id: (json['id'] as num).toInt(),
  stars: (json['stars'] as num).toInt(),
  comment: json['comment'] as String?,
  reviewerName: json['reviewer_name'] as String?,
  reviewerAvatar: json['reviewer_avatar'] as String?,
  foodName: json['food_name'] as String?,
  foodId: (json['food_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$RatingImplToJson(_$RatingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stars': instance.stars,
      'comment': instance.comment,
      'reviewer_name': instance.reviewerName,
      'reviewer_avatar': instance.reviewerAvatar,
      'food_name': instance.foodName,
      'food_id': instance.foodId,
      'created_at': instance.createdAt,
    };

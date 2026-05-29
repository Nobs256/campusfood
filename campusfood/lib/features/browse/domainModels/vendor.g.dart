// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorImpl _$$VendorImplFromJson(Map<String, dynamic> json) => _$VendorImpl(
  id: (json['id'] as num).toInt(),
  businessName: json['business_name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  location: json['location'] as String,
  phone: json['phone'] as String?,
  whatsapp: json['whatsapp'] as String?,
  openingTime: json['opening_time'] as String?,
  closingTime: json['closing_time'] as String?,
  profileImage: json['profile_image'] as String?,
  bannerImage: json['banner_image'] as String?,
  status: json['status'] as String,
  avgRating: _toDouble(json['avg_rating']),
  totalRatings: (json['total_ratings'] as num).toInt(),
  isOpen: json['is_open'] as bool?,
  foodCount: (json['food_count'] as num?)?.toInt(),
  ownerName: json['owner_name'] as String?,
  ownerEmail: json['owner_email'] as String?,
  ownerPhone: json['owner_phone'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$VendorImplToJson(_$VendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_name': instance.businessName,
      'slug': instance.slug,
      'description': instance.description,
      'location': instance.location,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'opening_time': instance.openingTime,
      'closing_time': instance.closingTime,
      'profile_image': instance.profileImage,
      'banner_image': instance.bannerImage,
      'status': instance.status,
      'avg_rating': instance.avgRating,
      'total_ratings': instance.totalRatings,
      'is_open': instance.isOpen,
      'food_count': instance.foodCount,
      'owner_name': instance.ownerName,
      'owner_email': instance.ownerEmail,
      'owner_phone': instance.ownerPhone,
      'created_at': instance.createdAt,
    };

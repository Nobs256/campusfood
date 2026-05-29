// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return _Vendor.fromJson(json);
}

/// @nodoc
mixin _$Vendor {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_name')
  String get businessName => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get whatsapp => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_time')
  String? get openingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'closing_time')
  String? get closingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'banner_image')
  String? get bannerImage => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_ratings')
  int get totalRatings => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_open')
  bool? get isOpen => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_count')
  int? get foodCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_name')
  String? get ownerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_email')
  String? get ownerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_phone')
  String? get ownerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Vendor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vendor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorCopyWith<Vendor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorCopyWith<$Res> {
  factory $VendorCopyWith(Vendor value, $Res Function(Vendor) then) =
      _$VendorCopyWithImpl<$Res, Vendor>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'business_name') String businessName,
    String slug,
    String? description,
    String location,
    String? phone,
    String? whatsapp,
    @JsonKey(name: 'opening_time') String? openingTime,
    @JsonKey(name: 'closing_time') String? closingTime,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'banner_image') String? bannerImage,
    String status,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) double avgRating,
    @JsonKey(name: 'total_ratings') int totalRatings,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'food_count') int? foodCount,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'owner_email') String? ownerEmail,
    @JsonKey(name: 'owner_phone') String? ownerPhone,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$VendorCopyWithImpl<$Res, $Val extends Vendor>
    implements $VendorCopyWith<$Res> {
  _$VendorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vendor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? slug = null,
    Object? description = freezed,
    Object? location = null,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? openingTime = freezed,
    Object? closingTime = freezed,
    Object? profileImage = freezed,
    Object? bannerImage = freezed,
    Object? status = null,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? isOpen = freezed,
    Object? foodCount = freezed,
    Object? ownerName = freezed,
    Object? ownerEmail = freezed,
    Object? ownerPhone = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            businessName:
                null == businessName
                    ? _value.businessName
                    : businessName // ignore: cast_nullable_to_non_nullable
                        as String,
            slug:
                null == slug
                    ? _value.slug
                    : slug // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            whatsapp:
                freezed == whatsapp
                    ? _value.whatsapp
                    : whatsapp // ignore: cast_nullable_to_non_nullable
                        as String?,
            openingTime:
                freezed == openingTime
                    ? _value.openingTime
                    : openingTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            closingTime:
                freezed == closingTime
                    ? _value.closingTime
                    : closingTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            profileImage:
                freezed == profileImage
                    ? _value.profileImage
                    : profileImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            bannerImage:
                freezed == bannerImage
                    ? _value.bannerImage
                    : bannerImage // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            avgRating:
                null == avgRating
                    ? _value.avgRating
                    : avgRating // ignore: cast_nullable_to_non_nullable
                        as double,
            totalRatings:
                null == totalRatings
                    ? _value.totalRatings
                    : totalRatings // ignore: cast_nullable_to_non_nullable
                        as int,
            isOpen:
                freezed == isOpen
                    ? _value.isOpen
                    : isOpen // ignore: cast_nullable_to_non_nullable
                        as bool?,
            foodCount:
                freezed == foodCount
                    ? _value.foodCount
                    : foodCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            ownerName:
                freezed == ownerName
                    ? _value.ownerName
                    : ownerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            ownerEmail:
                freezed == ownerEmail
                    ? _value.ownerEmail
                    : ownerEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            ownerPhone:
                freezed == ownerPhone
                    ? _value.ownerPhone
                    : ownerPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VendorImplCopyWith<$Res> implements $VendorCopyWith<$Res> {
  factory _$$VendorImplCopyWith(
    _$VendorImpl value,
    $Res Function(_$VendorImpl) then,
  ) = __$$VendorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'business_name') String businessName,
    String slug,
    String? description,
    String location,
    String? phone,
    String? whatsapp,
    @JsonKey(name: 'opening_time') String? openingTime,
    @JsonKey(name: 'closing_time') String? closingTime,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'banner_image') String? bannerImage,
    String status,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) double avgRating,
    @JsonKey(name: 'total_ratings') int totalRatings,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'food_count') int? foodCount,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'owner_email') String? ownerEmail,
    @JsonKey(name: 'owner_phone') String? ownerPhone,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$VendorImplCopyWithImpl<$Res>
    extends _$VendorCopyWithImpl<$Res, _$VendorImpl>
    implements _$$VendorImplCopyWith<$Res> {
  __$$VendorImplCopyWithImpl(
    _$VendorImpl _value,
    $Res Function(_$VendorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vendor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? slug = null,
    Object? description = freezed,
    Object? location = null,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? openingTime = freezed,
    Object? closingTime = freezed,
    Object? profileImage = freezed,
    Object? bannerImage = freezed,
    Object? status = null,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? isOpen = freezed,
    Object? foodCount = freezed,
    Object? ownerName = freezed,
    Object? ownerEmail = freezed,
    Object? ownerPhone = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$VendorImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        businessName:
            null == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                    as String,
        slug:
            null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        whatsapp:
            freezed == whatsapp
                ? _value.whatsapp
                : whatsapp // ignore: cast_nullable_to_non_nullable
                    as String?,
        openingTime:
            freezed == openingTime
                ? _value.openingTime
                : openingTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        closingTime:
            freezed == closingTime
                ? _value.closingTime
                : closingTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        profileImage:
            freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        bannerImage:
            freezed == bannerImage
                ? _value.bannerImage
                : bannerImage // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        avgRating:
            null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                    as double,
        totalRatings:
            null == totalRatings
                ? _value.totalRatings
                : totalRatings // ignore: cast_nullable_to_non_nullable
                    as int,
        isOpen:
            freezed == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                    as bool?,
        foodCount:
            freezed == foodCount
                ? _value.foodCount
                : foodCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        ownerName:
            freezed == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        ownerEmail:
            freezed == ownerEmail
                ? _value.ownerEmail
                : ownerEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        ownerPhone:
            freezed == ownerPhone
                ? _value.ownerPhone
                : ownerPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorImpl implements _Vendor {
  const _$VendorImpl({
    required this.id,
    @JsonKey(name: 'business_name') required this.businessName,
    required this.slug,
    this.description,
    required this.location,
    this.phone,
    this.whatsapp,
    @JsonKey(name: 'opening_time') this.openingTime,
    @JsonKey(name: 'closing_time') this.closingTime,
    @JsonKey(name: 'profile_image') this.profileImage,
    @JsonKey(name: 'banner_image') this.bannerImage,
    required this.status,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) required this.avgRating,
    @JsonKey(name: 'total_ratings') required this.totalRatings,
    @JsonKey(name: 'is_open') this.isOpen,
    @JsonKey(name: 'food_count') this.foodCount,
    @JsonKey(name: 'owner_name') this.ownerName,
    @JsonKey(name: 'owner_email') this.ownerEmail,
    @JsonKey(name: 'owner_phone') this.ownerPhone,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$VendorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'business_name')
  final String businessName;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String location;
  @override
  final String? phone;
  @override
  final String? whatsapp;
  @override
  @JsonKey(name: 'opening_time')
  final String? openingTime;
  @override
  @JsonKey(name: 'closing_time')
  final String? closingTime;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  @JsonKey(name: 'banner_image')
  final String? bannerImage;
  @override
  final String status;
  @override
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  final double avgRating;
  @override
  @JsonKey(name: 'total_ratings')
  final int totalRatings;
  @override
  @JsonKey(name: 'is_open')
  final bool? isOpen;
  @override
  @JsonKey(name: 'food_count')
  final int? foodCount;
  @override
  @JsonKey(name: 'owner_name')
  final String? ownerName;
  @override
  @JsonKey(name: 'owner_email')
  final String? ownerEmail;
  @override
  @JsonKey(name: 'owner_phone')
  final String? ownerPhone;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'Vendor(id: $id, businessName: $businessName, slug: $slug, description: $description, location: $location, phone: $phone, whatsapp: $whatsapp, openingTime: $openingTime, closingTime: $closingTime, profileImage: $profileImage, bannerImage: $bannerImage, status: $status, avgRating: $avgRating, totalRatings: $totalRatings, isOpen: $isOpen, foodCount: $foodCount, ownerName: $ownerName, ownerEmail: $ownerEmail, ownerPhone: $ownerPhone, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.whatsapp, whatsapp) ||
                other.whatsapp == whatsapp) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.bannerImage, bannerImage) ||
                other.bannerImage == bannerImage) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.foodCount, foodCount) ||
                other.foodCount == foodCount) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerEmail, ownerEmail) ||
                other.ownerEmail == ownerEmail) &&
            (identical(other.ownerPhone, ownerPhone) ||
                other.ownerPhone == ownerPhone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessName,
    slug,
    description,
    location,
    phone,
    whatsapp,
    openingTime,
    closingTime,
    profileImage,
    bannerImage,
    status,
    avgRating,
    totalRatings,
    isOpen,
    foodCount,
    ownerName,
    ownerEmail,
    ownerPhone,
    createdAt,
  ]);

  /// Create a copy of Vendor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      __$$VendorImplCopyWithImpl<_$VendorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorImplToJson(this);
  }
}

abstract class _Vendor implements Vendor {
  const factory _Vendor({
    required final int id,
    @JsonKey(name: 'business_name') required final String businessName,
    required final String slug,
    final String? description,
    required final String location,
    final String? phone,
    final String? whatsapp,
    @JsonKey(name: 'opening_time') final String? openingTime,
    @JsonKey(name: 'closing_time') final String? closingTime,
    @JsonKey(name: 'profile_image') final String? profileImage,
    @JsonKey(name: 'banner_image') final String? bannerImage,
    required final String status,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble)
    required final double avgRating,
    @JsonKey(name: 'total_ratings') required final int totalRatings,
    @JsonKey(name: 'is_open') final bool? isOpen,
    @JsonKey(name: 'food_count') final int? foodCount,
    @JsonKey(name: 'owner_name') final String? ownerName,
    @JsonKey(name: 'owner_email') final String? ownerEmail,
    @JsonKey(name: 'owner_phone') final String? ownerPhone,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$VendorImpl;

  factory _Vendor.fromJson(Map<String, dynamic> json) = _$VendorImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'business_name')
  String get businessName;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String get location;
  @override
  String? get phone;
  @override
  String? get whatsapp;
  @override
  @JsonKey(name: 'opening_time')
  String? get openingTime;
  @override
  @JsonKey(name: 'closing_time')
  String? get closingTime;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  @JsonKey(name: 'banner_image')
  String? get bannerImage;
  @override
  String get status;
  @override
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  double get avgRating;
  @override
  @JsonKey(name: 'total_ratings')
  int get totalRatings;
  @override
  @JsonKey(name: 'is_open')
  bool? get isOpen;
  @override
  @JsonKey(name: 'food_count')
  int? get foodCount;
  @override
  @JsonKey(name: 'owner_name')
  String? get ownerName;
  @override
  @JsonKey(name: 'owner_email')
  String? get ownerEmail;
  @override
  @JsonKey(name: 'owner_phone')
  String? get ownerPhone;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of Vendor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

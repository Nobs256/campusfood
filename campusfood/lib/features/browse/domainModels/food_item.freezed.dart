// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool? get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_size')
  String? get servingSize => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_ratings')
  int get totalRatings => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_icon')
  String? get categoryIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  int get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_name')
  String get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_slug')
  String get vendorSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_location')
  String? get vendorLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_open')
  bool? get isOpen => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_cheapest')
  bool? get isCheapest => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_highest_rated')
  bool? get isHighestRated => throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'is_featured') bool? isFeatured,
    @JsonKey(name: 'serving_size') String? servingSize,
    int? calories,
    List<String>? tags,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) double avgRating,
    @JsonKey(name: 'total_ratings') int totalRatings,
    int views,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    @JsonKey(name: 'vendor_id') int vendorId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'vendor_name') String vendorName,
    @JsonKey(name: 'vendor_slug') String vendorSlug,
    @JsonKey(name: 'vendor_location') String? vendorLocation,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'is_cheapest') bool? isCheapest,
    @JsonKey(name: 'is_highest_rated') bool? isHighestRated,
  });
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? isFeatured = freezed,
    Object? servingSize = freezed,
    Object? calories = freezed,
    Object? tags = freezed,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? views = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? vendorId = null,
    Object? categoryId = freezed,
    Object? vendorName = null,
    Object? vendorSlug = null,
    Object? vendorLocation = freezed,
    Object? isOpen = freezed,
    Object? isCheapest = freezed,
    Object? isHighestRated = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isAvailable:
                null == isAvailable
                    ? _value.isAvailable
                    : isAvailable // ignore: cast_nullable_to_non_nullable
                        as bool,
            isFeatured:
                freezed == isFeatured
                    ? _value.isFeatured
                    : isFeatured // ignore: cast_nullable_to_non_nullable
                        as bool?,
            servingSize:
                freezed == servingSize
                    ? _value.servingSize
                    : servingSize // ignore: cast_nullable_to_non_nullable
                        as String?,
            calories:
                freezed == calories
                    ? _value.calories
                    : calories // ignore: cast_nullable_to_non_nullable
                        as int?,
            tags:
                freezed == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
            views:
                null == views
                    ? _value.views
                    : views // ignore: cast_nullable_to_non_nullable
                        as int,
            categoryName:
                null == categoryName
                    ? _value.categoryName
                    : categoryName // ignore: cast_nullable_to_non_nullable
                        as String,
            categoryIcon:
                freezed == categoryIcon
                    ? _value.categoryIcon
                    : categoryIcon // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorId:
                null == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as int,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as int?,
            vendorName:
                null == vendorName
                    ? _value.vendorName
                    : vendorName // ignore: cast_nullable_to_non_nullable
                        as String,
            vendorSlug:
                null == vendorSlug
                    ? _value.vendorSlug
                    : vendorSlug // ignore: cast_nullable_to_non_nullable
                        as String,
            vendorLocation:
                freezed == vendorLocation
                    ? _value.vendorLocation
                    : vendorLocation // ignore: cast_nullable_to_non_nullable
                        as String?,
            isOpen:
                freezed == isOpen
                    ? _value.isOpen
                    : isOpen // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isCheapest:
                freezed == isCheapest
                    ? _value.isCheapest
                    : isCheapest // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isHighestRated:
                freezed == isHighestRated
                    ? _value.isHighestRated
                    : isHighestRated // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
    _$FoodItemImpl value,
    $Res Function(_$FoodItemImpl) then,
  ) = __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'is_featured') bool? isFeatured,
    @JsonKey(name: 'serving_size') String? servingSize,
    int? calories,
    List<String>? tags,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) double avgRating,
    @JsonKey(name: 'total_ratings') int totalRatings,
    int views,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    @JsonKey(name: 'vendor_id') int vendorId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'vendor_name') String vendorName,
    @JsonKey(name: 'vendor_slug') String vendorSlug,
    @JsonKey(name: 'vendor_location') String? vendorLocation,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'is_cheapest') bool? isCheapest,
    @JsonKey(name: 'is_highest_rated') bool? isHighestRated,
  });
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
    _$FoodItemImpl _value,
    $Res Function(_$FoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? isFeatured = freezed,
    Object? servingSize = freezed,
    Object? calories = freezed,
    Object? tags = freezed,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? views = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? vendorId = null,
    Object? categoryId = freezed,
    Object? vendorName = null,
    Object? vendorSlug = null,
    Object? vendorLocation = freezed,
    Object? isOpen = freezed,
    Object? isCheapest = freezed,
    Object? isHighestRated = freezed,
  }) {
    return _then(
      _$FoodItemImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isAvailable:
            null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                    as bool,
        isFeatured:
            freezed == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                    as bool?,
        servingSize:
            freezed == servingSize
                ? _value.servingSize
                : servingSize // ignore: cast_nullable_to_non_nullable
                    as String?,
        calories:
            freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                    as int?,
        tags:
            freezed == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
        views:
            null == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                    as int,
        categoryName:
            null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                    as String,
        categoryIcon:
            freezed == categoryIcon
                ? _value.categoryIcon
                : categoryIcon // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorId:
            null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as int,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as int?,
        vendorName:
            null == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                    as String,
        vendorSlug:
            null == vendorSlug
                ? _value.vendorSlug
                : vendorSlug // ignore: cast_nullable_to_non_nullable
                    as String,
        vendorLocation:
            freezed == vendorLocation
                ? _value.vendorLocation
                : vendorLocation // ignore: cast_nullable_to_non_nullable
                    as String?,
        isOpen:
            freezed == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isCheapest:
            freezed == isCheapest
                ? _value.isCheapest
                : isCheapest // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isHighestRated:
            freezed == isHighestRated
                ? _value.isHighestRated
                : isHighestRated // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'is_available') required this.isAvailable,
    @JsonKey(name: 'is_featured') this.isFeatured,
    @JsonKey(name: 'serving_size') this.servingSize,
    this.calories,
    final List<String>? tags,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble) required this.avgRating,
    @JsonKey(name: 'total_ratings') required this.totalRatings,
    required this.views,
    @JsonKey(name: 'category_name') required this.categoryName,
    @JsonKey(name: 'category_icon') this.categoryIcon,
    @JsonKey(name: 'vendor_id') required this.vendorId,
    @JsonKey(name: 'category_id') this.categoryId,
    @JsonKey(name: 'vendor_name') required this.vendorName,
    @JsonKey(name: 'vendor_slug') required this.vendorSlug,
    @JsonKey(name: 'vendor_location') this.vendorLocation,
    @JsonKey(name: 'is_open') this.isOpen,
    @JsonKey(name: 'is_cheapest') this.isCheapest,
    @JsonKey(name: 'is_highest_rated') this.isHighestRated,
  }) : _tags = tags;

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'is_featured')
  final bool? isFeatured;
  @override
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @override
  final int? calories;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  final double avgRating;
  @override
  @JsonKey(name: 'total_ratings')
  final int totalRatings;
  @override
  final int views;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'category_icon')
  final String? categoryIcon;
  @override
  @JsonKey(name: 'vendor_id')
  final int vendorId;
  @override
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @override
  @JsonKey(name: 'vendor_name')
  final String vendorName;
  @override
  @JsonKey(name: 'vendor_slug')
  final String vendorSlug;
  @override
  @JsonKey(name: 'vendor_location')
  final String? vendorLocation;
  @override
  @JsonKey(name: 'is_open')
  final bool? isOpen;
  @override
  @JsonKey(name: 'is_cheapest')
  final bool? isCheapest;
  @override
  @JsonKey(name: 'is_highest_rated')
  final bool? isHighestRated;

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, isAvailable: $isAvailable, isFeatured: $isFeatured, servingSize: $servingSize, calories: $calories, tags: $tags, avgRating: $avgRating, totalRatings: $totalRatings, views: $views, categoryName: $categoryName, categoryIcon: $categoryIcon, vendorId: $vendorId, categoryId: $categoryId, vendorName: $vendorName, vendorSlug: $vendorSlug, vendorLocation: $vendorLocation, isOpen: $isOpen, isCheapest: $isCheapest, isHighestRated: $isHighestRated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.vendorSlug, vendorSlug) ||
                other.vendorSlug == vendorSlug) &&
            (identical(other.vendorLocation, vendorLocation) ||
                other.vendorLocation == vendorLocation) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.isCheapest, isCheapest) ||
                other.isCheapest == isCheapest) &&
            (identical(other.isHighestRated, isHighestRated) ||
                other.isHighestRated == isHighestRated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    price,
    imageUrl,
    isAvailable,
    isFeatured,
    servingSize,
    calories,
    const DeepCollectionEquality().hash(_tags),
    avgRating,
    totalRatings,
    views,
    categoryName,
    categoryIcon,
    vendorId,
    categoryId,
    vendorName,
    vendorSlug,
    vendorLocation,
    isOpen,
    isCheapest,
    isHighestRated,
  ]);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(this);
  }
}

abstract class _FoodItem implements FoodItem {
  const factory _FoodItem({
    required final int id,
    required final String name,
    final String? description,
    required final double price,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'is_available') required final bool isAvailable,
    @JsonKey(name: 'is_featured') final bool? isFeatured,
    @JsonKey(name: 'serving_size') final String? servingSize,
    final int? calories,
    final List<String>? tags,
    @JsonKey(name: 'avg_rating', fromJson: _toDouble)
    required final double avgRating,
    @JsonKey(name: 'total_ratings') required final int totalRatings,
    required final int views,
    @JsonKey(name: 'category_name') required final String categoryName,
    @JsonKey(name: 'category_icon') final String? categoryIcon,
    @JsonKey(name: 'vendor_id') required final int vendorId,
    @JsonKey(name: 'category_id') final int? categoryId,
    @JsonKey(name: 'vendor_name') required final String vendorName,
    @JsonKey(name: 'vendor_slug') required final String vendorSlug,
    @JsonKey(name: 'vendor_location') final String? vendorLocation,
    @JsonKey(name: 'is_open') final bool? isOpen,
    @JsonKey(name: 'is_cheapest') final bool? isCheapest,
    @JsonKey(name: 'is_highest_rated') final bool? isHighestRated,
  }) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'is_featured')
  bool? get isFeatured;
  @override
  @JsonKey(name: 'serving_size')
  String? get servingSize;
  @override
  int? get calories;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'avg_rating', fromJson: _toDouble)
  double get avgRating;
  @override
  @JsonKey(name: 'total_ratings')
  int get totalRatings;
  @override
  int get views;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'category_icon')
  String? get categoryIcon;
  @override
  @JsonKey(name: 'vendor_id')
  int get vendorId;
  @override
  @JsonKey(name: 'category_id')
  int? get categoryId;
  @override
  @JsonKey(name: 'vendor_name')
  String get vendorName;
  @override
  @JsonKey(name: 'vendor_slug')
  String get vendorSlug;
  @override
  @JsonKey(name: 'vendor_location')
  String? get vendorLocation;
  @override
  @JsonKey(name: 'is_open')
  bool? get isOpen;
  @override
  @JsonKey(name: 'is_cheapest')
  bool? get isCheapest;
  @override
  @JsonKey(name: 'is_highest_rated')
  bool? get isHighestRated;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

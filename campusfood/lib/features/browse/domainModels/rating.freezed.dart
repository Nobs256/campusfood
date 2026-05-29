// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return _Rating.fromJson(json);
}

/// @nodoc
mixin _$Rating {
  int get id => throw _privateConstructorUsedError;
  int get stars => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewer_name')
  String? get reviewerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewer_avatar')
  String? get reviewerAvatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_name')
  String? get foodName => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_id')
  int? get foodId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Rating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingCopyWith<Rating> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingCopyWith<$Res> {
  factory $RatingCopyWith(Rating value, $Res Function(Rating) then) =
      _$RatingCopyWithImpl<$Res, Rating>;
  @useResult
  $Res call({
    int id,
    int stars,
    String? comment,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    @JsonKey(name: 'reviewer_avatar') String? reviewerAvatar,
    @JsonKey(name: 'food_name') String? foodName,
    @JsonKey(name: 'food_id') int? foodId,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$RatingCopyWithImpl<$Res, $Val extends Rating>
    implements $RatingCopyWith<$Res> {
  _$RatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stars = null,
    Object? comment = freezed,
    Object? reviewerName = freezed,
    Object? reviewerAvatar = freezed,
    Object? foodName = freezed,
    Object? foodId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            stars:
                null == stars
                    ? _value.stars
                    : stars // ignore: cast_nullable_to_non_nullable
                        as int,
            comment:
                freezed == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviewerName:
                freezed == reviewerName
                    ? _value.reviewerName
                    : reviewerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviewerAvatar:
                freezed == reviewerAvatar
                    ? _value.reviewerAvatar
                    : reviewerAvatar // ignore: cast_nullable_to_non_nullable
                        as String?,
            foodName:
                freezed == foodName
                    ? _value.foodName
                    : foodName // ignore: cast_nullable_to_non_nullable
                        as String?,
            foodId:
                freezed == foodId
                    ? _value.foodId
                    : foodId // ignore: cast_nullable_to_non_nullable
                        as int?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RatingImplCopyWith<$Res> implements $RatingCopyWith<$Res> {
  factory _$$RatingImplCopyWith(
    _$RatingImpl value,
    $Res Function(_$RatingImpl) then,
  ) = __$$RatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int stars,
    String? comment,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    @JsonKey(name: 'reviewer_avatar') String? reviewerAvatar,
    @JsonKey(name: 'food_name') String? foodName,
    @JsonKey(name: 'food_id') int? foodId,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$RatingImplCopyWithImpl<$Res>
    extends _$RatingCopyWithImpl<$Res, _$RatingImpl>
    implements _$$RatingImplCopyWith<$Res> {
  __$$RatingImplCopyWithImpl(
    _$RatingImpl _value,
    $Res Function(_$RatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stars = null,
    Object? comment = freezed,
    Object? reviewerName = freezed,
    Object? reviewerAvatar = freezed,
    Object? foodName = freezed,
    Object? foodId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$RatingImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        stars:
            null == stars
                ? _value.stars
                : stars // ignore: cast_nullable_to_non_nullable
                    as int,
        comment:
            freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviewerName:
            freezed == reviewerName
                ? _value.reviewerName
                : reviewerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviewerAvatar:
            freezed == reviewerAvatar
                ? _value.reviewerAvatar
                : reviewerAvatar // ignore: cast_nullable_to_non_nullable
                    as String?,
        foodName:
            freezed == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                    as String?,
        foodId:
            freezed == foodId
                ? _value.foodId
                : foodId // ignore: cast_nullable_to_non_nullable
                    as int?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingImpl implements _Rating {
  const _$RatingImpl({
    required this.id,
    required this.stars,
    this.comment,
    @JsonKey(name: 'reviewer_name') this.reviewerName,
    @JsonKey(name: 'reviewer_avatar') this.reviewerAvatar,
    @JsonKey(name: 'food_name') this.foodName,
    @JsonKey(name: 'food_id') this.foodId,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$RatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingImplFromJson(json);

  @override
  final int id;
  @override
  final int stars;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'reviewer_name')
  final String? reviewerName;
  @override
  @JsonKey(name: 'reviewer_avatar')
  final String? reviewerAvatar;
  @override
  @JsonKey(name: 'food_name')
  final String? foodName;
  @override
  @JsonKey(name: 'food_id')
  final int? foodId;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'Rating(id: $id, stars: $stars, comment: $comment, reviewerName: $reviewerName, reviewerAvatar: $reviewerAvatar, foodName: $foodName, foodId: $foodId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.reviewerAvatar, reviewerAvatar) ||
                other.reviewerAvatar == reviewerAvatar) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stars,
    comment,
    reviewerName,
    reviewerAvatar,
    foodName,
    foodId,
    createdAt,
  );

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingImplCopyWith<_$RatingImpl> get copyWith =>
      __$$RatingImplCopyWithImpl<_$RatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingImplToJson(this);
  }
}

abstract class _Rating implements Rating {
  const factory _Rating({
    required final int id,
    required final int stars,
    final String? comment,
    @JsonKey(name: 'reviewer_name') final String? reviewerName,
    @JsonKey(name: 'reviewer_avatar') final String? reviewerAvatar,
    @JsonKey(name: 'food_name') final String? foodName,
    @JsonKey(name: 'food_id') final int? foodId,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$RatingImpl;

  factory _Rating.fromJson(Map<String, dynamic> json) = _$RatingImpl.fromJson;

  @override
  int get id;
  @override
  int get stars;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'reviewer_name')
  String? get reviewerName;
  @override
  @JsonKey(name: 'reviewer_avatar')
  String? get reviewerAvatar;
  @override
  @JsonKey(name: 'food_name')
  String? get foodName;
  @override
  @JsonKey(name: 'food_id')
  int? get foodId;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of Rating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingImplCopyWith<_$RatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

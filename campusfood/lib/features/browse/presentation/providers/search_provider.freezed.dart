// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchFilters {
  String? get query => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  double? get minPrice => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  bool? get availableOnly => throw _privateConstructorUsedError;
  int? get vendorId => throw _privateConstructorUsedError;
  String get sort => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFiltersCopyWith<SearchFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFiltersCopyWith<$Res> {
  factory $SearchFiltersCopyWith(
    SearchFilters value,
    $Res Function(SearchFilters) then,
  ) = _$SearchFiltersCopyWithImpl<$Res, SearchFilters>;
  @useResult
  $Res call({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? availableOnly,
    int? vendorId,
    String sort,
  });
}

/// @nodoc
class _$SearchFiltersCopyWithImpl<$Res, $Val extends SearchFilters>
    implements $SearchFiltersCopyWith<$Res> {
  _$SearchFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? categoryId = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? availableOnly = freezed,
    Object? vendorId = freezed,
    Object? sort = null,
  }) {
    return _then(
      _value.copyWith(
            query:
                freezed == query
                    ? _value.query
                    : query // ignore: cast_nullable_to_non_nullable
                        as String?,
            categoryId:
                freezed == categoryId
                    ? _value.categoryId
                    : categoryId // ignore: cast_nullable_to_non_nullable
                        as int?,
            minPrice:
                freezed == minPrice
                    ? _value.minPrice
                    : minPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            maxPrice:
                freezed == maxPrice
                    ? _value.maxPrice
                    : maxPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            availableOnly:
                freezed == availableOnly
                    ? _value.availableOnly
                    : availableOnly // ignore: cast_nullable_to_non_nullable
                        as bool?,
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as int?,
            sort:
                null == sort
                    ? _value.sort
                    : sort // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFiltersImplCopyWith<$Res>
    implements $SearchFiltersCopyWith<$Res> {
  factory _$$SearchFiltersImplCopyWith(
    _$SearchFiltersImpl value,
    $Res Function(_$SearchFiltersImpl) then,
  ) = __$$SearchFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? availableOnly,
    int? vendorId,
    String sort,
  });
}

/// @nodoc
class __$$SearchFiltersImplCopyWithImpl<$Res>
    extends _$SearchFiltersCopyWithImpl<$Res, _$SearchFiltersImpl>
    implements _$$SearchFiltersImplCopyWith<$Res> {
  __$$SearchFiltersImplCopyWithImpl(
    _$SearchFiltersImpl _value,
    $Res Function(_$SearchFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? categoryId = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? availableOnly = freezed,
    Object? vendorId = freezed,
    Object? sort = null,
  }) {
    return _then(
      _$SearchFiltersImpl(
        query:
            freezed == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                    as String?,
        categoryId:
            freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                    as int?,
        minPrice:
            freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        maxPrice:
            freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        availableOnly:
            freezed == availableOnly
                ? _value.availableOnly
                : availableOnly // ignore: cast_nullable_to_non_nullable
                    as bool?,
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as int?,
        sort:
            null == sort
                ? _value.sort
                : sort // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchFiltersImpl implements _SearchFilters {
  const _$SearchFiltersImpl({
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.availableOnly,
    this.vendorId,
    this.sort = 'newest',
  });

  @override
  final String? query;
  @override
  final int? categoryId;
  @override
  final double? minPrice;
  @override
  final double? maxPrice;
  @override
  final bool? availableOnly;
  @override
  final int? vendorId;
  @override
  @JsonKey()
  final String sort;

  @override
  String toString() {
    return 'SearchFilters(query: $query, categoryId: $categoryId, minPrice: $minPrice, maxPrice: $maxPrice, availableOnly: $availableOnly, vendorId: $vendorId, sort: $sort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFiltersImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.availableOnly, availableOnly) ||
                other.availableOnly == availableOnly) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    categoryId,
    minPrice,
    maxPrice,
    availableOnly,
    vendorId,
    sort,
  );

  /// Create a copy of SearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFiltersImplCopyWith<_$SearchFiltersImpl> get copyWith =>
      __$$SearchFiltersImplCopyWithImpl<_$SearchFiltersImpl>(this, _$identity);
}

abstract class _SearchFilters implements SearchFilters {
  const factory _SearchFilters({
    final String? query,
    final int? categoryId,
    final double? minPrice,
    final double? maxPrice,
    final bool? availableOnly,
    final int? vendorId,
    final String sort,
  }) = _$SearchFiltersImpl;

  @override
  String? get query;
  @override
  int? get categoryId;
  @override
  double? get minPrice;
  @override
  double? get maxPrice;
  @override
  bool? get availableOnly;
  @override
  int? get vendorId;
  @override
  String get sort;

  /// Create a copy of SearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFiltersImplCopyWith<_$SearchFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

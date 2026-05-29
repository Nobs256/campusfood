// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foods_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesListHash() => r'98c178fe0be863b859919ebaf5af582424f8c277';

/// See also [categoriesList].
@ProviderFor(categoriesList)
final categoriesListProvider =
    AutoDisposeFutureProvider<List<Category>>.internal(
      categoriesList,
      name: r'categoriesListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categoriesListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesListRef = AutoDisposeFutureProviderRef<List<Category>>;
String _$featuredFoodsHash() => r'17ec7987d699243b93ae79bec1295a09e6919250';

/// See also [featuredFoods].
@ProviderFor(featuredFoods)
final featuredFoodsProvider =
    AutoDisposeFutureProvider<List<FoodItem>>.internal(
      featuredFoods,
      name: r'featuredFoodsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$featuredFoodsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedFoodsRef = AutoDisposeFutureProviderRef<List<FoodItem>>;
String _$foodsListHash() => r'386331ac226df84b00f2f4a810ea36e99a74d414';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [foodsList].
@ProviderFor(foodsList)
const foodsListProvider = FoodsListFamily();

/// See also [foodsList].
class FoodsListFamily extends Family<AsyncValue<List<FoodItem>>> {
  /// See also [foodsList].
  const FoodsListFamily();

  /// See also [foodsList].
  FoodsListProvider call({int? vendorId, int? categoryId, String? sort}) {
    return FoodsListProvider(
      vendorId: vendorId,
      categoryId: categoryId,
      sort: sort,
    );
  }

  @override
  FoodsListProvider getProviderOverride(covariant FoodsListProvider provider) {
    return call(
      vendorId: provider.vendorId,
      categoryId: provider.categoryId,
      sort: provider.sort,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'foodsListProvider';
}

/// See also [foodsList].
class FoodsListProvider extends AutoDisposeFutureProvider<List<FoodItem>> {
  /// See also [foodsList].
  FoodsListProvider({int? vendorId, int? categoryId, String? sort})
    : this._internal(
        (ref) => foodsList(
          ref as FoodsListRef,
          vendorId: vendorId,
          categoryId: categoryId,
          sort: sort,
        ),
        from: foodsListProvider,
        name: r'foodsListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$foodsListHash,
        dependencies: FoodsListFamily._dependencies,
        allTransitiveDependencies: FoodsListFamily._allTransitiveDependencies,
        vendorId: vendorId,
        categoryId: categoryId,
        sort: sort,
      );

  FoodsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vendorId,
    required this.categoryId,
    required this.sort,
  }) : super.internal();

  final int? vendorId;
  final int? categoryId;
  final String? sort;

  @override
  Override overrideWith(
    FutureOr<List<FoodItem>> Function(FoodsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FoodsListProvider._internal(
        (ref) => create(ref as FoodsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vendorId: vendorId,
        categoryId: categoryId,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FoodItem>> createElement() {
    return _FoodsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodsListProvider &&
        other.vendorId == vendorId &&
        other.categoryId == categoryId &&
        other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vendorId.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodsListRef on AutoDisposeFutureProviderRef<List<FoodItem>> {
  /// The parameter `vendorId` of this provider.
  int? get vendorId;

  /// The parameter `categoryId` of this provider.
  int? get categoryId;

  /// The parameter `sort` of this provider.
  String? get sort;
}

class _FoodsListProviderElement
    extends AutoDisposeFutureProviderElement<List<FoodItem>>
    with FoodsListRef {
  _FoodsListProviderElement(super.provider);

  @override
  int? get vendorId => (origin as FoodsListProvider).vendorId;
  @override
  int? get categoryId => (origin as FoodsListProvider).categoryId;
  @override
  String? get sort => (origin as FoodsListProvider).sort;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

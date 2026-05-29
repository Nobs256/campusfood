// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRatingsHash() => r'a05fbaf70be0051b9c99609262d229a270ea4c79';

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

/// See also [foodRatings].
@ProviderFor(foodRatings)
const foodRatingsProvider = FoodRatingsFamily();

/// See also [foodRatings].
class FoodRatingsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [foodRatings].
  const FoodRatingsFamily();

  /// See also [foodRatings].
  FoodRatingsProvider call(int foodId, {int page = 1}) {
    return FoodRatingsProvider(foodId, page: page);
  }

  @override
  FoodRatingsProvider getProviderOverride(
    covariant FoodRatingsProvider provider,
  ) {
    return call(provider.foodId, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'foodRatingsProvider';
}

/// See also [foodRatings].
class FoodRatingsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [foodRatings].
  FoodRatingsProvider(int foodId, {int page = 1})
    : this._internal(
        (ref) => foodRatings(ref as FoodRatingsRef, foodId, page: page),
        from: foodRatingsProvider,
        name: r'foodRatingsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$foodRatingsHash,
        dependencies: FoodRatingsFamily._dependencies,
        allTransitiveDependencies: FoodRatingsFamily._allTransitiveDependencies,
        foodId: foodId,
        page: page,
      );

  FoodRatingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.foodId,
    required this.page,
  }) : super.internal();

  final int foodId;
  final int page;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(FoodRatingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FoodRatingsProvider._internal(
        (ref) => create(ref as FoodRatingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        foodId: foodId,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _FoodRatingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodRatingsProvider &&
        other.foodId == foodId &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, foodId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodRatingsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `foodId` of this provider.
  int get foodId;

  /// The parameter `page` of this provider.
  int get page;
}

class _FoodRatingsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with FoodRatingsRef {
  _FoodRatingsProviderElement(super.provider);

  @override
  int get foodId => (origin as FoodRatingsProvider).foodId;
  @override
  int get page => (origin as FoodRatingsProvider).page;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

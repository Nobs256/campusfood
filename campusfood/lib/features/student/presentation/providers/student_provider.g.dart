// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentFavoritesHash() => r'0d794e2cc406939d1be15f45749ce638e168f229';

/// See also [studentFavorites].
@ProviderFor(studentFavorites)
final studentFavoritesProvider =
    AutoDisposeFutureProvider<List<FoodItem>>.internal(
      studentFavorites,
      name: r'studentFavoritesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$studentFavoritesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudentFavoritesRef = AutoDisposeFutureProviderRef<List<FoodItem>>;
String _$studentRatingsHash() => r'be0705686407e155d5ff78b46f3d83ac12a828e8';

/// See also [studentRatings].
@ProviderFor(studentRatings)
final studentRatingsProvider = AutoDisposeFutureProvider<List<Rating>>.internal(
  studentRatings,
  name: r'studentRatingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studentRatingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudentRatingsRef = AutoDisposeFutureProviderRef<List<Rating>>;
String _$favoriteToggleNotifierHash() =>
    r'c5fe39b9f958db3ddfc6d6d6b9766a9c7156b0fa';

/// See also [FavoriteToggleNotifier].
@ProviderFor(FavoriteToggleNotifier)
final favoriteToggleNotifierProvider =
    AutoDisposeNotifierProvider<FavoriteToggleNotifier, void>.internal(
      FavoriteToggleNotifier.new,
      name: r'favoriteToggleNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$favoriteToggleNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteToggleNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

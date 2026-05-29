// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendors_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorsListHash() => r'24a2e5537876fd1f67fcb8a17d2117a0e2069de9';

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

/// See also [vendorsList].
@ProviderFor(vendorsList)
const vendorsListProvider = VendorsListFamily();

/// See also [vendorsList].
class VendorsListFamily extends Family<AsyncValue<List<Vendor>>> {
  /// See also [vendorsList].
  const VendorsListFamily();

  /// See also [vendorsList].
  VendorsListProvider call({String status = 'approved'}) {
    return VendorsListProvider(status: status);
  }

  @override
  VendorsListProvider getProviderOverride(
    covariant VendorsListProvider provider,
  ) {
    return call(status: provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vendorsListProvider';
}

/// See also [vendorsList].
class VendorsListProvider extends AutoDisposeFutureProvider<List<Vendor>> {
  /// See also [vendorsList].
  VendorsListProvider({String status = 'approved'})
    : this._internal(
        (ref) => vendorsList(ref as VendorsListRef, status: status),
        from: vendorsListProvider,
        name: r'vendorsListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$vendorsListHash,
        dependencies: VendorsListFamily._dependencies,
        allTransitiveDependencies: VendorsListFamily._allTransitiveDependencies,
        status: status,
      );

  VendorsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  Override overrideWith(
    FutureOr<List<Vendor>> Function(VendorsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VendorsListProvider._internal(
        (ref) => create(ref as VendorsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Vendor>> createElement() {
    return _VendorsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorsListProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VendorsListRef on AutoDisposeFutureProviderRef<List<Vendor>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _VendorsListProviderElement
    extends AutoDisposeFutureProviderElement<List<Vendor>>
    with VendorsListRef {
  _VendorsListProviderElement(super.provider);

  @override
  String get status => (origin as VendorsListProvider).status;
}

String _$vendorDetailHash() => r'9e3fb82ac3fcfd540c49b3638496a39bffd5e0bd';

/// See also [vendorDetail].
@ProviderFor(vendorDetail)
const vendorDetailProvider = VendorDetailFamily();

/// See also [vendorDetail].
class VendorDetailFamily extends Family<AsyncValue<Vendor>> {
  /// See also [vendorDetail].
  const VendorDetailFamily();

  /// See also [vendorDetail].
  VendorDetailProvider call(int id) {
    return VendorDetailProvider(id);
  }

  @override
  VendorDetailProvider getProviderOverride(
    covariant VendorDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vendorDetailProvider';
}

/// See also [vendorDetail].
class VendorDetailProvider extends AutoDisposeFutureProvider<Vendor> {
  /// See also [vendorDetail].
  VendorDetailProvider(int id)
    : this._internal(
        (ref) => vendorDetail(ref as VendorDetailRef, id),
        from: vendorDetailProvider,
        name: r'vendorDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$vendorDetailHash,
        dependencies: VendorDetailFamily._dependencies,
        allTransitiveDependencies:
            VendorDetailFamily._allTransitiveDependencies,
        id: id,
      );

  VendorDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Vendor> Function(VendorDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VendorDetailProvider._internal(
        (ref) => create(ref as VendorDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Vendor> createElement() {
    return _VendorDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VendorDetailRef on AutoDisposeFutureProviderRef<Vendor> {
  /// The parameter `id` of this provider.
  int get id;
}

class _VendorDetailProviderElement
    extends AutoDisposeFutureProviderElement<Vendor>
    with VendorDetailRef {
  _VendorDetailProviderElement(super.provider);

  @override
  int get id => (origin as VendorDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

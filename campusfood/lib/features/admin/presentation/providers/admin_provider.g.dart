// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDashboardHash() => r'5cbaa799338764cdd90146b7c305feee0242fe68';

/// See also [adminDashboard].
@ProviderFor(adminDashboard)
final adminDashboardProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      adminDashboard,
      name: r'adminDashboardProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$adminDashboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminDashboardRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$adminVendorsHash() => r'fda652e8fd2e066c7cff89043298a464fa9f7062';

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

/// See also [adminVendors].
@ProviderFor(adminVendors)
const adminVendorsProvider = AdminVendorsFamily();

/// See also [adminVendors].
class AdminVendorsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [adminVendors].
  const AdminVendorsFamily();

  /// See also [adminVendors].
  AdminVendorsProvider call({String status = '', int page = 1}) {
    return AdminVendorsProvider(status: status, page: page);
  }

  @override
  AdminVendorsProvider getProviderOverride(
    covariant AdminVendorsProvider provider,
  ) {
    return call(status: provider.status, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adminVendorsProvider';
}

/// See also [adminVendors].
class AdminVendorsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [adminVendors].
  AdminVendorsProvider({String status = '', int page = 1})
    : this._internal(
        (ref) =>
            adminVendors(ref as AdminVendorsRef, status: status, page: page),
        from: adminVendorsProvider,
        name: r'adminVendorsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$adminVendorsHash,
        dependencies: AdminVendorsFamily._dependencies,
        allTransitiveDependencies:
            AdminVendorsFamily._allTransitiveDependencies,
        status: status,
        page: page,
      );

  AdminVendorsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.page,
  }) : super.internal();

  final String status;
  final int page;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(AdminVendorsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminVendorsProvider._internal(
        (ref) => create(ref as AdminVendorsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _AdminVendorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminVendorsProvider &&
        other.status == status &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdminVendorsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `status` of this provider.
  String get status;

  /// The parameter `page` of this provider.
  int get page;
}

class _AdminVendorsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with AdminVendorsRef {
  _AdminVendorsProviderElement(super.provider);

  @override
  String get status => (origin as AdminVendorsProvider).status;
  @override
  int get page => (origin as AdminVendorsProvider).page;
}

String _$adminVendorDetailHash() => r'bd137f57af94323bac22d1b9f9b8cc20ce37b4a7';

/// See also [adminVendorDetail].
@ProviderFor(adminVendorDetail)
const adminVendorDetailProvider = AdminVendorDetailFamily();

/// See also [adminVendorDetail].
class AdminVendorDetailFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [adminVendorDetail].
  const AdminVendorDetailFamily();

  /// See also [adminVendorDetail].
  AdminVendorDetailProvider call(int vendorId) {
    return AdminVendorDetailProvider(vendorId);
  }

  @override
  AdminVendorDetailProvider getProviderOverride(
    covariant AdminVendorDetailProvider provider,
  ) {
    return call(provider.vendorId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adminVendorDetailProvider';
}

/// See also [adminVendorDetail].
class AdminVendorDetailProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [adminVendorDetail].
  AdminVendorDetailProvider(int vendorId)
    : this._internal(
        (ref) => adminVendorDetail(ref as AdminVendorDetailRef, vendorId),
        from: adminVendorDetailProvider,
        name: r'adminVendorDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$adminVendorDetailHash,
        dependencies: AdminVendorDetailFamily._dependencies,
        allTransitiveDependencies:
            AdminVendorDetailFamily._allTransitiveDependencies,
        vendorId: vendorId,
      );

  AdminVendorDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vendorId,
  }) : super.internal();

  final int vendorId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(AdminVendorDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminVendorDetailProvider._internal(
        (ref) => create(ref as AdminVendorDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vendorId: vendorId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _AdminVendorDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminVendorDetailProvider && other.vendorId == vendorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vendorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdminVendorDetailRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `vendorId` of this provider.
  int get vendorId;
}

class _AdminVendorDetailProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with AdminVendorDetailRef {
  _AdminVendorDetailProviderElement(super.provider);

  @override
  int get vendorId => (origin as AdminVendorDetailProvider).vendorId;
}

String _$adminReportsHash() => r'a2a2f60e05364ccb0a8d407e1a75926911fc2ac7';

/// See also [adminReports].
@ProviderFor(adminReports)
const adminReportsProvider = AdminReportsFamily();

/// See also [adminReports].
class AdminReportsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [adminReports].
  const AdminReportsFamily();

  /// See also [adminReports].
  AdminReportsProvider call({
    required String startDate,
    required String endDate,
  }) {
    return AdminReportsProvider(startDate: startDate, endDate: endDate);
  }

  @override
  AdminReportsProvider getProviderOverride(
    covariant AdminReportsProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adminReportsProvider';
}

/// See also [adminReports].
class AdminReportsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [adminReports].
  AdminReportsProvider({required String startDate, required String endDate})
    : this._internal(
        (ref) => adminReports(
          ref as AdminReportsRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: adminReportsProvider,
        name: r'adminReportsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$adminReportsHash,
        dependencies: AdminReportsFamily._dependencies,
        allTransitiveDependencies:
            AdminReportsFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  AdminReportsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String startDate;
  final String endDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(AdminReportsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminReportsProvider._internal(
        (ref) => create(ref as AdminReportsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _AdminReportsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminReportsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdminReportsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  String get startDate;

  /// The parameter `endDate` of this provider.
  String get endDate;
}

class _AdminReportsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with AdminReportsRef {
  _AdminReportsProviderElement(super.provider);

  @override
  String get startDate => (origin as AdminReportsProvider).startDate;
  @override
  String get endDate => (origin as AdminReportsProvider).endDate;
}

String _$adminCategoriesListHash() =>
    r'9bc484152d14d918bd61280737843f5109dc536b';

/// See also [adminCategoriesList].
@ProviderFor(adminCategoriesList)
final adminCategoriesListProvider =
    AutoDisposeFutureProvider<List<Category>>.internal(
      adminCategoriesList,
      name: r'adminCategoriesListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$adminCategoriesListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminCategoriesListRef = AutoDisposeFutureProviderRef<List<Category>>;
String _$adminCategoryActionNotifierHash() =>
    r'ced5fee8cbf541aeb4bd2d79eacba50332b685aa';

/// See also [AdminCategoryActionNotifier].
@ProviderFor(AdminCategoryActionNotifier)
final adminCategoryActionNotifierProvider =
    AutoDisposeNotifierProvider<AdminCategoryActionNotifier, void>.internal(
      AdminCategoryActionNotifier.new,
      name: r'adminCategoryActionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$adminCategoryActionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminCategoryActionNotifier = AutoDisposeNotifier<void>;
String _$adminVendorActionNotifierHash() =>
    r'51447c41d9a055b2c9065f43a948e65457fe8192';

/// See also [AdminVendorActionNotifier].
@ProviderFor(AdminVendorActionNotifier)
final adminVendorActionNotifierProvider =
    AutoDisposeNotifierProvider<AdminVendorActionNotifier, void>.internal(
      AdminVendorActionNotifier.new,
      name: r'adminVendorActionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$adminVendorActionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminVendorActionNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

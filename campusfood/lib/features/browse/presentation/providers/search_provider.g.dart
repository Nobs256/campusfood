// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchAutocompleteHash() =>
    r'c4aa78ea952af82d68c6ae5bd9c4cb94b8b9e489';

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

/// See also [searchAutocomplete].
@ProviderFor(searchAutocomplete)
const searchAutocompleteProvider = SearchAutocompleteFamily();

/// See also [searchAutocomplete].
class SearchAutocompleteFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [searchAutocomplete].
  const SearchAutocompleteFamily();

  /// See also [searchAutocomplete].
  SearchAutocompleteProvider call(String query) {
    return SearchAutocompleteProvider(query);
  }

  @override
  SearchAutocompleteProvider getProviderOverride(
    covariant SearchAutocompleteProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchAutocompleteProvider';
}

/// See also [searchAutocomplete].
class SearchAutocompleteProvider
    extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [searchAutocomplete].
  SearchAutocompleteProvider(String query)
    : this._internal(
        (ref) => searchAutocomplete(ref as SearchAutocompleteRef, query),
        from: searchAutocompleteProvider,
        name: r'searchAutocompleteProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchAutocompleteHash,
        dependencies: SearchAutocompleteFamily._dependencies,
        allTransitiveDependencies:
            SearchAutocompleteFamily._allTransitiveDependencies,
        query: query,
      );

  SearchAutocompleteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<dynamic>> Function(SearchAutocompleteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchAutocompleteProvider._internal(
        (ref) => create(ref as SearchAutocompleteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _SearchAutocompleteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchAutocompleteProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchAutocompleteRef on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchAutocompleteProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with SearchAutocompleteRef {
  _SearchAutocompleteProviderElement(super.provider);

  @override
  String get query => (origin as SearchAutocompleteProvider).query;
}

String _$searchResultsHash() => r'4a3e1252114fbddb6f5289bf793f63cdba24e0bc';

/// See also [searchResults].
@ProviderFor(searchResults)
const searchResultsProvider = SearchResultsFamily();

/// See also [searchResults].
class SearchResultsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [searchResults].
  const SearchResultsFamily();

  /// See also [searchResults].
  SearchResultsProvider call({int page = 1}) {
    return SearchResultsProvider(page: page);
  }

  @override
  SearchResultsProvider getProviderOverride(
    covariant SearchResultsProvider provider,
  ) {
    return call(page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchResultsProvider';
}

/// See also [searchResults].
class SearchResultsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [searchResults].
  SearchResultsProvider({int page = 1})
    : this._internal(
        (ref) => searchResults(ref as SearchResultsRef, page: page),
        from: searchResultsProvider,
        name: r'searchResultsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchResultsHash,
        dependencies: SearchResultsFamily._dependencies,
        allTransitiveDependencies:
            SearchResultsFamily._allTransitiveDependencies,
        page: page,
      );

  SearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(SearchResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultsProvider._internal(
        (ref) => create(ref as SearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _SearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _SearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with SearchResultsRef {
  _SearchResultsProviderElement(super.provider);

  @override
  int get page => (origin as SearchResultsProvider).page;
}

String _$searchFiltersNotifierHash() =>
    r'c336f48b965f0c6c85e3cf94eb5d299c28d64363';

/// See also [SearchFiltersNotifier].
@ProviderFor(SearchFiltersNotifier)
final searchFiltersNotifierProvider =
    AutoDisposeNotifierProvider<SearchFiltersNotifier, SearchFilters>.internal(
      SearchFiltersNotifier.new,
      name: r'searchFiltersNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchFiltersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchFiltersNotifier = AutoDisposeNotifier<SearchFilters>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

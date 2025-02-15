// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kids_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kidsServiceHash() => r'26bcc686a7fdc85625f0dbb1ba48ab3f9e313536';

/// See also [kidsService].
@ProviderFor(kidsService)
final kidsServiceProvider = AutoDisposeProvider<KidsService>.internal(
  kidsService,
  name: r'kidsServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$kidsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KidsServiceRef = AutoDisposeProviderRef<KidsService>;
String _$kidsHash() => r'9e042a31d045d996069c2cc14385acdae9016213';

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

/// See also [kids].
@ProviderFor(kids)
const kidsProvider = KidsFamily();

/// See also [kids].
class KidsFamily extends Family<AsyncValue<List<Kid>>> {
  /// See also [kids].
  const KidsFamily();

  /// See also [kids].
  KidsProvider call(
    String accountId,
  ) {
    return KidsProvider(
      accountId,
    );
  }

  @override
  KidsProvider getProviderOverride(
    covariant KidsProvider provider,
  ) {
    return call(
      provider.accountId,
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
  String? get name => r'kidsProvider';
}

/// See also [kids].
class KidsProvider extends AutoDisposeStreamProvider<List<Kid>> {
  /// See also [kids].
  KidsProvider(
    String accountId,
  ) : this._internal(
          (ref) => kids(
            ref as KidsRef,
            accountId,
          ),
          from: kidsProvider,
          name: r'kidsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$kidsHash,
          dependencies: KidsFamily._dependencies,
          allTransitiveDependencies: KidsFamily._allTransitiveDependencies,
          accountId: accountId,
        );

  KidsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final String accountId;

  @override
  Override overrideWith(
    Stream<List<Kid>> Function(KidsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: KidsProvider._internal(
        (ref) => create(ref as KidsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Kid>> createElement() {
    return _KidsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KidsProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KidsRef on AutoDisposeStreamProviderRef<List<Kid>> {
  /// The parameter `accountId` of this provider.
  String get accountId;
}

class _KidsProviderElement extends AutoDisposeStreamProviderElement<List<Kid>>
    with KidsRef {
  _KidsProviderElement(super.provider);

  @override
  String get accountId => (origin as KidsProvider).accountId;
}

String _$kidsControllerHash() => r'3ebf9e04ffdd88c21b4e2ced2d91f8b18986d96d';

/// See also [KidsController].
@ProviderFor(KidsController)
final kidsControllerProvider =
    AutoDisposeAsyncNotifierProvider<KidsController, void>.internal(
  KidsController.new,
  name: r'kidsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$kidsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KidsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

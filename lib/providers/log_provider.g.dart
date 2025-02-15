// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logServiceHash() => r'c93a1f6768e4903823bf827425ca23836a6d255b';

/// See also [logService].
@ProviderFor(logService)
final logServiceProvider = AutoDisposeProvider<LogService>.internal(
  logService,
  name: r'logServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogServiceRef = AutoDisposeProviderRef<LogService>;
String _$logsHash() => r'bf1e7538df9e5070f8aa01135fb732a2e8285610';

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

abstract class _$Logs extends BuildlessAutoDisposeStreamNotifier<List<Log>> {
  late final String accountId;

  Stream<List<Log>> build(
    String accountId,
  );
}

/// See also [Logs].
@ProviderFor(Logs)
const logsProvider = LogsFamily();

/// See also [Logs].
class LogsFamily extends Family<AsyncValue<List<Log>>> {
  /// See also [Logs].
  const LogsFamily();

  /// See also [Logs].
  LogsProvider call(
    String accountId,
  ) {
    return LogsProvider(
      accountId,
    );
  }

  @override
  LogsProvider getProviderOverride(
    covariant LogsProvider provider,
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
  String? get name => r'logsProvider';
}

/// See also [Logs].
class LogsProvider
    extends AutoDisposeStreamNotifierProviderImpl<Logs, List<Log>> {
  /// See also [Logs].
  LogsProvider(
    String accountId,
  ) : this._internal(
          () => Logs()..accountId = accountId,
          from: logsProvider,
          name: r'logsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$logsHash,
          dependencies: LogsFamily._dependencies,
          allTransitiveDependencies: LogsFamily._allTransitiveDependencies,
          accountId: accountId,
        );

  LogsProvider._internal(
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
  Stream<List<Log>> runNotifierBuild(
    covariant Logs notifier,
  ) {
    return notifier.build(
      accountId,
    );
  }

  @override
  Override overrideWith(Logs Function() create) {
    return ProviderOverride(
      origin: this,
      override: LogsProvider._internal(
        () => create()..accountId = accountId,
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
  AutoDisposeStreamNotifierProviderElement<Logs, List<Log>> createElement() {
    return _LogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LogsProvider && other.accountId == accountId;
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
mixin LogsRef on AutoDisposeStreamNotifierProviderRef<List<Log>> {
  /// The parameter `accountId` of this provider.
  String get accountId;
}

class _LogsProviderElement
    extends AutoDisposeStreamNotifierProviderElement<Logs, List<Log>>
    with LogsRef {
  _LogsProviderElement(super.provider);

  @override
  String get accountId => (origin as LogsProvider).accountId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

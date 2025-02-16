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
String _$todayLogsHash() => r'3464b2c531d878f4ae7d192da5e6d22f173c162b';

/// See also [todayLogs].
@ProviderFor(todayLogs)
final todayLogsProvider = AutoDisposeStreamProvider<List<Log>>.internal(
  todayLogs,
  name: r'todayLogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayLogsRef = AutoDisposeStreamProviderRef<List<Log>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

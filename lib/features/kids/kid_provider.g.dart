// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kidServiceHash() => r'61feda0993446fc4b8dfb4cc060739dbc07dd80f';

/// See also [kidService].
@ProviderFor(kidService)
final kidServiceProvider = AutoDisposeProvider<KidService>.internal(
  kidService,
  name: r'kidServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$kidServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KidServiceRef = AutoDisposeProviderRef<KidService>;
String _$kidsControllerHash() => r'92b07fdf2865c8a5a0e2199f407c617acc87db5c';

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

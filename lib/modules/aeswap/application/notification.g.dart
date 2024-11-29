// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'86e50a30e76d8f4d4d85b478777d496886e1dd92';

/// See also [_notificationService].
@ProviderFor(_notificationService)
final _notificationServiceProvider = AutoDisposeProvider<
    ns.TaskNotificationService<DexNotification, Failure>>.internal(
  _notificationService,
  name: r'_notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _NotificationServiceRef = AutoDisposeProviderRef<
    ns.TaskNotificationService<DexNotification, Failure>>;
String _$runningTasksHash() => r'bc545b56694b2bbdf049a349d825cdd4ab51f141';

/// See also [_runningTasks].
@ProviderFor(_runningTasks)
final _runningTasksProvider = AutoDisposeStreamProvider<
    Iterable<ns.Task<DexNotification, Failure>>>.internal(
  _runningTasks,
  name: r'_runningTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$runningTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _RunningTasksRef
    = AutoDisposeStreamProviderRef<Iterable<ns.Task<DexNotification, Failure>>>;
String _$doneTasksHash() => r'85456401cc2aee1dfd2ba086f227226691320cf6';

/// See also [_doneTasks].
@ProviderFor(_doneTasks)
final _doneTasksProvider =
    AutoDisposeStreamProvider<ns.Task<DexNotification, Failure>>.internal(
  _doneTasks,
  name: r'_doneTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$doneTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DoneTasksRef
    = AutoDisposeStreamProviderRef<ns.Task<DexNotification, Failure>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

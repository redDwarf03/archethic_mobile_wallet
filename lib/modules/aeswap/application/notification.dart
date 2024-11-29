/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/domain/models/dex_notification.dart';
import 'package:aewallet/modules/aeswap/util/notification_service/task_notification_service.dart'
    as ns;
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification.g.dart';

@riverpod
ns.TaskNotificationService<DexNotification, Failure> _notificationService(
  Ref ref,
) =>
    ns.TaskNotificationService();

@riverpod
Stream<Iterable<ns.Task<DexNotification, Failure>>> _runningTasks(
  Ref ref,
) async* {
  final notificationService = ref.watch(_notificationServiceProvider);
  await for (final tasks in notificationService.runningTasks()) {
    yield tasks;
  }
}

@riverpod
Stream<ns.Task<DexNotification, Failure>> _doneTasks(
  Ref ref,
) async* {
  final notificationService = ref.watch(_notificationServiceProvider);
  await for (final task in notificationService.doneTasks()) {
    yield task;
  }
}

abstract class NotificationProviders {
  static final notificationService = _notificationServiceProvider;
  static final runningTasks = _runningTasksProvider;
  static final doneTasks = _doneTasksProvider;
}

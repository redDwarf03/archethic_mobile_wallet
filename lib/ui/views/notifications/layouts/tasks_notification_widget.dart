import 'dart:async';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/application/notification.dart';
import 'package:aewallet/modules/aeswap/domain/enum/dex_action_type.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_notification.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/format_address_link_copy.dart'
    as addresslinkcopy;
import 'package:aewallet/modules/aeswap/util/notification_service/task_notification_service.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'components/running_tasks_notification.dart';
part 'components/task_notification_popup.dart';
part 'tasks_notification_widget.freezed.dart';

class TasksNotificationWidget extends ConsumerWidget {
  const TasksNotificationWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      NotificationProviders.doneTasks,
      (previous, next) async {
        final doneTask = next.valueOrNull;
        if (doneTask == null) return;

        TaskNotificationPopup.fromTask(doneTask, context, ref).show(context);
      },
    );
    return child;
  }
}

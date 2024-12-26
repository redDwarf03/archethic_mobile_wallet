part of '../tasks_notification_widget.dart';

@freezed
class TaskNotificationPopup with _$TaskNotificationPopup {
  const factory TaskNotificationPopup({
    Key? key,
    required Widget icon,
    Widget? title,
    required Widget description,
    required DexActionType actionType,
    Widget? action,
    VoidCallback? onActionPressed,
    required Color progressIndicatorColor,
  }) = _TaskNotificationPopup;

  factory TaskNotificationPopup._fromSwap(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        AppLocalizations.of(context)!.swapInProgressTxAddresses,
        task,
        context,
      );
    }
    final amount = task.data.amountSwapped as double;

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.swapDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.swapFinalAmountAmountSwapped,
          ),
          SelectableText(
            '${amount.formatNumber(precision: 8)} ${task.data.tokenSwapped.symbol}',
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromAddLiquidity(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.liquidityAddInProgresstxAddressesShort} ',
        task,
        context,
      );
    }
    final amount = task.data.amount as double;

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.liquidityAddDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.liquidityAddFinalAmount,
          ),
          SelectableText(
            '${amount.formatNumber(precision: 8)} ${task.data.amount! > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromRemoveLiquidity(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.liquidityRemoveInProgressTxAddressesShort} ',
        task,
        context,
      );
    }
    final amountToken1 = task.data.amountToken1 as double;
    final amountToken2 = task.data.amountToken2 as double;
    final amountLPToken = task.data.amountLPToken as double;

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.liquidityRemoveDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            '${AppLocalizations.of(context)!.liquidityRemoveFinalAmountTokenObtained} ${amountToken1.formatNumber(precision: 8)} ${task.data.token1!.symbol}',
            style: AppTextStyles.bodyMedium(context),
          ),
          SelectableText(
            '${AppLocalizations.of(context)!.liquidityRemoveFinalAmountTokenObtained} ${amountToken2.formatNumber(precision: 8)} ${task.data.token2!.symbol}',
            style: AppTextStyles.bodyMedium(context),
          ),
          SelectableText(
            '${AppLocalizations.of(context)!.liquidityRemoveFinalAmountTokenBurned} ${amountLPToken.formatNumber(precision: 8)} ${amountLPToken > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
            style: AppTextStyles.bodyMedium(context),
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromClaimFarmLock(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.farmLockClaimTxAddress} ',
        task,
        context,
      );
    }

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    final amount = task.data.amount as double;
    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.claimFarmLockDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.farmLockClaimFinalAmount,
          ),
          SelectableText(
            '${amount.formatNumber(precision: 8)} ${task.data.rewardToken.symbol}',
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromDepositFarmLock(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.farmLockDepositTxAddress} ',
        task,
        context,
      );
    }

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    final amount = task.data.amount as double;
    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.depositFarmLockDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.farmLockDepositFinalAmount,
          ),
          SelectableText(
            '${amount.formatNumber(precision: 8)} ${amount > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromLevelUpFarmLock(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.farmLockLevelUpTxAddress} ',
        task,
        context,
      );
    }

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    final amount = task.data.amount as double;
    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.levelUpFarmLockDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.farmLockLevelUpFinalAmount,
          ),
          SelectableText(
            '${amount.formatNumber(precision: 8)} ${amount > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
          ),
        ],
      ),
    );
  }

  factory TaskNotificationPopup._fromWithdrawFarmLock(
    Task task,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (task.failure != null) {
      return _getErrorNotification(
        '${AppLocalizations.of(context)!.farmLockWithdrawTxAddress} ',
        task,
        context,
      );
    }
    final amountReward = task.data.amountReward as double;
    final amountWithdraw = task.data.amountWithdraw as double;
    final isFarmClose = task.data.isFarmClose as bool;

    unawaited(() async {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions();
    }());

    return TaskNotificationPopup.success(
      key: Key(task.id),
      actionType: task.data.actionType,
      description: Wrap(
        direction: Axis.vertical,
        children: [
          SelectableText(AppLocalizations.of(context)!.withdrawFarmLockDone),
          if (task.dateTask != null)
            SelectableText(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).add_Hms().format(
                    task.dateTask!.toLocal(),
                  ),
            ),
          SelectableText(
            AddressFormatters(task.data.txAddress.toUpperCase())
                .getShortString(),
          ),
          SelectableText(
            AppLocalizations.of(context)!.farmLockWithdrawFinalAmount,
          ),
          SelectableText(
            '${amountWithdraw.formatNumber(precision: 8)} ${amountWithdraw > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
          ),
          if ((isFarmClose == true && amountReward > 0) || isFarmClose == false)
            SelectableText(
              AppLocalizations.of(context)!.farmLockWithdrawFinalAmountReward,
            ),
          if ((isFarmClose == true && amountReward > 0) || isFarmClose == false)
            SelectableText(
              '${amountReward.formatNumber(precision: 8)} ${task.data.rewardToken!.symbol}',
            ),
        ],
      ),
    );
  }

  const TaskNotificationPopup._();

  factory TaskNotificationPopup.success({
    Key? key,
    Widget? title,
    required Widget description,
    required DexActionType actionType,
    Widget? action,
    VoidCallback? onActionPressed,
  }) =>
      TaskNotificationPopup(
        key: key,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        title: title,
        description: description,
        actionType: actionType,
        action: action,
        onActionPressed: onActionPressed,
        progressIndicatorColor: Colors.green,
      );

  factory TaskNotificationPopup.failure({
    Key? key,
    Widget? title,
    required Widget description,
    required DexActionType actionType,
    Widget? action,
    VoidCallback? onActionPressed,
  }) =>
      TaskNotificationPopup(
        key: key,
        icon: const Icon(
          Icons.error_outline_outlined,
          color: Colors.red,
        ),
        title: title,
        description: description,
        actionType: actionType,
        action: action,
        onActionPressed: onActionPressed,
        progressIndicatorColor: Colors.red,
      );

  factory TaskNotificationPopup.fromTask(
    Task<DexNotification, aedappfm.Failure> task,
    BuildContext context,
    WidgetRef ref,
  ) =>
      switch (task.data.actionType) {
        DexActionType.swap =>
          TaskNotificationPopup._fromSwap(task, context, ref),
        DexActionType.addLiquidity =>
          TaskNotificationPopup._fromAddLiquidity(task, context, ref),
        DexActionType.removeLiquidity =>
          TaskNotificationPopup._fromRemoveLiquidity(task, context, ref),
        DexActionType.claimFarmLock =>
          TaskNotificationPopup._fromClaimFarmLock(task, context, ref),
        DexActionType.depositFarmLock =>
          TaskNotificationPopup._fromDepositFarmLock(task, context, ref),
        DexActionType.levelUpFarmLock =>
          TaskNotificationPopup._fromLevelUpFarmLock(task, context, ref),
        DexActionType.withdrawFarmLock =>
          TaskNotificationPopup._fromWithdrawFarmLock(task, context, ref),
        DexActionType.addPool =>
          TaskNotificationPopup._fromRemoveLiquidity(task, context, ref),
      };

  void show(BuildContext context) {
    double? width;
    if (aedappfm.Responsive.isMobile(context)) {
      width = MediaQuery.of(context).size.width * 0.90;
    } else {
      if (aedappfm.Responsive.isTablet(context)) {
        width = MediaQuery.of(context).size.width / 2;
      } else {
        width = MediaQuery.of(context).size.width / 3;
      }
    }

    double? height;
    switch (actionType) {
      case DexActionType.swap:
        height = 130;
        break;
      case DexActionType.addLiquidity:
        height = 130;
        break;
      case DexActionType.removeLiquidity:
        height = 160;
        break;
      case DexActionType.claimFarmLock:
        height = 130;
        break;
      case DexActionType.depositFarmLock:
        height = 130;
        break;
      case DexActionType.levelUpFarmLock:
        height = 130;
        break;
      case DexActionType.withdrawFarmLock:
        height = 160;
        break;
      case DexActionType.addPool:
        height = 130;
        break;
    }

    ElegantNotification(
      key: key,
      icon: icon,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      background: Theme.of(context).colorScheme.surface,
      description: description,
      title: title,
      toastDuration: const Duration(seconds: 20),
      progressIndicatorColor: progressIndicatorColor,
      action: action,
      onNotificationPressed: onActionPressed,
      width: width,
      height: height,
    ).show(context);
  }
}

TaskNotificationPopup _getErrorNotification(
  String header,
  Task task,
  BuildContext context,
) {
  return TaskNotificationPopup.failure(
    key: Key(task.id),
    actionType: task.data.actionType,
    description: Wrap(
      children: [
        if (task.dateTask != null)
          SelectableText(
            DateFormat.yMd(
              Localizations.localeOf(context).languageCode,
            ).add_Hms().format(
                  task.dateTask!.toLocal(),
                ),
          ),
        addresslinkcopy.FormatAddressLinkCopy(
          address: task.data.txAddress.toUpperCase(),
          header: header,
          typeAddress: addresslinkcopy.TypeAddressLinkCopy.transaction,
          reduceAddress: true,
        ),
        SelectableText(
          'Error: ${FailureMessage(context: context, failure: task.failure).getMessage()}',
        ),
      ],
    ),
  );
}

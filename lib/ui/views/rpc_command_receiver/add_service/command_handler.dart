import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/address_service.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/domain/rpc/failure.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:aewallet/infrastructure/repositories/transaction/transaction_keychain_builder.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/window_util_desktop.dart'
    if (dart.library.js) 'package:aewallet/ui/util/window_util_web.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/add_service/layouts/add_service_confirmation_form.dart';
import 'package:aewallet/util/notifications_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServiceHandler extends CommandHandler {
  AddServiceHandler({
    required BuildContext context,
    required WidgetRef ref,
  }) : super(
          canHandle: (command) => command is RPCCommand<awc.AddServiceRequest>,
          handle: (command) async {
            _showNotification(
              context: context,
              ref: ref,
              command: command,
            );

            if (command.data.name.isEmpty) {
              return const Result.failure(
                awc.Failure.invalidParams,
              );
            }
            final networkSettings = ref.watch(
              SettingsProviders.settings.select((settings) => settings.network),
            );
            final appService = ref.read(appServiceProvider);
            final apiService = ref.watch(apiServiceProvider);
            final addressService = ref.watch(addressServiceProvider);

            final archethicTransactionRepository =
                ArchethicTransactionRepository(
              phoenixHttpEndpoint: networkSettings.getPhoenixHttpLink(),
              websocketEndpoint: networkSettings.getWebsocketUri(),
              apiService: apiService,
              appService: appService,
              addressService: addressService,
            );
            final originPrivateKey =
                archethicTransactionRepository.apiService.getOriginKey();
            final session = ref.watch(sessionNotifierProvider).loggedIn!;
            var keychain = await archethicTransactionRepository.apiService
                .getKeychain(session.wallet.seed);

            final nameEncoded = Uri.encodeFull(
              command.data.name,
            );
            final kDerivationPathWithoutIndex = "m/650'/$nameEncoded/";
            const index = 0;
            final kDerivationPath = '$kDerivationPathWithoutIndex$index';

            if (keychain.services.containsKey(nameEncoded)) {
              return const Result.failure(
                awc.Failure.serviceAlreadyExists,
              );
            }
            keychain = keychain.copyWithService(nameEncoded, kDerivationPath);

            final keychainTransaction = await KeychainTransactionBuilder.build(
              keychain: keychain,
              originPrivateKey: originPrivateKey,
              apiService: apiService,
            );

            final newCommand = RPCCommand<awc.SendTransactionRequest>(
              origin: command.origin,
              data: awc.SendTransactionRequest(
                data: keychainTransaction.data!,
                version: keychainTransaction.version,
                type: keychainTransaction.type!,
              ),
            );

            await WindowUtil().showFirst();

            final result = await showDialog<
                Result<TransactionConfirmation, TransactionError>>(
              useSafeArea: false,
              useRootNavigator: false,
              context: context,
              builder: (context) => Dialog.fullscreen(
                child: DecoratedBox(
                  decoration: ArchethicTheme.getDecorationSheet(),
                  child: AddServiceConfirmationForm(
                    nameEncoded,
                    newCommand,
                  ),
                ),
              ),
            );

            return result!.map(
                  failure: (failure) => Result.failure(
                    failure.toRpcFailure(),
                  ),
                  success: (success) {
                    Future<void>.sync(() async {
                      final connectivityStatusProvider =
                          ref.read(connectivityStatusProviders);
                      if (connectivityStatusProvider ==
                          ConnectivityStatus.isConnected) {
                        await ref
                            .read(sessionNotifierProvider.notifier)
                            .refresh();
                        await (await ref
                                .read(accountsNotifierProvider.notifier)
                                .selectedAccountNotifier)
                            ?.refreshRecentTransactions();
                      }
                    });

                    return Result.success(
                      success,
                    );
                  },
                ) ??
                const Result.failure(
                  awc.Failure.userRejected,
                );
          },
        );

  static void _showNotification({
    required BuildContext context,
    required WidgetRef ref,
    required RPCCommand<awc.AddServiceRequest> command,
  }) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    final message =
        AppLocalizations.of(context)!.addServiceCommandReceivedNotification;

    NotificationsUtil.showNotification(
      title: 'Archethic',
      body: message
          .replaceAll(
            '%1',
            command.origin.name,
          )
          .replaceAll('%2', accountSelected!.nameDisplayed),
    );
  }
}

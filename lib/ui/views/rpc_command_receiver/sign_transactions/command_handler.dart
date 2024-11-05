import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/window_util_desktop.dart'
    if (dart.library.js) 'package:aewallet/ui/util/window_util_web.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sign_transactions/layouts/sign_transactions_confirmation_form.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/util/processing_indicator.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const slippage = 1.01;

class SignTransactionsCommandHandler extends CommandHandler {
  SignTransactionsCommandHandler({
    required BuildContext context,
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.SignTransactionRequest>,
          handle: (command) async {
            final localizations = AppLocalizations.of(context)!;
            command as RPCCommand<awc.SignTransactionRequest>;

            CommandHandlerLoadingSnackbar(
              message: localizations.rpcSignTransactionsProcessing,
            ).show(context);

            final signedTransactionList = <awc.SignTransactionsResultDetail>[];
            final serviceName = command.data.serviceName;
            final pathSuffix = command.data.pathSuffix;
            final description = command.data.description;

            final seed =
                ref.read(sessionNotifierProvider).loggedIn!.wallet.seed;

            final apiService = ref.read(apiServiceProvider);
            final keychain = await apiService.getKeychain(seed);

            var addressGenesis = '';
            try {
              addressGenesis = archethic.uint8ListToHex(
                keychain.deriveAddress(
                  serviceName,
                  pathSuffix: pathSuffix,
                ),
              );
            } catch (e) {
              return const Result.failure(
                awc.Failure.serviceNotFound,
              );
            }

            final originPrivateKey = apiService.getOriginKey();

            final indexMap = await apiService.getTransactionIndex(
              [addressGenesis],
            );

            var index = indexMap[addressGenesis] ?? 0;
            final addresses = <String?>[];
            var globalFees = 0.0;
            for (final rpcSignTransactionCommandData
                in command.data.transactions) {
              final transaction = archethic.Transaction(
                type: rpcSignTransactionCommandData.type,
                data: rpcSignTransactionCommandData.data,
                version: rpcSignTransactionCommandData.version,
              );

              final signedTransaction = keychain
                  .buildTransaction(
                    transaction,
                    serviceName,
                    index,
                    pathSuffix: pathSuffix,
                  )
                  .transaction
                  .originSign(originPrivateKey);

              final transactionFee =
                  await apiService.getTransactionFee(signedTransaction);
              final fees = archethic.fromBigInt(transactionFee.fee) * slippage;
              globalFees = globalFees + fees;

              addresses.add(signedTransaction.address?.address);
            }

            CommandHandlerLoadingSnackbar.hide(context);

            await WindowUtil().showFirst();

            final confirmation = await showDialog<bool>(
              useSafeArea: false,
              useRootNavigator: false,
              context: context,
              builder: (context) => Dialog.fullscreen(
                child: DecoratedBox(
                  decoration: ArchethicTheme.getDecorationSheet(),
                  child: SignTransactionsConfirmationForm(
                    addresses,
                    command,
                    globalFees,
                    description,
                  ),
                ),
              ),
            );

            if (confirmation == null || confirmation == false) {
              return const Result.failure(
                awc.Failure.userRejected,
              );
            }

            CommandHandlerLoadingSnackbar(
              message: localizations.rpcSignTransactionsProcessing,
            ).show(context);

            for (final rpcSignTransactionCommandData
                in command.data.transactions) {
              final transaction = archethic.Transaction(
                type: rpcSignTransactionCommandData.type,
                data: rpcSignTransactionCommandData.data,
                version: rpcSignTransactionCommandData.version,
              );

              final signedTransaction = keychain
                  .buildTransaction(
                    transaction,
                    serviceName,
                    index,
                    pathSuffix: pathSuffix,
                  )
                  .transaction
                  .originSign(originPrivateKey);

              final rpcSignTransactionResultDetailData =
                  awc.SignTransactionsResultDetail(
                address: signedTransaction.address!.address ?? '',
                originSignature: signedTransaction.originSignature ?? '',
                previousPublicKey: signedTransaction.previousPublicKey ?? '',
                previousSignature: signedTransaction.previousSignature ?? '',
              );

              signedTransactionList.add(rpcSignTransactionResultDetailData);
              index++;
            }

            CommandHandlerLoadingSnackbar.hide(context);

            return Result.success(
              awc.SignTransactionsResult(signedTxs: signedTransactionList),
            );
          },
        );
}

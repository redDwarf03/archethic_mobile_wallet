import 'dart:convert';

import 'package:aewallet/infrastructure/rpc/deeplink_server.dart';
import 'package:aewallet/main.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/router/dialog_page.dart';
import 'package:aewallet/ui/menu/settings/settings_sheet.dart';
import 'package:aewallet/ui/views/add_account/layouts/add_account_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/components/farm_lock_claim_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/farm_lock_claim_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/farm_lock_deposit_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/farm_lock_level_up_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/farm_lock_withdraw_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/components/liquidity_add_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/liquidity_add_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/layouts/components/liquidity_remove_result_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/layouts/liquidity_remove_sheet.dart';
import 'package:aewallet/ui/views/aeswap_swap/layouts/components/swap_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_swap/layouts/components/swap_result_sheet.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/authenticate/auto_lock_guard.dart';
import 'package:aewallet/ui/views/authenticate/lock_icon_updater.dart';
import 'package:aewallet/ui/views/authenticate/logging_out.dart';
import 'package:aewallet/ui/views/authenticate/privacy_mask.dart';
import 'package:aewallet/ui/views/authenticate/set_biometrics_screen.dart';
import 'package:aewallet/ui/views/authenticate/set_password_screen.dart';
import 'package:aewallet/ui/views/authenticate/set_yubikey_screen.dart';
import 'package:aewallet/ui/views/dapps_board/layouts/dapps_board_sheet.dart';
import 'package:aewallet/ui/views/dapps_board/layouts/dapps_board_webview.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_backup_confirm.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_backup_seed.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_configure_security.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_import_seed.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_new_wallet_disclaimer.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_new_wallet_get_first_infos.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_welcome.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/views/nft/layouts/components/nft_detail.dart';
import 'package:aewallet/ui/views/notifications/layouts/tasks_notification_widget.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/rpc_command_receiver.dart';
import 'package:aewallet/ui/views/settings/backupseed_sheet.dart';
import 'package:aewallet/ui/views/sheets/buy_sheet.dart';
import 'package:aewallet/ui/views/sheets/connectivity_warning.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/token_detail_sheet.dart';
import 'package:aewallet/ui/views/tokens_fungibles/layouts/add_token_sheet.dart';
import 'package:aewallet/ui/views/transactions/transaction_infos_sheet.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/views/transfer/layouts/transfer_sheet.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/dialogs/environment_dialog.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.aeswap.dart';
part 'router.authenticated.dart';
part 'router.authentication.dart';
part 'router.introduction.dart';

class RoutesPath {
  RoutesPath(
    this.rootNavigatorKey,
  );

  final GlobalKey<NavigatorState> rootNavigatorKey;

  GoRouter createRouter() {
    final deeplinkRpcReceiver = sl.get<ArchethicDeeplinkRPCServer>();

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      extraCodec: const JsonCodec(),
      routes: [
        ShellRoute(
          builder: (context, state, child) => GuardInputListener(
            child: AuthFactory(
              child: TasksNotificationWidget(
                child: LoadingOverlay(
                  child: child,
                ),
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: Splash.routerPage,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const Splash(),
              ),
            ),
            ..._authenticationRoutes,
            ..._introductionRoutes,
            AutoLockGuardRoute(
              routes: [
                RPCCommandReceiverRoute(
                  routes: [
                    ..._authenticatedRoutes,
                    ..._aeSwapRoutes,
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) async {
        if (deeplinkRpcReceiver.canHandle(state.matchedLocation)) {
          await deeplinkRpcReceiver.handle(state.matchedLocation);
        }
        if (state.uri.scheme == 'aewallet' &&
            state.uri.path + state.uri.host == DAppsBoardWebview.routerPage) {
          final query = utf8.decode(
            base64Url.decode(
              state.uri.query,
            ),
          );
          return '${DAppsBoardWebview.routerPage}?deeplink&$query';
        }
        return null;
      },
      errorBuilder: (context, state) => SheetSkeleton(
        appBar: AppBar(),
        menu: true,
        sheetContent: Text('Something went wrong: ${state.error}'),
      ),
    );
  }
}

class AutoLockGuardRoute extends ShellRoute {
  AutoLockGuardRoute({required super.routes})
      : super(
          pageBuilder: (context, state, child) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: PrivacyMaskGuard(
                child: AutoLockGuard(
                  child: LockIconUpdater(child: child),
                ),
              ),
            );
          },
        );
}

class RPCCommandReceiverRoute extends ShellRoute {
  RPCCommandReceiverRoute({required super.routes})
      : super(
          pageBuilder: (context, state, child) => NoTransitionPage<void>(
            key: state.pageKey,
            child: RPCCommandReceiver(child: child),
          ),
        );
}

extension RouterParamExtension on Object? {
  String? encodeParam() {
    if (this == null) return null;
    final paramJson = jsonEncode(this);
    return Uri.encodeComponent(paramJson);
  }
}

extension UriExtensions on Map<String, String> {
  T? getDecodedParameter<T>(String key, T Function(String) fromJson) {
    final encoded = this[key];
    if (encoded != null) {
      final json = Uri.decodeComponent(encoded);
      return fromJson(json);
    }
    return null;
  }
}

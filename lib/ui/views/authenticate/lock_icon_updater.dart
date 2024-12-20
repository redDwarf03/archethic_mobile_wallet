import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/update_extension_icon_non_web.dart'
    if (dart.library.js) 'package:aewallet/modules/aeswap/ui/views/util/update_extension_icon_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Updates icon to match lock state
class LockIconUpdater extends ConsumerWidget {
  const LockIconUpdater({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .watch(
          AuthenticationProviders.authenticationGuard.selectAsync(
            (state) => state.isLocked,
          ),
        )
        .then(updateExtensionIcon);
    return child;
  }
}

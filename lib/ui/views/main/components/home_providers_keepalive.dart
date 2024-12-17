import 'package:aewallet/ui/views/main/bloc/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Eagerly initializes providers (https://riverpod.dev/docs/essentials/eager_initialization).
///
/// Add Watch here for any provider you want to init when app is displayed.
/// Those providers will be kept alive during application lifetime.
class HomeProvidersKeepalive extends ConsumerStatefulWidget {
  const HomeProvidersKeepalive({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoggedInProvidersState();
}

class _LoggedInProvidersState extends ConsumerState<HomeProvidersKeepalive>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleStateAsync(state);
  }

  Future<void> didChangeAppLifecycleStateAsync(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        await ref.read(homePageProvider.notifier).stopSubscriptions();
        break;
      case AppLifecycleState.resumed:
        await ref.read(homePageProvider.notifier).startSubscriptions();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);
    return widget.child;
  }
}

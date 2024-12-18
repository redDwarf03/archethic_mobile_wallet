import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceAbilities {
  static final hasQRCodeProvider = Provider<bool>(
    (ref) {
      if (UniversalPlatform.isMobile) {
        return true;
      }
      return false;
    },
  );
}

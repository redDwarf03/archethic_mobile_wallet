import 'package:aewallet/util/universal_platform.dart';

/// Simply activate/deactivate features.
class FeatureFlags {
  static const forceLogout = false;
  static const tokenFungibleCreationFeature = false;
  static const dappBoard = true;
  static final privacyMask = !UniversalPlatform
      .isWeb; // Disables PrivacyMask on web while https://github.com/flutter/engine/pull/44720 is not in Flutter stable release
}

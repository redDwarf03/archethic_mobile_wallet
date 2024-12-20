// ignore_for_file: avoid_web_libraries_in_flutter
import 'package:aewallet/infrastructure/rpc/browser_extension_aws.js.dart';

void updateExtensionIcon(bool isLocked) {
  sendMessage(
    null,
    {
      'type': 'updateIcon',
      'isLocked': isLocked,
    }.toJS,
    null,
    null,
  );
}

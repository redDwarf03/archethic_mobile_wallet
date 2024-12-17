// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void updateExtensionIcon(bool isLocked) {
  js.context.callMethod('chrome.runtime.sendMessage', [
    {
      'type': 'updateIcon',
      'isLocked': isLocked,
    }
  ]);
}

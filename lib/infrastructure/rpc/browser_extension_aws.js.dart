@JS('chrome')
library aws; // library name can be whatever you want

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js;

extension MapToJSExt on Map<dynamic, dynamic> {
  /// Converts a Map to JS object
  Object get toJS {
    final object = js.newObject();
    forEach((k, v) {
      final key = k;
      final value = v;
      js.setProperty(object, key, value);
    });
    return object;
  }
}

@JS('runtime.connect')
external BrowserExtensionPort connect();

@JS('runtime.sendMessage')
external Future<void> sendMessage(
  String? extensionId,
  dynamic message,
  dynamic options,
  Function(dynamic response)? callback,
);

@JS('runtime.onMessage')
external BrowserExtensionEvent<
    void Function(
      dynamic message,
      BrowserExtensionMessageSender sender,
      Function(dynamic) sendResponse,
    )> get onMessage;

@JS('runtime.onMessageExternal')
external BrowserExtensionEvent<
    void Function(
      dynamic message,
      BrowserExtensionMessageSender sender,
      Function(dynamic) sendResponse,
    )> get onMessageExternal;

@JS('runtime.onConnectExternal')
external BrowserExtensionEvent<void Function(BrowserExtensionPort port)>
    get onConnectExternal;

@JS('extension')
external dynamic get browserExtension;

@JS('windows.update')
external void updateWindow(int windowId, dynamic updateInfo);

@JS('windows.WINDOW_ID_CURRENT')
external int get windowIdCurrent;

bool get isWebBrowserExtension => browserExtension != null;

/// https://developer.chrome.com/docs/extensions/reference/api/runtime?type-Port#type-Port
@JS('runtime.Port')
class BrowserExtensionPort {
  @JS('onMessage')
  external BrowserExtensionEvent<
      void Function(dynamic message, BrowserExtensionPort port)> get onMessage;

  @JS('onDisconnect')
  external BrowserExtensionEvent<void Function(BrowserExtensionPort port)>
      get onDisconnect;

  @JS('disconnect')
  external void disconnect();

  @JS('postMessage')
  external void postMessage(dynamic message);
}

/// https://developer.chrome.com/docs/extensions/reference/api/events?type-Event#type-Event
@JS()
class BrowserExtensionEvent<H extends Function> {
  @JS('addListener')
  external void addListener(
    H callback,
  );

  @JS('removeListener')
  external void removeListener(
    H callback,
  );
}

/// https://developer.chrome.com/docs/extensions/reference/api/runtime?type-MessageSender#type-MessageSender
@JS()
class BrowserExtensionMessageSender {
  @JS('origin')
  external String? get origin;

  @JS('tab')
  external BrowserExtensionTab? get tab;
}

/// https://developer.chrome.com/docs/extensions/reference/api/tabs#type-Tab
@JS()
class BrowserExtensionTab {
  @JS('id')
  external int? get id;
}

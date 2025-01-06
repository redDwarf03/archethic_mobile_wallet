import 'dart:async';
import 'dart:convert';

import 'package:aewallet/infrastructure/rpc/awc_json_rpc_server.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/util/device_info.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:url_launcher/url_launcher.dart';

extension UriRedirectionResolverExt on Uri {
  Future<Uri> resolveRedirection() async {
    final req = http.Request('Get', this)..followRedirects = false;
    final baseClient = http.Client();
    final response = await baseClient.send(req);
    if (!response.isRedirect) return this;

    final location = response.headers['location'];
    if (location == null) return this;
    return Uri.parse(location);
  }
}

enum EVMWallet {
  metamask(
    name: 'Metamask',
    scheme: 'metamask',
  ),
  trust(
    name: 'Trust',
    scheme: 'trust',
  ),
  okex(
    name: 'Okex',
    scheme: 'okex',
  ),
  bnc(
    name: 'BNC',
    scheme: 'bnc',
  ),
  uniswap(
    name: 'Uniswap',
    scheme: 'uniswap',
  ),
  safePalWallet(
    name: 'SafepalWallet',
    scheme: 'safepalwallet',
  ),
  rainbow(
    name: 'Rainbow',
    scheme: 'rainbow',
  ),
  exodus(
    name: 'Exodus',
    scheme: 'exodus',
  ),
  safe(
    name: 'Safe',
    scheme: 'safe',
  );

  const EVMWallet({
    required this.name,
    required this.scheme,
  });

  static EVMWallet? fromScheme(String scheme) =>
      EVMWallet.values.firstWhereOrNull(
        (evmWallet) => evmWallet.scheme == scheme,
      );

  final String name;
  final String scheme;
}

/// Keeps track of all alive WebviewControllers
class AWCWebviewControllers {
  const AWCWebviewControllers._();

  static final _logger = Logger('AWCWebviewControllers');
  static final _controllers = <Uri, InAppWebViewController>{};

  static InAppWebViewController? find(Uri uri) => _controllers[uri];

  static void register(Uri uri, InAppWebViewController controller) {
    final alreadyRegisteredController = find(uri);
    if (alreadyRegisteredController != null &&
        controller == alreadyRegisteredController) {
      return;
    }
    dispose(uri);
    _controllers[uri] = controller;
    _logger.info('Registered controller for $uri');
  }

  static void dispose(Uri uri) {
    final controller = find(uri);
    if (controller == null) return;
    controller.dispose();
    _controllers.remove(uri);
    _logger.info('Disposed controller for $uri');
  }
}

class AWCWebview extends StatefulWidget {
  const AWCWebview({super.key, required this.uri});

  static final _logger = Logger('AWCWebview');

  static bool get isAvailable {
    if (!UniversalPlatform.isMobile) return false;

    final deviceInfo = DeviceInfo.state;

    return deviceInfo.maybeMap(
      orElse: () => true,
      android: (androidInfo) => androidInfo.version >= 29,
    );
  }

  final Uri uri;

  static Future<bool> get isAWCSupported async {
    return defaultTargetPlatform != TargetPlatform.android ||
        await WebViewFeature.isFeatureSupported(
          WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL,
        );
  }

  @override
  State<AWCWebview> createState() => _AWCWebviewState();
}

class _AWCWebviewState extends State<AWCWebview> with WidgetsBindingObserver {
  AWCJsonRPCServer? _peerServer;
  WebviewMessagePortStreamChannel? _channel;
  bool _loaded = false;
  late final FocusNode _focusNode;

  /// Stores uri after redirections resolution
  /// This is important to detect navigations
  /// to third party websites from dapp.
  late Uri _resolvedUri;

  InAppWebViewController? get _controller =>
      AWCWebviewControllers.find(widget.uri);

  @override
  void initState() {
    _resolvedUri = widget.uri;
    if (kDebugMode &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    _focusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _peerServer?.close();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    AWCWebviewControllers.dispose(_resolvedUri);
    AWCWebview._logger.info('AWC webview disposed.');

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        unawaited(_restoreMessageChannelRPC(_controller!));
        _maintainWebviewFocus(_controller!);
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _requestFocus() {
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
    _controller?.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Opacity(
            opacity: _loaded ? 1 : 0,
            child: Focus(
              autofocus: true,
              focusNode: _focusNode,
              child: InAppWebView(
                initialSettings: InAppWebViewSettings(
                  isInspectable: kDebugMode,
                  transparentBackground: true,
                ),
                onLoadStop: (controller, _) async {
                  AWCWebviewControllers.register(_resolvedUri, controller);
                  await _initMessageChannelRPC(controller);
                  await _maintainWebviewFocus(controller);
                  setState(() {
                    _loaded = true;
                  });
                },
                onWebViewCreated: (controller) async {
                  final redirectedUri = await widget.uri.resolveRedirection();
                  setState(
                    () {
                      _resolvedUri = redirectedUri;
                    },
                  );
                  await controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri.uri(redirectedUri)),
                  );
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url;
                  if (uri == null) {
                    return NavigationActionPolicy.ALLOW;
                  }

                  final matchingEvmWallet = EVMWallet.fromScheme(
                    uri.scheme,
                  );
                  if (matchingEvmWallet != null) {
                    await _openEvmWallet(
                      uri,
                      matchingEvmWallet,
                      AppLocalizations.of(context)!,
                    );
                    return NavigationActionPolicy.CANCEL;
                  }

                  // Allows dapps to open third party websites
                  if (navigationAction.isForMainFrame &&
                      uri.origin != _resolvedUri.origin) {
                    await _openThirdPartyWebsite(uri);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedHttpError: (controller, request, errorResponse) {
                  AWCWebview._logger.warning(
                    'HTTP error: ${errorResponse.statusCode} ${request.url}',
                  );
                },
              ),
            ),
          ),
          if (!_loaded) const Center(child: LoadingListHeader()),
        ],
      );

  Future<bool> _openThirdPartyWebsite(WebUri uri) async {
    return launchUrl(uri.uriValue, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEvmWallet(
    WebUri uri,
    EVMWallet evmWallet,
    AppLocalizations localizations,
  ) async {
    if (!await canLaunchUrl(uri.uriValue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.openEvmWalletNotInstalledContent(evmWallet.name),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.openEvmWalletOpeningContent(evmWallet.name),
        ),
        duration: const Duration(days: 1),
      ),
    );

    unawaited(
      launchUrl(uri, mode: LaunchMode.externalApplication),
    );
  }

  Future<void> _restoreMessageChannelRPC(
    InAppWebViewController controller,
  ) async {
    final isMessageChannelReady = await controller.evaluateJavascript(
      source: "typeof awc !== 'undefined'",
    );
    if (!isMessageChannelReady || _channel == null) {
      AWCWebview._logger.info('AWC never initialized. Abort restoration.');
      return;
    }

    if (!await AWCWebview.isAWCSupported) {
      AWCWebview._logger.info('AWC unsupported.');
      return;
    }

    AWCWebview._logger.info('Restoring AWC.');
    final port1 = await _restoreMessageChannelPorts(controller);

    _channel?.port = port1;
  }

  Future<void> _maintainWebviewFocus(
    InAppWebViewController controller,
  ) async {
    controller.addJavaScriptHandler(
      handlerName: 'focusLost',
      callback: (event) {
        _requestFocus();
      },
    );

    await controller.evaluateJavascript(
      source:
          "onblur = (event) => { window.flutter_inappwebview.callHandler('focusLost'); }",
    );
  }

  Future<WebMessagePort> _restoreMessageChannelPorts(
    InAppWebViewController controller,
  ) async {
    final webMessageChannel = await controller.createWebMessageChannel();
    final port1 = webMessageChannel!.port1;
    final port2 = webMessageChannel.port2;

    // transfer port2 to the webpage to initialize the communication
    await controller.postWebMessage(
      message: WebMessage(data: 'restorePort', ports: [port2]),
      targetOrigin: WebUri('*'),
    );
    return port1;
  }

  Future<void> _initMessageChannelRPC(
    InAppWebViewController controller,
  ) async {
    final isMessageChannelReady = await controller.evaluateJavascript(
      source: "typeof awc !== 'undefined'",
    );
    if (isMessageChannelReady) {
      AWCWebview._logger.info('AWC already initialized.');
      return;
    }

    if (!await AWCWebview.isAWCSupported) {
      AWCWebview._logger.info('AWC unsupported.');
      return;
    }

    AWCWebview._logger.info('Initializing AWC.');
    final port1 = await _initMessageChannelPorts(controller);

    final channel = WebviewMessagePortStreamChannel(port: port1);
    final peerServer = AWCJsonRPCServer(channel.cast<String>());
    _channel = channel;
    _peerServer = peerServer;
    unawaited(peerServer.listen());
  }

  Future<WebMessagePort> _initMessageChannelPorts(
    InAppWebViewController controller,
  ) async {
    await controller.evaluateJavascript(
      source: """
class RestorableMessagePort {
    #port;
    #onmessage;
    #onmessageerror;
    #onclose;
    set port(port) {
        var previousPort = this.#port;
        this.#port = port;
        this.#port.onmessage = this.#onmessage;
        this.#port.onmessageerror = this.#onmessageerror;
        this.#port.onclose = this.#onclose;
        if (previousPort) {
            previousPort.close();
        }
    }

    close() {
        this.#port.close();
    }

    start() {
        this.#port.start();
    }

    postMessage(message, transfer) {
        this.#port.postMessage(message, transfer);
    }

    get onmessage() {
        return this.#onmessage;
    }
    set onmessage(callback) {
        this.#onmessage = callback;
        this.#port.onmessage = callback;
    }

    get onmessageerror() {
        return this.#onmessageerror;
    }
    set onmessageerror(callback) {
        this.#onmessageerror = callback;
        this.#port.onmessageerror = callback;
    }

    get onclose() {
        return this.#onclose;
    }
    set onclose(callback) {
        this.#onclose = callback;
        this.#port.onclose = callback;
    }
}
console.info("[AWC] Init webmessage");
var onAWCReady = (awc) => {};
var awcAvailable = true;
var awc;
window.addEventListener('message', function(event) {
    if (event.data == 'capturePort') {
        if (event.ports[0] != null) {
            awc = new RestorableMessagePort();
            awc.port = event.ports[0];
            console.info("[AWC] Init webmessage Done");
            if (onAWCReady !== undefined) {
              onAWCReady(awc);
            }
        }
        return;
    }
    if (event.data == 'restorePort') {
        if (event.ports[0] != null) {
          if (!awc) {
            console.error("[AWC] Port not available. Abort restoration.");
            return;
          }
          awc.port = event.ports[0];
          console.info("[AWC] Webmessage restoration Done");
        }
        return;
    }
}, false);
""",
    );
    final webMessageChannel = await controller.createWebMessageChannel();
    final port1 = webMessageChannel!.port1;
    final port2 = webMessageChannel.port2;

    // transfer port2 to the webpage to initialize the communication
    await controller.postWebMessage(
      message: WebMessage(data: 'capturePort', ports: [port2]),
      targetOrigin: WebUri('*'),
    );
    return port1;
  }
}

class WebviewMessagePortStreamChannel
    with StreamChannelMixin<String>
    implements StreamChannel<String> {
  WebviewMessagePortStreamChannel({required IWebMessagePort port}) {
    logger.info('Wallet Init WebMessage PortStreamchannel');

    this.port = port;
    _out.stream.listen((event) {
      this.port.postMessage(WebMessage(data: event));
      logger.info('Response sent ${jsonEncode(event)}');
    });
  }
  final logger = Logger('AWS-StreamChannel-Webview');

  IWebMessagePort? _port;
  final _in = StreamController<String>(sync: true);
  final _out = StreamController<String>(sync: true);

  IWebMessagePort get port => _port!;
  set port(IWebMessagePort port) {
    _port?.close();
    _port = port;
    port.setWebMessageCallback((message) {
      if (message == null) return;
      logger.info('Message received ${jsonEncode(message.data)}');
      _in.add(message.data);
    });
  }

  @override
  StreamSink<String> get sink => _out.sink;

  @override
  Stream<String> get stream => _in.stream;
}

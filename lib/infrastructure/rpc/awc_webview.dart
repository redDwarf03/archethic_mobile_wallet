import 'dart:async';

import 'package:aewallet/infrastructure/rpc/awc_json_rpc_server.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:url_launcher/url_launcher.dart';

class AWCWebview extends StatefulWidget {
  const AWCWebview({super.key, required this.uri});

  static final _logger = Logger('AWCWebview');

  static bool get isAvailable => UniversalPlatform.isMobile;

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

class _AWCWebviewState extends State<AWCWebview> {
  AWCJsonRPCServer? peerServer;

  @override
  void initState() {
    if (kDebugMode &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    super.initState();
  }

  @override
  void dispose() {
    peerServer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black,
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
            transparentBackground: true,
            resourceCustomSchemes: ['metamask', 'rainbow', 'trust'],
          ),
          onLoadStop: (controller, url) async {
            await _initMessageChannelRPC(controller, url);
          },
          onWebViewCreated: (controller) async {
            await controller.loadUrl(
              urlRequest: URLRequest(url: WebUri.uri(widget.uri)),
            );
          },
          onLoadResourceWithCustomScheme: (controller, request) async {
            if (!await canLaunchUrl(request.url)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet not installed')),
              );
              return null;
            }
            await launchUrl(request.url);
            return null;
          },
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            // TODO(reddwarf03): WARNING: Accepting all certificates is dangerous and should only be used during development.
            return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            );
          },
        ),
      );

  Future<void> _initMessageChannelRPC(
    InAppWebViewController controller,
    WebUri? uri,
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
    peerServer = AWCJsonRPCServer(channel.cast<String>());
    await peerServer?.listen();
  }

  Future<WebMessagePort> _initMessageChannelPorts(
    InAppWebViewController controller,
  ) async {
    await controller.evaluateJavascript(
      source: """
console.info("[AWC] Init webmessage");
var onAWCReady = (awc) => {};
var awcAvailable = true;
var awc;
window.addEventListener('message', function(event) {
    if (event.data == 'capturePort') {
        if (event.ports[0] != null) {
            awc = event.ports[0];
            console.info("[AWC] Init webmessage Done");
            if (onAWCReady !== undefined) {
              onAWCReady(awc);
            }
        }
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
  WebviewMessagePortStreamChannel({required this.port}) {
    logger.info('Wallet Init WebMessage PortStreamchannel');

    port.setWebMessageCallback((message) {
      if (message == null) return;
      logger.info('Message received');
      _in.add(message.data);
    });

    _out.stream.listen((event) {
      port.postMessage(WebMessage(data: event));
      logger.info('Response sent');
    });
  }
  static final logger = Logger('AWS-StreamChannel-Webview');

  final IWebMessagePort port;
  final _in = StreamController<String>(sync: true);
  final _out = StreamController<String>(sync: true);

  @override
  StreamSink<String> get sink => _out.sink;

  @override
  Stream<String> get stream => _in.stream;
}

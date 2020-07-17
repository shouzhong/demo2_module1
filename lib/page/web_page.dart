import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  WebPage({this.url});

  final String url;

  @override
  State<StatefulWidget> createState() {
    return _WebPageState();
  }
}

class _WebPageState extends State<WebPage> {
  final _controller = Completer<WebViewController>();

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString("assets/web/js_bridge.html");
    _controller.future.then((v) => v?.loadUrl(Uri.dataFromString(
            fileHtmlContents,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Builder(
        builder: (ctx) => WebView(
          initialUrl: widget.url ?? "",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller.complete(controller);
            if (widget.url?.isEmpty ?? true) _loadHtmlFromAssets();
          },
          navigationDelegate: (request) {
            return NavigationDecision.navigate;
          },
          javascriptChannels: [_NativeBridge(context, _controller.future)].toSet(),
        ),
      ),
    );
  }
}

class _NativeBridge implements JavascriptChannel {
  BuildContext context;
  Future<WebViewController> _controller;


  _NativeBridge(this.context, this._controller);

  Map<String, dynamic> _getValue(data) => {"value": 1};

  Future<Map<String, dynamic>>  _inputText(data) async {
    String text = await showDialog(
      context: context,
      builder: (_) {
        final textController = TextEditingController();
        return AlertDialog(
          content: TextField(controller: textController),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context, textController.text),
                child: Icon(Icons.done)),
          ],
        );
      }
    );
    return {"text": text ?? ""};
  }

  Map<String, dynamic> _showSnackBar(data) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(data["text"] ?? "")));
    return null;
  }

  Map<String, dynamic> _newWebView(data) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WebPage(url: data["url"])));
    return null;
  }

  get _functions => <String, Function>{
    "getValue": _getValue,
    "inputText": _inputText,
    "showSnackBar": _showSnackBar,
    "newWebView": _newWebView,
  };

  @override
  String get name => "nativeBridge";

  @override
  get onMessageReceived => (msg) async {
    Map<String, dynamic> message = json.decode(msg.message);
    final data = await _functions[message["api"]](message["data"]);
    message["data"] = data;
    _controller.then((value) => value.evaluateJavascript(
            "window.jsBridge.receiveMessage(${json.encode(message)})"));
      };
}
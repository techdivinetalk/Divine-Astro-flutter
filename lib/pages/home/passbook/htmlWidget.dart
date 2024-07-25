import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  var html;
  Webview({this.html});
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController _con;

  @override
  Widget build(BuildContext context) {
    return Webview(
      html: widget.html,
    );
  }
}

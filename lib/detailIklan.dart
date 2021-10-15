import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailIklan extends StatefulWidget {
  const DetailIklan({Key key, this.data}) : super(key: key);
  final dynamic data;
  @override
  _DetailIklanState createState() => _DetailIklanState();
}

class _DetailIklanState extends State<DetailIklan> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Iklan'),
          centerTitle: true,
        ),
        body: widget.data["link_flash"] == null
            ? WebView(
                initialUrl:
                    widget.data["link_flash"], //'https://www.google.com'
                javascriptMode: JavascriptMode.unrestricted,
              )
            : Center(
                child: Text('No link'),
              ));
  }
}

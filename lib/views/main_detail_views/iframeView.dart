import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';
// import 'package:artgen/views/main_detail_views/components/header.dart';

// ignore: undefined_prefixed_name
class Iframe extends StatelessWidget {
  Iframe() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = 'http://172.16.2.37:8000/';
      return iframe;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Container(child: const HtmlElementView(viewType: 'iframe')));
  }
}

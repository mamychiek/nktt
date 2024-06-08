// ignore_for_file: unused_import

import 'package:blogger_api/blogger_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:url_launcher/url_launcher.dart';

class HTMLVIew extends StatefulWidget {
  final PostItemModel data;
  HTMLVIew({
    super.key,
    required this.data,
  });

  @override
  State<HTMLVIew> createState() => _HTMLVIewState();
}

class _HTMLVIewState extends State<HTMLVIew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.title!),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              widget.data.content!,
              customStylesBuilder: (element) {
                if (element.classes.contains('foo')) {
                  return {'color': 'red'};
                }

                return null;
              },
              //customWidgetBuilder: (element) {},
              onTapUrl: (url) async {
                if (!await launchUrl(Uri.parse(url))) {
                  throw 'Could not launch $url';
                }
                return true;
              },
              onErrorBuilder: (context, element, error) =>
                  Text('$element error: $error'),
              onLoadingBuilder: (context, element, loadingProgress) =>
                  const CircularProgressIndicator(),
              renderMode: RenderMode.column,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

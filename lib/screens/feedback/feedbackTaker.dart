import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:minimal_adhan/extensions.dart';

class FeedbackTaker extends StatefulWidget {
  final String url;
  final String title;

  const FeedbackTaker(this.title, this.url);

  @override
  State<FeedbackTaker> createState() => _FeedbackTakerState();
}

class _FeedbackTakerState extends State<FeedbackTaker> {
  bool loading = true;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () => launchUrl(Uri.parse(widget.url)),
                icon: const Icon(Icons.open_in_new))
          ],
        ),
        body: error
            ? Center(
                child: Text(
                  context.appLocale.error_occured,
                  style: context.textTheme.headline1
                      ?.copyWith(color: Colors.red, fontSize: context.textTheme.headline3?.fontSize),
                ),
              )
            : Stack(
                children: [
                  WebView(
                    initialUrl: widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (_) => setState(() {
                      loading = false;
                    }),
                    onWebResourceError: (_) => setState(() {
                      error = true;
                    }),
                  ),
                  if (loading) const Loading(),
                ],
              ));
  }
}

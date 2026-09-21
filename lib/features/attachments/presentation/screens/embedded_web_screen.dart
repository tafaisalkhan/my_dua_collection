import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedWebScreen extends StatefulWidget {
  const EmbeddedWebScreen({super.key, required this.url, required this.title});
  final String url, title;
  @override
  State<EmbeddedWebScreen> createState() => _EmbeddedWebState();
}

class _EmbeddedWebState extends State<EmbeddedWebScreen> {
  late final WebViewController controller;
  int progress = 0;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (v) {
            if (mounted) setState(() => progress = v);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          tooltip: 'Open in external app',
          icon: const Icon(Icons.open_in_new),
          onPressed: () => launchUrl(
            Uri.parse(widget.url),
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
    ),
    body: Column(
      children: [
        if (progress < 100) LinearProgressIndicator(value: progress / 100),
        Expanded(child: WebViewWidget(controller: controller)),
      ],
    ),
  );
}

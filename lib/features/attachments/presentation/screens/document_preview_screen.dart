import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

class DocumentPreviewScreen extends StatelessWidget {
  const DocumentPreviewScreen({
    super.key,
    required this.path,
    required this.title,
  });
  final String path;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isPdf = p.extension(path).toLowerCase() == '.pdf';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Open in another app',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => OpenFilex.open(path),
          ),
        ],
      ),
      body: isPdf
          ? PdfViewer.file(path)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.description_outlined, size: 72),
                    const SizedBox(height: 16),
                    Text(title, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    const Text(
                      'This file is attached to the Dua. Its format requires a compatible app installed on your phone.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => OpenFilex.open(path),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open attached file'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

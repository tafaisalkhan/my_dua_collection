// ignore_for_file: unnecessary_underscores, prefer_interpolation_to_compose_strings
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({
    super.key,
    required this.source,
    required this.imagePath,
  });
  final String source;
  final String? imagePath;
  @override
  Widget build(BuildContext c) {
    final f = imagePath == null ? null : File(imagePath!),
        ok = f?.existsSync() ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ok
                    ? Image.file(
                        f!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('Image could not be displayed.'),
                        ),
                      )
                    : const Center(child: Text('No image selected.')),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              source == 'camera'
                  ? 'Photo captured successfully'
                  : 'Image selected successfully',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => c.pop(),
                    child: const Text('Choose Again'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: ok
                        ? () => c.push(
                            '/add/crop?path=' + Uri.encodeComponent(imagePath!),
                          )
                        : null,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

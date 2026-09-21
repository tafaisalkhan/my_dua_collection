// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/ocr_controller.dart';

class OcrReviewScreen extends ConsumerStatefulWidget {
  const OcrReviewScreen({super.key, required this.imagePath});
  final String imagePath;
  @override
  ConsumerState<OcrReviewScreen> createState() => _State();
}

class _State extends ConsumerState<OcrReviewScreen> {
  final c = TextEditingController();
  bool applied = false;
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = ref.watch(ocrResultProvider(widget.imagePath));
    r.whenData((v) {
      if (!applied) {
        applied = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) c.text = v.text;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Review Scanned Dua')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.file(
              File(widget.imagePath),
              height: 190,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          r.when(
            loading: () => const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Preparing image and reading its text...'),
              ],
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('OCR failed: ' + e.toString()),
              ),
            ),
            data: (v) => Text(
              'Text extracted successfully',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: c,
            minLines: 7,
            maxLines: 14,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: 'EXTRACTED TEXT',
              alignLabelWithHint: true,
              hintText: 'Detected text is editable here',
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              ref.invalidate(ocrResultProvider(widget.imagePath));
              applied = false;
            },
            child: const Text('Scan Again'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: r.hasValue
                ? () => context.push(
                    '/add/manual?ocrText=' + Uri.encodeComponent(c.text),
                  )
                : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

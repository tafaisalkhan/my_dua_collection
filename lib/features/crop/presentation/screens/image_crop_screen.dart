import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageCropScreen extends StatefulWidget {
  const ImageCropScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageCropScreen> createState() => _ImageCropState();
}

enum _DragMode { move, topLeft, topRight, bottomLeft, bottomRight }

class _ImageCropState extends State<ImageCropScreen> {
  img.Image? _source;
  Uint8List? _imageBytes;
  Uint8List? _preview;
  Rect _crop = const Rect.fromLTWH(.1, .1, .8, .8);
  Rect _displayRect = Rect.zero;
  _DragMode? _dragMode;
  Offset? _lastLongPressPosition;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return;
    _source = img.bakeOrientation(decoded);
    _imageBytes = Uint8List.fromList(img.encodeJpg(_source!, quality: 92));
    _updatePreview();
  }

  void _updatePreview() {
    final source = _source;
    if (source == null) return;
    final x = (_crop.left * source.width).round().clamp(0, source.width - 1);
    final y = (_crop.top * source.height).round().clamp(0, source.height - 1);
    final width = (_crop.width * source.width).round().clamp(
      1,
      source.width - x,
    );
    final height = (_crop.height * source.height).round().clamp(
      1,
      source.height - y,
    );
    _preview = Uint8List.fromList(
      img.encodePng(
        img.copyCrop(source, x: x, y: y, width: width, height: height),
      ),
    );
    if (mounted) setState(() {});
  }

  Rect get _selection => Rect.fromLTRB(
    _displayRect.left + (_crop.left * _displayRect.width),
    _displayRect.top + (_crop.top * _displayRect.height),
    _displayRect.left + (_crop.right * _displayRect.width),
    _displayRect.top + (_crop.bottom * _displayRect.height),
  );

  void _startAt(Offset point) {
    final selection = _selection;
    const radius = 34.0;
    if ((point - selection.topLeft).distance <= radius) {
      _dragMode = _DragMode.topLeft;
    } else if ((point - selection.topRight).distance <= radius) {
      _dragMode = _DragMode.topRight;
    } else if ((point - selection.bottomLeft).distance <= radius) {
      _dragMode = _DragMode.bottomLeft;
    } else if ((point - selection.bottomRight).distance <= radius) {
      _dragMode = _DragMode.bottomRight;
    } else if (selection.contains(point)) {
      _dragMode = _DragMode.move;
    }
  }

  void _dragBy(Offset delta) {
    final mode = _dragMode;
    if (mode == null || _displayRect.isEmpty) return;
    final dx = delta.dx / _displayRect.width;
    final dy = delta.dy / _displayRect.height;
    const minimum = .08;
    var left = _crop.left;
    var top = _crop.top;
    var right = _crop.right;
    var bottom = _crop.bottom;
    switch (mode) {
      case _DragMode.move:
        final moveX = dx.clamp(-left, 1 - right);
        final moveY = dy.clamp(-top, 1 - bottom);
        left += moveX;
        right += moveX;
        top += moveY;
        bottom += moveY;
      case _DragMode.topLeft:
        left = (left + dx).clamp(0, right - minimum);
        top = (top + dy).clamp(0, bottom - minimum);
      case _DragMode.topRight:
        right = (right + dx).clamp(left + minimum, 1);
        top = (top + dy).clamp(0, bottom - minimum);
      case _DragMode.bottomLeft:
        left = (left + dx).clamp(0, right - minimum);
        bottom = (bottom + dy).clamp(top + minimum, 1);
      case _DragMode.bottomRight:
        right = (right + dx).clamp(left + minimum, 1);
        bottom = (bottom + dy).clamp(top + minimum, 1);
    }
    setState(() => _crop = Rect.fromLTRB(left, top, right, bottom));
  }

  void _finishDrag() {
    _dragMode = null;
    _lastLongPressPosition = null;
    _updatePreview();
  }

  Future<void> _save() async {
    final preview = _preview;
    if (preview == null) return;
    setState(() => _saving = true);
    final directory = await getTemporaryDirectory();
    final file = File(
      p.join(directory.path, 'dua_crop_${const Uuid().v4()}.png'),
    );
    await file.writeAsBytes(preview, flush: true);
    if (mounted) {
      context.go('/add/manual?croppedPath=${Uri.encodeComponent(file.path)}');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Select Dua Area')),
    body: _source == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              const Text(
                'Long-press inside the box to move it. Long-press a white corner, then drag to increase or decrease the selected area.',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 330,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final source = _source!;
                    final imageRatio = source.width / source.height;
                    final boxRatio =
                        constraints.maxWidth / constraints.maxHeight;
                    final width = imageRatio > boxRatio
                        ? constraints.maxWidth
                        : constraints.maxHeight * imageRatio;
                    final height = imageRatio > boxRatio
                        ? constraints.maxWidth / imageRatio
                        : constraints.maxHeight;
                    _displayRect = Rect.fromLTWH(
                      (constraints.maxWidth - width) / 2,
                      (constraints.maxHeight - height) / 2,
                      width,
                      height,
                    );
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onLongPressStart: (details) {
                        _lastLongPressPosition = details.localPosition;
                        _startAt(details.localPosition);
                      },
                      onLongPressMoveUpdate: (details) {
                        final previous = _lastLongPressPosition;
                        if (previous == null) return;
                        _dragBy(details.localPosition - previous);
                        _lastLongPressPosition = details.localPosition;
                      },
                      onLongPressEnd: (_) => _finishDrag(),
                      child: Stack(
                        children: [
                          Positioned.fromRect(
                            rect: _displayRect,
                            child: Image.memory(_imageBytes!, fit: BoxFit.fill),
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _CropOverlayPainter(
                                imageRect: _displayRect,
                                selection: _selection,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cropped result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                height: 140,
                color: Colors.black12,
                child: _preview == null
                    ? const Center(child: CircularProgressIndicator())
                    : Image.memory(_preview!, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.crop),
                label: Text(_saving ? 'Saving...' : 'Use selected area'),
              ),
            ],
          ),
  );
}

class _CropOverlayPainter extends CustomPainter {
  const _CropOverlayPainter({required this.imageRect, required this.selection});
  final Rect imageRect;
  final Rect selection;

  @override
  void paint(Canvas canvas, Size size) {
    final shade = Paint()..color = Colors.black.withValues(alpha: .55);
    canvas.save();
    canvas.clipRect(imageRect);
    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(imageRect)
      ..addRect(selection);
    canvas.drawPath(outside, shade);
    canvas.drawRect(
      selection,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final handle = Paint()..color = Colors.white;
    for (final point in [
      selection.topLeft,
      selection.topRight,
      selection.bottomLeft,
      selection.bottomRight,
    ]) {
      canvas.drawCircle(point, 12, handle);
      canvas.drawCircle(
        point,
        12,
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) =>
      oldDelegate.imageRect != imageRect || oldDelegate.selection != selection;
}

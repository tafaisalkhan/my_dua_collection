import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
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

enum _DragTarget {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topEdge,
  bottomEdge,
  leftEdge,
  rightEdge,
  moveCrop,
  panImage,
}

enum _InteractionMode {
  cropBox,
  panAndZoom,
}

class _ImageCropState extends State<ImageCropScreen> {
  img.Image? _source;
  Uint8List? _imageBytes;
  Uint8List? _preview;

  // Viewport & Transform State
  Size? _viewportSize;
  double _zoom = 1.0;
  Offset _pan = Offset.zero;
  Rect _cropRect = Rect.zero;
  bool _initializedCrop = false;

  // Gestures
  _DragTarget _dragTarget = _DragTarget.none;
  _InteractionMode _interactionMode = _InteractionMode.cropBox;
  Offset _lastFocalPoint = Offset.zero;
  double _baseZoom = 1.0;

  bool _saving = false;
  Timer? _previewDebounceTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _previewDebounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final file = File(widget.imagePath);
    if (!file.existsSync()) return;
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return;
    _source = img.bakeOrientation(decoded);
    _imageBytes = Uint8List.fromList(img.encodeJpg(_source!, quality: 92));
    if (mounted) {
      setState(() {});
    }
  }

  void _rotate90() {
    final src = _source;
    if (src == null) return;
    _source = img.copyRotate(src, angle: 90);
    _imageBytes = Uint8List.fromList(img.encodeJpg(_source!, quality: 92));
    _zoom = 1.0;
    _pan = Offset.zero;
    _initializedCrop = false;
    setState(() {});
    _schedulePreviewUpdate();
  }

  void _initCrop(Size viewportSize) {
    if (_source == null || viewportSize.isEmpty) return;
    _viewportSize = viewportSize;

    final source = _source!;
    final fitScale = math.min(
      viewportSize.width / source.width,
      viewportSize.height / source.height,
    );
    final baseW = source.width * fitScale;
    final baseH = source.height * fitScale;
    final imgLeft = (viewportSize.width - baseW) / 2;
    final imgTop = (viewportSize.height - baseH) / 2;

    // Center crop rect covering ~75% of the visible image
    final padW = baseW * 0.12;
    final padH = baseH * 0.15;
    _cropRect = Rect.fromLTRB(
      imgLeft + padW,
      imgTop + padH,
      imgLeft + baseW - padW,
      imgTop + baseH - padH,
    );
    _initializedCrop = true;
    _updatePreview();
  }

  void _clampPan(Size vp, Size imgSize) {
    final fitScale = math.min(vp.width / imgSize.width, vp.height / imgSize.height);
    final currentW = imgSize.width * fitScale * _zoom;
    final currentH = imgSize.height * fitScale * _zoom;

    final maxPanX = math.max(0.0, (currentW - vp.width) / 2) + vp.width * 0.4;
    final maxPanY = math.max(0.0, (currentH - vp.height) / 2) + vp.height * 0.4;

    _pan = Offset(
      _pan.dx.clamp(-maxPanX, maxPanX),
      _pan.dy.clamp(-maxPanY, maxPanY),
    );
  }

  void _zoomIn() {
    setState(() {
      _zoom = (_zoom * 1.3).clamp(1.0, 6.0);
      if (_viewportSize != null && _source != null) {
        _clampPan(_viewportSize!, Size(_source!.width.toDouble(), _source!.height.toDouble()));
      }
    });
    _schedulePreviewUpdate();
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom / 1.3).clamp(1.0, 6.0);
      if (_viewportSize != null && _source != null) {
        _clampPan(_viewportSize!, Size(_source!.width.toDouble(), _source!.height.toDouble()));
      }
    });
    _schedulePreviewUpdate();
  }

  void _resetZoom() {
    setState(() {
      _zoom = 1.0;
      _pan = Offset.zero;
    });
    _schedulePreviewUpdate();
  }

  void _fitCropToImage() {
    final vp = _viewportSize;
    final source = _source;
    if (vp == null || source == null) return;

    final fitScale = math.min(vp.width / source.width, vp.height / source.height);
    final currentW = source.width * fitScale * _zoom;
    final currentH = source.height * fitScale * _zoom;
    final imgLeft = (vp.width - currentW) / 2 + _pan.dx;
    final imgTop = (vp.height - currentH) / 2 + _pan.dy;

    setState(() {
      _cropRect = Rect.fromLTRB(
        imgLeft.clamp(0.0, vp.width),
        imgTop.clamp(0.0, vp.height),
        (imgLeft + currentW).clamp(0.0, vp.width),
        (imgTop + currentH).clamp(0.0, vp.height),
      );
    });
    _schedulePreviewUpdate();
  }

  void _schedulePreviewUpdate() {
    _previewDebounceTimer?.cancel();
    _previewDebounceTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) {
        _updatePreview();
      }
    });
  }

  void _updatePreview() {
    final source = _source;
    final vp = _viewportSize;
    if (source == null || vp == null || vp.isEmpty || _cropRect.isEmpty) return;

    final fitScale = math.min(vp.width / source.width, vp.height / source.height);
    final currentW = source.width * fitScale * _zoom;
    final currentH = source.height * fitScale * _zoom;
    final imgLeft = (vp.width - currentW) / 2 + _pan.dx;
    final imgTop = (vp.height - currentH) / 2 + _pan.dy;

    final leftPx = ((_cropRect.left - imgLeft) / (fitScale * _zoom))
        .clamp(0.0, source.width.toDouble() - 1.0);
    final topPx = ((_cropRect.top - imgTop) / (fitScale * _zoom))
        .clamp(0.0, source.height.toDouble() - 1.0);
    final rightPx = ((_cropRect.right - imgLeft) / (fitScale * _zoom))
        .clamp(leftPx + 1.0, source.width.toDouble());
    final bottomPx = ((_cropRect.bottom - imgTop) / (fitScale * _zoom))
        .clamp(topPx + 1.0, source.height.toDouble());

    final x = leftPx.round();
    final y = topPx.round();
    final width = (rightPx - leftPx).round().clamp(1, source.width - x);
    final height = (bottomPx - topPx).round().clamp(1, source.height - y);

    try {
      final cropped = img.copyCrop(
        source,
        x: x,
        y: y,
        width: width,
        height: height,
      );
      _preview = Uint8List.fromList(img.encodePng(cropped));
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
    _baseZoom = _zoom;

    if (details.pointerCount >= 2 || _interactionMode == _InteractionMode.panAndZoom) {
      _dragTarget = _DragTarget.panImage;
      return;
    }

    final p = details.localFocalPoint;
    const cornerRadius = 32.0;
    const edgeThreshold = 24.0;

    if ((p - _cropRect.topLeft).distance <= cornerRadius) {
      _dragTarget = _DragTarget.topLeft;
    } else if ((p - _cropRect.topRight).distance <= cornerRadius) {
      _dragTarget = _DragTarget.topRight;
    } else if ((p - _cropRect.bottomLeft).distance <= cornerRadius) {
      _dragTarget = _DragTarget.bottomLeft;
    } else if ((p - _cropRect.bottomRight).distance <= cornerRadius) {
      _dragTarget = _DragTarget.bottomRight;
    } else if ((p.dy - _cropRect.top).abs() <= edgeThreshold &&
        p.dx >= _cropRect.left - 10 &&
        p.dx <= _cropRect.right + 10) {
      _dragTarget = _DragTarget.topEdge;
    } else if ((p.dy - _cropRect.bottom).abs() <= edgeThreshold &&
        p.dx >= _cropRect.left - 10 &&
        p.dx <= _cropRect.right + 10) {
      _dragTarget = _DragTarget.bottomEdge;
    } else if ((p.dx - _cropRect.left).abs() <= edgeThreshold &&
        p.dy >= _cropRect.top - 10 &&
        p.dy <= _cropRect.bottom + 10) {
      _dragTarget = _DragTarget.leftEdge;
    } else if ((p.dx - _cropRect.right).abs() <= edgeThreshold &&
        p.dy >= _cropRect.top - 10 &&
        p.dy <= _cropRect.bottom + 10) {
      _dragTarget = _DragTarget.rightEdge;
    } else if (_cropRect.contains(p)) {
      _dragTarget = _DragTarget.moveCrop;
    } else {
      _dragTarget = _DragTarget.panImage;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final delta = details.localFocalPoint - _lastFocalPoint;
    _lastFocalPoint = details.localFocalPoint;

    if (details.pointerCount >= 2) {
      setState(() {
        _zoom = (_baseZoom * details.scale).clamp(1.0, 6.0);
        _pan += delta;
        if (_viewportSize != null && _source != null) {
          _clampPan(_viewportSize!, Size(_source!.width.toDouble(), _source!.height.toDouble()));
        }
      });
      _schedulePreviewUpdate();
      return;
    }

    const minSize = 48.0;
    final vw = _viewportSize?.width ?? 300.0;
    final vh = _viewportSize?.height ?? 300.0;

    setState(() {
      switch (_dragTarget) {
        case _DragTarget.panImage:
          _pan += delta;
          if (_viewportSize != null && _source != null) {
            _clampPan(_viewportSize!, Size(_source!.width.toDouble(), _source!.height.toDouble()));
          }
          break;

        case _DragTarget.moveCrop:
          double newLeft = _cropRect.left + delta.dx;
          double newTop = _cropRect.top + delta.dy;
          if (newLeft < 0) newLeft = 0;
          if (newTop < 0) newTop = 0;
          if (newLeft + _cropRect.width > vw) newLeft = vw - _cropRect.width;
          if (newTop + _cropRect.height > vh) newTop = vh - _cropRect.height;
          _cropRect = Rect.fromLTWH(newLeft, newTop, _cropRect.width, _cropRect.height);
          break;

        case _DragTarget.topLeft:
          final newLeft = (_cropRect.left + delta.dx).clamp(0.0, _cropRect.right - minSize);
          final newTop = (_cropRect.top + delta.dy).clamp(0.0, _cropRect.bottom - minSize);
          _cropRect = Rect.fromLTRB(newLeft, newTop, _cropRect.right, _cropRect.bottom);
          break;

        case _DragTarget.topRight:
          final newRight = (_cropRect.right + delta.dx).clamp(_cropRect.left + minSize, vw);
          final newTop = (_cropRect.top + delta.dy).clamp(0.0, _cropRect.bottom - minSize);
          _cropRect = Rect.fromLTRB(_cropRect.left, newTop, newRight, _cropRect.bottom);
          break;

        case _DragTarget.bottomLeft:
          final newLeft = (_cropRect.left + delta.dx).clamp(0.0, _cropRect.right - minSize);
          final newBottom = (_cropRect.bottom + delta.dy).clamp(_cropRect.top + minSize, vh);
          _cropRect = Rect.fromLTRB(newLeft, _cropRect.top, _cropRect.right, newBottom);
          break;

        case _DragTarget.bottomRight:
          final newRight = (_cropRect.right + delta.dx).clamp(_cropRect.left + minSize, vw);
          final newBottom = (_cropRect.bottom + delta.dy).clamp(_cropRect.top + minSize, vh);
          _cropRect = Rect.fromLTRB(_cropRect.left, _cropRect.top, newRight, newBottom);
          break;

        case _DragTarget.topEdge:
          final newTop = (_cropRect.top + delta.dy).clamp(0.0, _cropRect.bottom - minSize);
          _cropRect = Rect.fromLTRB(_cropRect.left, newTop, _cropRect.right, _cropRect.bottom);
          break;

        case _DragTarget.bottomEdge:
          final newBottom = (_cropRect.bottom + delta.dy).clamp(_cropRect.top + minSize, vh);
          _cropRect = Rect.fromLTRB(_cropRect.left, _cropRect.top, _cropRect.right, newBottom);
          break;

        case _DragTarget.leftEdge:
          final newLeft = (_cropRect.left + delta.dx).clamp(0.0, _cropRect.right - minSize);
          _cropRect = Rect.fromLTRB(newLeft, _cropRect.top, _cropRect.right, _cropRect.bottom);
          break;

        case _DragTarget.rightEdge:
          final newRight = (_cropRect.right + delta.dx).clamp(_cropRect.left + minSize, vw);
          _cropRect = Rect.fromLTRB(_cropRect.left, _cropRect.top, newRight, _cropRect.bottom);
          break;

        case _DragTarget.none:
          break;
      }
    });

    _schedulePreviewUpdate();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _dragTarget = _DragTarget.none;
    _updatePreview();
  }

  Future<void> _save() async {
    final source = _source;
    final vp = _viewportSize;
    if (source == null || vp == null || vp.isEmpty || _cropRect.isEmpty) return;
    setState(() => _saving = true);

    try {
      final fitScale = math.min(vp.width / source.width, vp.height / source.height);
      final currentW = source.width * fitScale * _zoom;
      final currentH = source.height * fitScale * _zoom;
      final imgLeft = (vp.width - currentW) / 2 + _pan.dx;
      final imgTop = (vp.height - currentH) / 2 + _pan.dy;

      final leftPx = ((_cropRect.left - imgLeft) / (fitScale * _zoom))
          .clamp(0.0, source.width.toDouble() - 1.0);
      final topPx = ((_cropRect.top - imgTop) / (fitScale * _zoom))
          .clamp(0.0, source.height.toDouble() - 1.0);
      final rightPx = ((_cropRect.right - imgLeft) / (fitScale * _zoom))
          .clamp(leftPx + 1.0, source.width.toDouble());
      final bottomPx = ((_cropRect.bottom - imgTop) / (fitScale * _zoom))
          .clamp(topPx + 1.0, source.height.toDouble());

      final x = leftPx.round();
      final y = topPx.round();
      final width = (rightPx - leftPx).round().clamp(1, source.width - x);
      final height = (bottomPx - topPx).round().clamp(1, source.height - y);

      final cropped = img.copyCrop(
        source,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      final directory = await getTemporaryDirectory();
      final file = File(
        p.join(directory.path, 'dua_crop_${const Uuid().v4()}.png'),
      );
      await file.writeAsBytes(img.encodePng(cropped), flush: true);

      if (mounted) {
        context.go('/add/manual?croppedPath=${Uri.encodeComponent(file.path)}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cropping image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Dua Area'),
        actions: [
          IconButton(
            icon: const Icon(Icons.rotate_right),
            tooltip: 'Rotate 90°',
            onPressed: _source == null ? null : _rotate90,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Done',
            onPressed: (_source == null || _saving) ? null : _save,
          ),
        ],
      ),
      body: _source == null || _imageBytes == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top tip badge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
                  child: Row(
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _interactionMode == _InteractionMode.cropBox
                              ? 'Pinch or tap +/- to zoom in on Dua. Drag handles to resize crop box.'
                              : 'Pan & zoom mode: Drag with 1 finger to pan image, pinch to zoom.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Interactive Crop Area
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final vp = Size(constraints.maxWidth, constraints.maxHeight);
                      if (!_initializedCrop || _viewportSize != vp) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) _initCrop(vp);
                        });
                      }

                      final source = _source!;
                      final fitScale = math.min(vp.width / source.width, vp.height / source.height);
                      final currentW = source.width * fitScale * _zoom;
                      final currentH = source.height * fitScale * _zoom;
                      final imgLeft = (vp.width - currentW) / 2 + _pan.dx;
                      final imgTop = (vp.height - currentH) / 2 + _pan.dy;

                      return Stack(
                        children: [
                          // Dark background container
                          Positioned.fill(
                            child: Container(color: Colors.black87),
                          ),

                          // The Scaled and Panned Image
                          Positioned(
                            left: imgLeft,
                            top: imgTop,
                            width: currentW,
                            height: currentH,
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),

                          // Crop Overlay Mask & Handles
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _CropOverlayPainter(
                                cropRect: _cropRect,
                              ),
                            ),
                          ),

                          // Touch & Gesture Recognizer
                          Positioned.fill(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onScaleStart: _onScaleStart,
                              onScaleUpdate: _onScaleUpdate,
                              onScaleEnd: _onScaleEnd,
                            ),
                          ),

                          // Floating Zoom & Mode Toolbar
                          Positioned(
                            top: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Zoom Controls Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        tooltip: 'Zoom Out',
                                        onPressed: _zoom > 1.0 ? _zoomOut : null,
                                      ),
                                      InkWell(
                                        onTap: _resetZoom,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Text(
                                            '${_zoom.toStringAsFixed(1)}x',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        tooltip: 'Zoom In',
                                        onPressed: _zoom < 6.0 ? _zoomIn : null,
                                      ),
                                    ],
                                  ),
                                ),

                                // Mode Toggle & Fit Button
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.fit_screen, color: Colors.white, size: 18),
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                                        tooltip: 'Fit to screen',
                                        onPressed: _fitCropToImage,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _interactionMode = _interactionMode == _InteractionMode.cropBox
                                              ? _InteractionMode.panAndZoom
                                              : _InteractionMode.cropBox;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: _interactionMode == _InteractionMode.panAndZoom
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.black.withValues(alpha: 0.65),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.25),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _interactionMode == _InteractionMode.panAndZoom
                                                  ? Icons.pan_tool
                                                  : Icons.crop,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _interactionMode == _InteractionMode.panAndZoom
                                                  ? 'Pan Image'
                                                  : 'Crop Box',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Bottom Action & Thumbnail Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Live Thumbnail Preview
                        Container(
                          width: 68,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _preview == null
                              ? const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : Image.memory(_preview!, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 12),

                        // Action Button
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.crop),
                            label: Text(_saving ? 'Cropping Dua...' : 'Use selected area'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  const _CropOverlayPainter({required this.cropRect});
  final Rect cropRect;

  @override
  void paint(Canvas canvas, Size size) {
    if (cropRect.isEmpty) return;

    // Darkened mask outside cropRect
    final shade = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(cropRect);
    canvas.drawPath(outside, shade);

    // Grid lines (rule of thirds)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    final oneThirdW = cropRect.width / 3;
    final oneThirdH = cropRect.height / 3;
    canvas.drawLine(
      Offset(cropRect.left + oneThirdW, cropRect.top),
      Offset(cropRect.left + oneThirdW, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left + oneThirdW * 2, cropRect.top),
      Offset(cropRect.left + oneThirdW * 2, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + oneThirdH),
      Offset(cropRect.right, cropRect.top + oneThirdH),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + oneThirdH * 2),
      Offset(cropRect.right, cropRect.top + oneThirdH * 2),
      gridPaint,
    );

    // Crisp crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(cropRect, borderPaint);

    // Corner Handles
    final handleFill = Paint()..color = Colors.white;
    final handleStroke = Paint()
      ..color = Colors.teal.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (final point in [
      cropRect.topLeft,
      cropRect.topRight,
      cropRect.bottomLeft,
      cropRect.bottomRight,
    ]) {
      canvas.drawCircle(point, 11, handleFill);
      canvas.drawCircle(point, 11, handleStroke);
    }

    // Midpoint Edge Pills
    final edgeFill = Paint()..color = Colors.white;
    final edgeStroke = Paint()
      ..color = Colors.teal.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Top edge pill
    final topPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRect.left + cropRect.width / 2, cropRect.top),
        width: 28,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(topPill, edgeFill);
    canvas.drawRRect(topPill, edgeStroke);

    // Bottom edge pill
    final bottomPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRect.left + cropRect.width / 2, cropRect.bottom),
        width: 28,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(bottomPill, edgeFill);
    canvas.drawRRect(bottomPill, edgeStroke);

    // Left edge pill
    final leftPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRect.left, cropRect.top + cropRect.height / 2),
        width: 6,
        height: 28,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(leftPill, edgeFill);
    canvas.drawRRect(leftPill, edgeStroke);

    // Right edge pill
    final rightPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRect.right, cropRect.top + cropRect.height / 2),
        width: 6,
        height: 28,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(rightPill, edgeFill);
    canvas.drawRRect(rightPill, edgeStroke);
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) =>
      oldDelegate.cropRect != cropRect;
}

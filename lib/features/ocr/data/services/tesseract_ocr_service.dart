import 'dart:async';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

import '../../domain/entities/ocr_result.dart';
import '../../domain/services/ocr_service.dart';

class TesseractOcrService implements OcrService {
  static const _urduFirst = 'urd+ara+eng';
  static const _arabicFirst = 'ara+urd+eng';

  @override
  Future<OcrResult> recognize(String path) async {
    final source = File(path);
    if (!await source.exists() || await source.length() == 0) {
      throw const FormatException('The selected image is missing or empty.');
    }

    final preparedPath = await _prepareImage(source);
    final firstPasses = await Future.wait([
      _extract(path, _urduFirst),
      _extract(preparedPath, _urduFirst),
      _extract(path, _arabicFirst),
      _extract(preparedPath, _arabicFirst),
    ]);
    firstPasses.sort((a, b) => _quality(b).compareTo(_quality(a)));
    var text = firstPasses.first;
    if (text.trim().isEmpty) {
      final attempts = await Future.wait([
        _extract(preparedPath, 'ara'),
        _extract(preparedPath, 'urd'),
        _extract(preparedPath, 'eng'),
      ]);
      attempts.sort((a, b) => b.trim().length.compareTo(a.trim().length));
      text = attempts.first;
    }

    final cleaned = text.trim();
    if (cleaned.isEmpty) {
      throw const FormatException(
        'No readable text was found. Use a sharp, well-lit image and crop it close to the text.',
      );
    }
    return OcrResult(text: cleaned, languageCode: _detectScript(cleaned));
  }

  Future<String> _extract(String path, String language) =>
      TesseractOcr.extractText(
        path,
        config: OCRConfig(language: language, engine: OCREngine.tesseract),
      ).timeout(const Duration(seconds: 60));

  Future<String> _prepareImage(File source) async {
    final decoded = img.decodeImage(await source.readAsBytes());
    if (decoded == null) {
      throw const FormatException('This image format could not be decoded.');
    }
    var prepared = img.bakeOrientation(decoded);
    if (prepared.width > 2400 || prepared.height > 2400) {
      prepared = img.copyResize(
        prepared,
        width: prepared.width >= prepared.height ? 2400 : null,
        height: prepared.height > prepared.width ? 2400 : null,
        interpolation: img.Interpolation.cubic,
      );
    }
    prepared = img.grayscale(prepared);
    prepared = img.adjustColor(prepared, contrast: 1.35);
    final directory = await getTemporaryDirectory();
    final output = File(p.join(directory.path, 'favorite_dua_ocr.jpg'));
    await output.writeAsBytes(
      img.encodeJpg(prepared, quality: 95),
      flush: true,
    );
    return output.path;
  }

  int _quality(String text) {
    final visible = text.replaceAll(RegExp(r'\s+'), '').length;
    final lines = text
        .split('\n')
        .where((line) => line.trim().length > 2)
        .length;
    return visible + (lines * 8);
  }

  String _detectScript(String text) {
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) return 'ar';
    if (RegExp(r'[\u0900-\u097F]').hasMatch(text)) return 'hi';
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) return 'zh';
    return 'und';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/tesseract_ocr_service.dart';
import '../../domain/entities/ocr_result.dart';
import '../../domain/services/ocr_service.dart';

final ocrServiceProvider = Provider<OcrService>((r) => TesseractOcrService());
final ocrResultProvider = FutureProvider.family<OcrResult, String>(
  (r, p) => r.watch(ocrServiceProvider).recognize(p),
);

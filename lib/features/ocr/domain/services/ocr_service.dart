import '../entities/ocr_result.dart';

abstract interface class OcrService {
  Future<OcrResult> recognize(String imagePath);
}

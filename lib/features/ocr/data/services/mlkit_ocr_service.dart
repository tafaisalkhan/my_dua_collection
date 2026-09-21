import '../../domain/entities/ocr_result.dart';
import '../../domain/services/ocr_service.dart';

class MlKitOcrService implements OcrService {
  @override
  Future<OcrResult> recognize(String imagePath) =>
      throw UnimplementedError('OCR is scheduled for Step 4.');
}

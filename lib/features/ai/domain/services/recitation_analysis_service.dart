import '../entities/recitation_result.dart';

abstract interface class RecitationAnalysisService {
  Future<RecitationResult> analyze({
    required String expectedText,
    required String audioPath,
  });
}

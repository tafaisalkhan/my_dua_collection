class OcrResult {
  const OcrResult({required this.text, this.languageCode, this.confidence});
  final String text;
  final String? languageCode;
  final double? confidence;
}

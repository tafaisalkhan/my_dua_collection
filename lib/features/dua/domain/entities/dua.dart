class Dua {
  const Dua({
    required this.id,
    required this.title,
    required this.originalText,
    this.ocrText,
    this.translation,
    this.transliteration,
    this.reference,
    this.notes,
    this.primaryCategoryId,
    this.imagePath,
    this.detectedLanguage,
    this.isBuiltIn = false,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id, title, originalText;
  final String? ocrText,
      translation,
      transliteration,
      reference,
      notes,
      primaryCategoryId,
      imagePath,
      detectedLanguage;
  final bool isBuiltIn, isFavorite;
  final DateTime createdAt, updatedAt;
}

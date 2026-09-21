import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/dua.dart';

class DuaModel {
  static Dua fromRow(db.Dua r) => Dua(
    id: r.id,
    title: r.title,
    originalText: r.originalText,
    ocrText: r.ocrText,
    translation: r.translation,
    transliteration: r.transliteration,
    reference: r.reference,
    notes: r.notes,
    primaryCategoryId: r.primaryCategoryId,
    imagePath: r.imagePath,
    detectedLanguage: r.detectedLanguage,
    isBuiltIn: r.isBuiltIn,
    isFavorite: r.isFavorite,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );
}

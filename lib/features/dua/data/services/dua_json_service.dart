import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/database/app_database.dart';

abstract final class DuaJsonService {
  static Future<File?> writeSnapshot(AppDatabase db, String duaId) async {
    final dua = await (db.select(
      db.duas,
    )..where((row) => row.id.equals(duaId))).getSingleOrNull();
    if (dua == null) return null;
    final attachments = await (db.select(
      db.duaAttachments,
    )..where((row) => row.duaId.equals(duaId))).get();
    final category = dua.primaryCategoryId == null
        ? null
        : await (db.select(db.categories)
                ..where((row) => row.id.equals(dua.primaryCategoryId!)))
              .getSingleOrNull();
    final directory = Directory(
      p.join(
        (await getApplicationDocumentsDirectory()).path,
        'favorite_dua',
        'duas',
        duaId,
      ),
    );
    await directory.create(recursive: true);
    final document = <String, Object?>{
      'schemaVersion': 1,
      'id': dua.id,
      'title': dua.title,
      'category': category == null
          ? null
          : {'id': category.id, 'name': category.name},
      'dua': {
        'text': dua.originalText,
        'ocrText': dua.ocrText,
        'language': dua.detectedLanguage,
        'translation': dua.translation,
        'transliteration': dua.transliteration,
        'reference': dua.reference,
        'notes': dua.notes,
        'tags': dua.tagsText
            .split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(),
      },
      'media': {
        'imagePath': dua.imagePath,
        'voicePaths': [
          for (final item in attachments)
            if (item.kind == 'audio') item.value,
        ],
        'attachments': [
          for (final item in attachments)
            {
              'id': item.id,
              'kind': item.kind,
              'title': item.title,
              'location': item.value,
              'mimeType': item.mimeType,
              'durationMs': item.durationMs,
            },
        ],
      },
      'schedule': {
        'enabled': dua.scheduleEnabled,
        'hour': dua.scheduleHour,
        'minute': dua.scheduleMinute,
        'repeatCount': dua.scheduleRepeats,
        'mode': dua.scheduleMode,
      },
      'favorite': dua.isFavorite,
      'builtIn': dua.isBuiltIn,
      'createdAt': dua.createdAt.toIso8601String(),
      'updatedAt': dua.updatedAt.toIso8601String(),
    };
    final file = File(p.join(directory.path, 'dua.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(document),
      encoding: utf8,
      flush: true,
    );
    return file;
  }
}

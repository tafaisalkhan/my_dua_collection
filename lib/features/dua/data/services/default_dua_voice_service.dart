import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';

/// Creates and caches the device TTS voice for a Dua on first use.
class DefaultDuaVoiceService {
  DefaultDuaVoiceService(this._database, {FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  static const _uuid = Uuid();
  static final _idNamespace = Namespace.url.value;

  final AppDatabase _database;
  final FlutterTts _tts;

  String attachmentId(String duaId) =>
      _uuid.v5(_idNamespace, 'favorite-dua/default-voice/$duaId');

  Future<DuaAttachment> getOrCreate(Dua dua) async {
    final id = attachmentId(dua.id);
    final existing = await (_database.select(
      _database.duaAttachments,
    )..where((row) => row.id.equals(id))).getSingleOrNull();

    if (existing != null) {
      final cached = File(existing.value);
      if (await cached.exists() && await cached.length() > 0) return existing;
      if (existing.dataBlob case final bytes? when bytes.isNotEmpty) {
        await cached.parent.create(recursive: true);
        await cached.writeAsBytes(bytes, flush: true);
        return existing;
      }
    }

    final text = dua.originalText.trim();
    if (text.isEmpty) {
      throw StateError('This Dua has no text to read aloud.');
    }
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError(
        'On-device voice generation is currently available on Android and iOS.',
      );
    }

    final maxLength = Platform.isAndroid
        ? await _tts.getMaxSpeechInputLength
        : null;
    if (maxLength != null && text.length > maxLength) {
      throw StateError('This Dua is too long for the installed voice engine.');
    }

    final locale = _localeFor(dua.detectedLanguage, text);
    final available = await _tts.isLanguageAvailable(locale);
    if (available != true) {
      throw StateError(
        'Install the $locale text-to-speech voice in your device settings first.',
      );
    }

    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.42);
    // Android does not expose voice gender consistently. A lower pitch gives
    // the installed voice a deeper, male-style sound on engines without a
    // separately selectable male voice.
    await _tts.setPitch(0.72);
    await _tts.setVolume(1.0);
    await _tts.awaitSynthCompletion(true);

    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(
      p.join(documents.path, 'favorite_dua', 'duas', dua.id, 'generated_voice'),
    );
    await directory.create(recursive: true);
    final extension = Platform.isIOS ? '.caf' : '.wav';
    final output = File(p.join(directory.path, 'default$extension'));
    if (await output.exists()) await output.delete();

    final result = await _tts.synthesizeToFile(text, output.path, true);
    if (result != 1 || !await output.exists() || await output.length() == 0) {
      throw StateError('The device voice engine could not create the audio.');
    }

    final bytes = await output.readAsBytes();
    final now = DateTime.now();
    final companion = DuaAttachmentsCompanion.insert(
      id: id,
      duaId: dua.id,
      kind: 'audio',
      title: 'Default device voice',
      value: output.path,
      dataBlob: Value(bytes),
      mimeType: Value(Platform.isIOS ? 'audio/x-caf' : 'audio/wav'),
      createdAt: existing?.createdAt ?? now,
    );
    await _database
        .into(_database.duaAttachments)
        .insert(companion, mode: InsertMode.insertOrReplace);
    return await (_database.select(
      _database.duaAttachments,
    )..where((row) => row.id.equals(id))).getSingle();
  }

  Future<void> cancel() => _tts.stop();

  String _localeFor(String? language, String text) {
    final code = language?.toLowerCase();
    if (code == 'ur') return 'ur-PK';
    if (code == 'ar' || RegExp(r'[\u0600-\u06ff]').hasMatch(text)) {
      return 'ar-SA';
    }
    return 'en-US';
  }
}

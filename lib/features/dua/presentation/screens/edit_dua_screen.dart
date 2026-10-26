import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/audio/audio_playback_coordinator.dart';
import '../../../../core/database/app_database.dart';
import '../../data/services/dua_audio_schedule_service.dart';
import '../../data/services/dua_json_service.dart';

class EditDuaScreen extends ConsumerStatefulWidget {
  const EditDuaScreen({
    super.key,
    this.isEditing = false,
    this.duaId,
    this.initialText,
    this.initialLink,
    this.libraryItemId,
    this.croppedPath,
  });

  final bool isEditing;
  final String? duaId;
  final String? initialText;
  final String? initialLink;
  final String? libraryItemId;
  final String? croppedPath;

  @override
  ConsumerState<EditDuaScreen> createState() => _EditDuaScreenState();
}

class _ExtraAttachment {
  const _ExtraAttachment(this.kind, this.title, this.value);
  final String kind;
  final String title;
  final String value;
}

class _EditDuaScreenState extends ConsumerState<EditDuaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _duaText = TextEditingController();
  final _translation = TextEditingController();
  final _reference = TextEditingController();
  final _tags = TextEditingController();
  final _notes = TextEditingController();
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  final _imageTransformController = TransformationController();
  final _extras = <_ExtraAttachment>[];
  Timer? _timer;
  String? _audioPath;
  String? _imagePath;
  bool _audioTemporary = false;
  bool _recording = false;
  bool _saving = false;
  Duration _elapsed = Duration.zero;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  int _repeats = 3;
  bool _scheduleEnabled = false;
  String _category = 'Morning';
  String _scheduleMode = 'both';
  List<Category> _categories = const [];

  @override
  void initState() {
    super.initState();
    AudioPlaybackCoordinator.instance.register(_player);
    _imagePath = widget.croppedPath;
    _title.text = 'My Dua';
    _duaText.text = widget.initialText ?? '';
    final shared = widget.initialLink;
    if (shared != null) {
      final match = RegExp(r'https?://[^\s]+').firstMatch(shared);
      final link = match?.group(0);
      if (link != null) {
        final uri = Uri.tryParse(link);
        final host = uri?.host.toLowerCase() ?? '';
        final youtube =
            host == 'youtube.com' ||
            host.endsWith('.youtube.com') ||
            host == 'youtu.be' ||
            host.endsWith('.youtu.be');
        _extras.add(
          _ExtraAttachment(
            youtube ? 'youtube' : 'link',
            youtube ? 'YouTube video' : (uri?.host ?? 'Website'),
            link,
          ),
        );
      }
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadCategories();
    if (!widget.isEditing || widget.duaId == null) return;
    final db = ref.read(appDatabaseProvider);
    final dua = await (db.select(
      db.duas,
    )..where((row) => row.id.equals(widget.duaId!))).getSingleOrNull();
    if (dua == null) return;
    final attachments = await (db.select(
      db.duaAttachments,
    )..where((row) => row.duaId.equals(dua.id))).get();
    final category = dua.primaryCategoryId == null
        ? null
        : await (db.select(db.categories)
                ..where((row) => row.id.equals(dua.primaryCategoryId!)))
              .getSingleOrNull();
    String? audioPath;
    for (final item in attachments) {
      if (item.kind == 'audio') {
        audioPath = item.value;
        break;
      }
    }
    if (!mounted) return;
    setState(() {
      _title.text = dua.title;
      _duaText.text = dua.originalText;
      _translation.text = dua.translation ?? '';
      _reference.text = dua.reference ?? '';
      _tags.text = dua.tagsText;
      _notes.text = dua.notes ?? '';
      _extras
        ..clear()
        ..addAll(
          attachments
              .where((item) => !['audio', 'image'].contains(item.kind))
              .map(
                (item) => _ExtraAttachment(item.kind, item.title, item.value),
              ),
        );
      _category = category?.name ?? _category;
      _imagePath = dua.imagePath;
      _audioPath = audioPath;
      _scheduleEnabled = dua.scheduleEnabled;
      _time = TimeOfDay(
        hour: dua.scheduleHour ?? 8,
        minute: dua.scheduleMinute ?? 0,
      );
      _repeats = dua.scheduleRepeats;
      _scheduleMode = dua.scheduleMode ?? 'notification';
    });
  }

  Future<void> _loadCategories() async {
    final db = ref.read(appDatabaseProvider);
    final rows =
        await (db.select(db.categories)..orderBy([
              (row) => OrderingTerm.asc(row.sortOrder),
              (row) => OrderingTerm.asc(row.name),
            ]))
            .get();
    if (!mounted) return;
    setState(() {
      _categories = rows;
      if (rows.isNotEmpty && !rows.any((item) => item.name == _category)) {
        _category = rows.first.name;
      }
    });
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final path = await _recorder.stop();
      _timer?.cancel();
      if (mounted) {
        setState(() {
          _recording = false;
          if (path != null) {
            _audioPath = path;
            _audioTemporary = true;
            if (_scheduleEnabled) _scheduleMode = 'both';
          }
        });
      }
      return;
    }
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required.')),
        );
      }
      return;
    }
    await _discardAudio();
    final temp = await getTemporaryDirectory();
    final path = p.join(temp.path, 'dua_voice_${const Uuid().v4()}.m4a');
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
        autoGain: true,
        noiseSuppress: true,
        echoCancel: true,
      ),
      path: path,
    );
    _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
    if (mounted) setState(() => _recording = true);
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);
    final path = result.isEmpty ? null : result.first.path;
    if (path == null) return;
    await _discardAudio();
    if (mounted) {
      setState(() {
        _audioPath = path;
        if (_scheduleEnabled) _scheduleMode = 'both';
      });
    }
  }

  Future<void> _previewAudio() async {
    final path = _audioPath;
    if (path == null) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      await AudioPlaybackCoordinator.instance.stopOthers(_player);
      await _player.setFilePath(path);
      await _player.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _discardAudio() async {
    await _player.stop();
    final path = _audioPath;
    if (_audioTemporary && path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    if (mounted) {
      setState(() {
        _audioPath = null;
        _audioTemporary = false;
        if (['play', 'both'].contains(_scheduleMode)) {
          _scheduleMode = 'notification';
        }
      });
    }
  }

  Future<void> _pickExtra(String kind) async {
    final result = await FilePicker.pickFiles(
      type: kind == 'video' ? FileType.video : FileType.any,
    );
    final file = result.isEmpty ? null : result.first;
    if (file?.path == null) return;
    setState(() => _extras.add(_ExtraAttachment(kind, file!.name, file.path!)));
  }

  Future<void> _addLink() async {
    var draft = '';
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add YouTube or website link'),
        content: TextField(
          autofocus: true,
          onChanged: (text) => draft = text,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(hintText: 'https://...'),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(draft.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    final raw = (value ?? '').trim();
    if (raw.isEmpty) return;
    final normalized = RegExp(r'^https?://', caseSensitive: false).hasMatch(raw)
        ? raw
        : 'https://$raw';
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid website address.')),
        );
      }
      return;
    }
    final host = uri.host.toLowerCase();
    final youtube =
        host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtu.be' ||
        host.endsWith('.youtu.be');
    setState(
      () => _extras.add(
        _ExtraAttachment(
          youtube ? 'youtube' : 'link',
          youtube ? 'YouTube video' : uri.host,
          normalized,
        ),
      ),
    );
  }

  Future<void> _chooseTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (selected != null && mounted) setState(() => _time = selected);
  }

  Future<void> _saveExisting() async {
    final id = widget.duaId!;
    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final category = await (db.select(
        db.categories,
      )..where((row) => row.name.equals(_category))).getSingleOrNull();

      final base = Directory(
        p.join(
          (await getApplicationDocumentsDirectory()).path,
          'favorite_dua',
          'duas',
          id,
        ),
      );
      await base.create(recursive: true);

      // Handle audio attachment sync
      final existingAudioAttachment =
          await (db.select(db.duaAttachments)
                ..where((row) => row.duaId.equals(id))
                ..where((row) => row.kind.equals('audio')))
              .getSingleOrNull();

      String? finalAudioPath;

      if (_audioPath == null) {
        if (existingAudioAttachment != null) {
          final oldFile = File(existingAudioAttachment.value);
          if (await oldFile.exists() && oldFile.path.contains('favorite_dua')) {
            await oldFile.delete();
          }
          await (db.delete(
            db.duaAttachments,
          )..where((row) => row.id.equals(existingAudioAttachment.id))).go();
        }
      } else {
        if (existingAudioAttachment != null &&
            existingAudioAttachment.value == _audioPath) {
          finalAudioPath = _audioPath;
        } else {
          final sourceAudio = File(_audioPath!);
          if (await sourceAudio.exists()) {
            final targetPath = p.join(
              base.path,
              'voice_${const Uuid().v4()}${p.extension(sourceAudio.path)}',
            );
            final savedAudioFile = await sourceAudio.copy(targetPath);
            finalAudioPath = savedAudioFile.path;

            if (existingAudioAttachment != null) {
              final oldFile = File(existingAudioAttachment.value);
              if (await oldFile.exists() &&
                  oldFile.path.contains('favorite_dua')) {
                await oldFile.delete();
              }
              await (db.delete(db.duaAttachments)
                    ..where((row) => row.id.equals(existingAudioAttachment.id)))
                  .go();
            }

            Uint8List? audioBytes;
            final audioFile = File(finalAudioPath);
            if (await audioFile.exists()) {
              audioBytes = await audioFile.readAsBytes();
            }
            await db
                .into(db.duaAttachments)
                .insert(
                  DuaAttachmentsCompanion.insert(
                    id: const Uuid().v4(),
                    duaId: id,
                    kind: 'audio',
                    title: 'Dua voice',
                    value: finalAudioPath,
                    dataBlob: Value(audioBytes),
                    mimeType: const Value('audio/mp4'),
                    createdAt: DateTime.now(),
                  ),
                );
          }
        }
      }

      // Handle extra attachments sync
      final existingAttachments = await (db.select(
        db.duaAttachments,
      )..where((row) => row.duaId.equals(id))).get();

      final existingExtrasInDb = existingAttachments
          .where((a) => !['audio', 'image'].contains(a.kind))
          .toList();

      for (final oldExtra in existingExtrasInDb) {
        final matchesInExtras = _extras.any(
          (e) => e.value == oldExtra.value && e.kind == oldExtra.kind,
        );
        if (!matchesInExtras) {
          if (!['link', 'youtube'].contains(oldExtra.kind)) {
            final oldFile = File(oldExtra.value);
            if (await oldFile.exists() &&
                oldFile.path.contains('favorite_dua')) {
              await oldFile.delete();
            }
          }
          await (db.delete(
            db.duaAttachments,
          )..where((row) => row.id.equals(oldExtra.id))).go();
        }
      }

      for (final extra in _extras) {
        final alreadyInDb = existingExtrasInDb.any(
          (e) => e.value == extra.value && e.kind == extra.kind,
        );
        if (!alreadyInDb) {
          var storedValue = extra.value;
          if (!['link', 'youtube'].contains(extra.kind)) {
            final source = File(extra.value);
            if (await source.exists()) {
              storedValue = (await source.copy(
                p.join(
                  base.path,
                  '${const Uuid().v4()}${p.extension(source.path)}',
                ),
              )).path;
            }
          }
          Uint8List? extraBytes;
          if (!['link', 'youtube'].contains(extra.kind)) {
            final f = File(storedValue);
            if (await f.exists()) extraBytes = await f.readAsBytes();
          }
          await db
              .into(db.duaAttachments)
              .insert(
                DuaAttachmentsCompanion.insert(
                  id: const Uuid().v4(),
                  duaId: id,
                  kind: extra.kind,
                  title: extra.title,
                  value: storedValue,
                  dataBlob: Value(extraBytes),
                  createdAt: DateTime.now(),
                ),
              );
        }
      }

      await (db.update(db.duas)..where((row) => row.id.equals(id))).write(
        DuasCompanion(
          title: Value(_title.text.trim()),
          originalText: Value(_duaText.text.trim()),
          translation: Value(_nullableText(_translation)),
          reference: Value(_nullableText(_reference)),
          tagsText: Value(_tags.text.trim()),
          notes: Value(_nullableText(_notes)),
          primaryCategoryId: Value(category?.id),
          scheduleEnabled: Value(_scheduleEnabled),
          scheduleHour: Value(_scheduleEnabled ? _time.hour : null),
          scheduleMinute: Value(_scheduleEnabled ? _time.minute : null),
          scheduleRepeats: Value(_repeats),
          scheduleMode: Value(_scheduleEnabled ? _scheduleMode : null),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await DuaAudioScheduleService.cancel(id);
      if (_scheduleEnabled) {
        if (['notification', 'both'].contains(_scheduleMode)) {
          await DuaAudioScheduleService.requestNotificationPermission();
        }
        await DuaAudioScheduleService.schedule(
          id: id,
          title: _title.text.trim(),
          audioPath: finalAudioPath,
          hour: _time.hour,
          minute: _time.minute,
          repeats: _repeats,
          mode: _scheduleMode,
          category: _category,
          duaText: _duaText.text.trim(),
        );
      }
      await DuaJsonService.writeSnapshot(db, id);
      if (mounted) {
        if (_scheduleEnabled) {
          context.go('/home');
        } else {
          context.go('/dua/$id');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not update Dua: $error')));
      }
    }
  }

  Future<void> _save() async {
    if (_recording) await _toggleRecording();
    if (!_formKey.currentState!.validate()) return;

    if (_scheduleEnabled &&
        ['play', 'both'].contains(_scheduleMode) &&
        _audioPath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attach a voice for Play or Both mode.')),
      );
      return;
    }
    if (widget.isEditing && widget.duaId != null) {
      await _saveExisting();
      return;
    }
    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final id = const Uuid().v4();
      final now = DateTime.now();
      final base = Directory(
        p.join(
          (await getApplicationDocumentsDirectory()).path,
          'favorite_dua',
          'duas',
          id,
        ),
      );
      await base.create(recursive: true);

      String? savedImage;
      final crop = widget.croppedPath;
      if (crop != null && await File(crop).exists()) {
        savedImage = (await File(crop).copy(p.join(base.path, 'dua.png'))).path;
      }
      String? savedAudio;
      if (_audioPath != null) {
        final sourceAudio = File(_audioPath!);
        savedAudio = (await sourceAudio.copy(
          p.join(base.path, 'voice${p.extension(sourceAudio.path)}'),
        )).path;
      }

      final category = await (db.select(
        db.categories,
      )..where((row) => row.name.equals(_category))).getSingleOrNull();
      Uint8List? imageBytes;
      if (savedImage != null && await File(savedImage).exists()) {
        imageBytes = await File(savedImage).readAsBytes();
      }
      await db
          .into(db.duas)
          .insert(
            DuasCompanion.insert(
              id: id,
              title: _title.text.trim(),
              originalText: _duaText.text.trim(),
              translation: Value(_nullableText(_translation)),
              reference: Value(_nullableText(_reference)),
              tagsText: Value(_tags.text.trim()),
              notes: Value(_nullableText(_notes)),
              imagePath: Value(savedImage),
              imageBlob: Value(imageBytes),
              primaryCategoryId: Value(category?.id),
              scheduleEnabled: Value(_scheduleEnabled),
              scheduleHour: Value(_scheduleEnabled ? _time.hour : null),
              scheduleMinute: Value(_scheduleEnabled ? _time.minute : null),
              scheduleRepeats: Value(_repeats),
              scheduleMode: Value(_scheduleEnabled ? _scheduleMode : null),
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (savedAudio != null) {
        Uint8List? audioBytes;
        if (await File(savedAudio).exists()) {
          audioBytes = await File(savedAudio).readAsBytes();
        }
        await db
            .into(db.duaAttachments)
            .insert(
              DuaAttachmentsCompanion.insert(
                id: const Uuid().v4(),
                duaId: id,
                kind: 'audio',
                title: 'Dua voice',
                value: savedAudio,
                dataBlob: Value(audioBytes),
                mimeType: const Value('audio/mp4'),
                createdAt: now,
              ),
            );
      }
      if (savedImage != null) {
        await db
            .into(db.duaAttachments)
            .insert(
              DuaAttachmentsCompanion.insert(
                id: const Uuid().v4(),
                duaId: id,
                kind: 'image',
                title: 'Cropped Dua image',
                value: savedImage,
                dataBlob: Value(imageBytes),
                mimeType: const Value('image/png'),
                createdAt: now,
              ),
            );
      }
      for (final attachment in _extras) {
        var storedValue = attachment.value;
        if (!['link', 'youtube'].contains(attachment.kind)) {
          final source = File(attachment.value);
          storedValue = (await source.copy(
            p.join(
              base.path,
              '${const Uuid().v4()}${p.extension(source.path)}',
            ),
          )).path;
        }
        Uint8List? extraBytes;
        if (!['link', 'youtube'].contains(attachment.kind)) {
          final f = File(storedValue);
          if (await f.exists()) extraBytes = await f.readAsBytes();
        }
        await db
            .into(db.duaAttachments)
            .insert(
              DuaAttachmentsCompanion.insert(
                id: const Uuid().v4(),
                duaId: id,
                kind: attachment.kind,
                title: attachment.title,
                value: storedValue,
                dataBlob: Value(extraBytes),
                createdAt: now,
              ),
            );
      }
      if (_scheduleEnabled &&
          ['notification', 'both'].contains(_scheduleMode)) {
        await DuaAudioScheduleService.requestNotificationPermission();
      }
      if (_scheduleEnabled) {
        await DuaAudioScheduleService.schedule(
          id: id,
          title: _title.text.trim(),
          audioPath: savedAudio,
          hour: _time.hour,
          minute: _time.minute,
          repeats: _repeats,
          mode: _scheduleMode,
          category: _category,
          duaText: _duaText.text.trim(),
        );
      }
      await DuaJsonService.writeSnapshot(db, id);
      _audioTemporary = false;
      if (mounted) {
        if (_scheduleEnabled) {
          context.go('/home');
        } else {
          context.go('/dua/$id');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save Dua: $error')));
      }
    }
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  String _duration(Duration value) =>
      '${value.inMinutes.toString().padLeft(2, '0')}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    AudioPlaybackCoordinator.instance.unregister(_player);
    _timer?.cancel();
    unawaited(_recorder.dispose());
    unawaited(_player.dispose());
    _title.dispose();
    _duaText.dispose();
    _translation.dispose();
    _reference.dispose();
    _tags.dispose();
    _notes.dispose();
    _imageTransformController.dispose();
    super.dispose();
  }

  void _zoomImageIn() {
    FocusManager.instance.primaryFocus?.unfocus();
    final matrix = _imageTransformController.value.clone();
    matrix.scaleByDouble(1.25, 1.25, 1.0, 1.0);
    _imageTransformController.value = matrix;
  }

  void _zoomImageOut() {
    FocusManager.instance.primaryFocus?.unfocus();
    final matrix = _imageTransformController.value.clone();
    matrix.scaleByDouble(0.8, 0.8, 1.0, 1.0);
    _imageTransformController.value = matrix;
  }

  void _resetImageZoom() {
    FocusManager.instance.primaryFocus?.unfocus();
    _imageTransformController.value = Matrix4.identity();
  }

  void _openFullScreenImage(String path) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 8.0,
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pinch to zoom in / out',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _imagePath;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Dua' : 'Save Cropped Dua'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            if (imagePath != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withValues(alpha: 0.05),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Interactive Zoomable Image with tap-to-unfocus
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        child: Container(
                          height: 280,
                          width: double.infinity,
                          color: Colors.black12,
                          child: InteractiveViewer(
                            transformationController: _imageTransformController,
                            minScale: 0.8,
                            maxScale: 6.0,
                            clipBehavior: Clip.none,
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Center(
                                child: Text('Image could not be loaded'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Floating Zoom & Fullscreen Toolbar
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                tooltip: 'Zoom Out',
                                onPressed: _zoomImageOut,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                tooltip: 'Reset Zoom',
                                onPressed: _resetImageZoom,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                tooltip: 'Zoom In',
                                onPressed: _zoomImageIn,
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                tooltip: 'Fullscreen View',
                                onPressed: () =>
                                    _openFullScreenImage(imagePath),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom label
                      Positioned(
                        bottom: 8,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pinch or use +/- to zoom',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Dua name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a name for this Dua'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _duaText,
              minLines: 3,
              maxLines: 8,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'Dua text',
                hintText: 'Enter or paste Dua text',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _translation,
              minLines: 2,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Translation',
                hintText: 'Enter the Dua translation',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _reference,
              decoration: const InputDecoration(
                labelText: 'Reference',
                hintText: 'For example: Qur’an 2:201 or Sahih Muslim 2708',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'Separate tags with commas',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add personal notes',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.name,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _category = value ?? 'Morning';
              }),
            ),
            const SizedBox(height: 20),
            Text('Voice', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _saving ? null : _toggleRecording,
              style: _recording
                  ? FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    )
                  : null,
              icon: Icon(_recording ? Icons.stop : Icons.mic),
              label: Text(
                _recording
                    ? 'Stop recording ${_duration(_elapsed)}'
                    : 'Record voice',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pickAudio,
              icon: const Icon(Icons.audio_file),
              label: const Text('Choose voice from phone'),
            ),
            if (_audioPath != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.graphic_eq),
                  title: const Text('Voice ready'),
                  subtitle: Text(p.basename(_audioPath!)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _previewAudio,
                        icon: Icon(
                          _player.playing ? Icons.pause : Icons.play_arrow,
                        ),
                      ),
                      IconButton(
                        onPressed: _discardAudio,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'More attachments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _saving ? null : () => _pickExtra('video'),
                  icon: const Icon(Icons.video_file),
                  label: const Text('Video'),
                ),
                OutlinedButton.icon(
                  onPressed: _saving ? null : () => _pickExtra('document'),
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Document'),
                ),
                OutlinedButton.icon(
                  onPressed: _saving ? null : _addLink,
                  icon: const Icon(Icons.link),
                  label: const Text('YouTube / Website'),
                ),
              ],
            ),
            for (var index = 0; index < _extras.length; index++)
              Card(
                child: ListTile(
                  leading: Icon(switch (_extras[index].kind) {
                    'video' => Icons.video_file,
                    'document' => Icons.description_outlined,
                    'youtube' => Icons.smart_display,
                    _ => Icons.language,
                  }),
                  title: Text(_extras[index].title),
                  subtitle: Text(_extras[index].kind),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _extras.removeAt(index)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _scheduleEnabled,
              onChanged: (value) => setState(() {
                _scheduleEnabled = value;
                if (value) {
                  _scheduleMode = _audioPath == null ? 'notification' : 'both';
                }
              }),
              title: const Text('Schedule this Dua'),
              subtitle: const Text(
                'Choose notification, voice playback, or both',
              ),
            ),
            if (_scheduleEnabled) ...[
              DropdownButtonFormField<String>(
                initialValue: _scheduleMode,
                decoration: const InputDecoration(
                  labelText: 'At scheduled time',
                ),
                items: [
                  const DropdownMenuItem(
                    value: 'notification',
                    child: Text('Show one notification only'),
                  ),
                  DropdownMenuItem(
                    value: 'play',
                    enabled: _audioPath != null,
                    child: const Text('Play Dua voice'),
                  ),
                  DropdownMenuItem(
                    value: 'both',
                    enabled: _audioPath != null,
                    child: const Text('Play voice and show one notification'),
                  ),
                ],
                onChanged: (value) => setState(() {
                  _scheduleMode = value ?? 'notification';
                }),
              ),
              if (_audioPath == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Attach a voice to enable voice playback.',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: const Text('Daily time'),
                subtitle: Text(_time.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: _chooseTime,
              ),
              DropdownButtonFormField<int>(
                initialValue: _repeats,
                decoration: const InputDecoration(labelText: 'Repeat voice'),
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} time${index == 0 ? '' : 's'}'),
                  ),
                ),
                onChanged: (value) => setState(() => _repeats = value ?? 3),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(_saving ? 'Saving...' : 'Save Dua'),
      ),
    );
  }
}

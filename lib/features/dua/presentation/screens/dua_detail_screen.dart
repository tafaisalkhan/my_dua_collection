import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/dua_palette.dart';
import '../../data/services/dua_audio_schedule_service.dart';
import '../widgets/dua_text_view.dart';

class DuaDetailScreen extends ConsumerStatefulWidget {
  const DuaDetailScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<DuaDetailScreen> createState() => _DuaDetailState();
}

class _DuaDetailState extends ConsumerState<DuaDetailScreen> {
  final player = AudioPlayer();
  String? playing;
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<(Dua?, List<DuaAttachment>, String?)> _load() async {
    final db = ref.read(appDatabaseProvider);
    final dua = await (db.select(
      db.duas,
    )..where((t) => t.id.equals(widget.id))).getSingleOrNull();
    final files = await (db.select(
      db.duaAttachments,
    )..where((t) => t.duaId.equals(widget.id))).get();
    final category = dua?.primaryCategoryId == null
        ? null
        : await (db.select(db.categories)
                ..where((row) => row.id.equals(dua!.primaryCategoryId!)))
              .getSingleOrNull();
    return (dua, files, category?.name);
  }

  Future<void> _toggleFavorite(Dua dua) async {
    final db = ref.read(appDatabaseProvider);
    await (db.update(db.duas)..where((row) => row.id.equals(dua.id))).write(
      DuasCompanion(
        isFavorite: Value(!dua.isFavorite),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          dua.isFavorite ? 'Removed from Favorites.' : 'Added to Favorites.',
        ),
      ),
    );
  }

  Future<void> _deleteDua(Dua dua, List<DuaAttachment> attachments) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this Dua?'),
        content: Text(
          '“${dua.title}” and all of its saved attachments will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            child: const Text('Delete Dua'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await player.stop();
    await DuaAudioScheduleService.cancel(dua.id);
    for (final attachment in attachments) {
      if (['link', 'youtube'].contains(attachment.kind)) continue;
      final file = File(attachment.value);
      if (await file.exists()) await file.delete();
    }
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.duas)..where((row) => row.id.equals(dua.id))).go();
    if (mounted) context.pop();
  }

  Future<void> _open(DuaAttachment a) async {
    if (['link', 'youtube'].contains(a.kind)) {
      if (mounted) {
        context.push(
          Uri(
            path: '/view/web',
            queryParameters: {'url': a.value, 'title': a.title},
          ).toString(),
        );
      }
      return;
    }
    if (a.kind == 'document') {
      if (mounted) {
        context.push(
          Uri(
            path: '/view/document',
            queryParameters: {'path': a.value, 'title': a.title},
          ).toString(),
        );
      }
      return;
    }
    if (a.kind == 'audio') {
      if (playing == a.id && player.playing) {
        await player.pause();
      } else {
        await player.setFilePath(a.value);
        playing = a.id;
        await player.play();
      }
      if (mounted) setState(() {});
      return;
    }
    await OpenFilex.open(a.value);
  }

  Future<void> _addLink() async {
    var draft = '';
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add website link'),
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
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add YouTube videos using Share in the YouTube app.'),
          ),
        );
      }
      return;
    }
    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.duaAttachments)
        .insert(
          DuaAttachmentsCompanion.insert(
            id: const Uuid().v4(),
            duaId: widget.id,
            kind: 'link',
            title: uri.host,
            value: normalized,
            createdAt: DateTime.now(),
          ),
        );
    if (mounted) setState(() {});
  }

  Future<void> _addDocument() async {
    final result = await FilePicker.pickFiles(type: FileType.any);
    final picked = result.isEmpty ? null : result.first;
    if (picked?.path == null) return;
    final source = File(picked!.path!);
    final base = Directory(
      p.join(
        (await getApplicationDocumentsDirectory()).path,
        'favorite_dua',
        'duas',
        widget.id,
      ),
    );
    await base.create(recursive: true);
    final stored = await source.copy(
      p.join(base.path, '${const Uuid().v4()}${p.extension(source.path)}'),
    );
    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.duaAttachments)
        .insert(
          DuaAttachmentsCompanion.insert(
            id: const Uuid().v4(),
            duaId: widget.id,
            kind: 'document',
            title: picked.name,
            value: stored.path,
            createdAt: DateTime.now(),
          ),
        );
    if (mounted) setState(() {});
  }

  Future<void> _deleteAttachment(DuaAttachment attachment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete attachment?'),
        content: Text('Remove ${attachment.title}?'),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!['link', 'youtube'].contains(attachment.kind)) {
      final file = File(attachment.value);
      if (await file.exists()) await file.delete();
    }
    final db = ref.read(appDatabaseProvider);
    await (db.delete(
      db.duaAttachments,
    )..where((row) => row.id.equals(attachment.id))).go();
    if (mounted) setState(() {});
  }

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<(Dua?, List<DuaAttachment>, String?)>(
    future: _load(),
    builder: (context, s) {
      if (!s.hasData)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final dua = s.data!.$1, files = s.data!.$2, categoryName = s.data!.$3;
      if (dua == null)
        return const Scaffold(body: Center(child: Text('Dua not found')));
      final duaColor = DuaPalette.forCategory(categoryName ?? dua.id);
      return Scaffold(
        backgroundColor: duaColor,
        appBar: AppBar(
          backgroundColor: duaColor,
          foregroundColor: Colors.black87,
          title: Text(dua.title),
          actions: [
            IconButton(
              tooltip: dua.isFavorite
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
              icon: Icon(
                dua.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () => _toggleFavorite(dua),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => SharePlus.instance.share(
                ShareParams(
                  title: dua.title,
                  text: '${dua.title}\n\n${dua.originalText}',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/dua/${dua.id}/edit'),
            ),
            IconButton(
              tooltip: 'Delete Dua',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteDua(dua, files),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (files.any((item) => item.kind == 'image')) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 420),
                  width: double.infinity,
                  color: Colors.black12,
                  child: Image.file(
                    File(
                      files.firstWhere((item) => item.kind == 'image').value,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (dua.originalText.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DuaTextView(
                    dua.originalText,
                    languageCode: dua.detectedLanguage,
                  ),
                ),
              ),
            if (dua.translation?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 16),
              Text(
                'Translation',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    dua.translation!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
            if (dua.tagsText.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: dua.tagsText
                    .split(',')
                    .map((x) => Chip(label: Text(x.trim())))
                    .toList(),
              ),
            ],
            if (dua.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(dua.notes!),
            ],
            const SizedBox(height: 20),
            if (dua.scheduleEnabled &&
                dua.scheduleHour != null &&
                dua.scheduleMinute != null) ...[
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    'Daily at ${TimeOfDay(hour: dua.scheduleHour!, minute: dua.scheduleMinute!).format(context)}',
                  ),
                  subtitle: Text(
                    '${switch (dua.scheduleMode) {
                      'play' => 'Play Dua voice',
                      'both' => 'Play voice and show one notification',
                      _ => 'Show one notification only',
                    }} · Voice repeats ${dua.scheduleRepeats} time${dua.scheduleRepeats == 1 ? '' : 's'}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Attachments',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _addLink,
                  icon: const Icon(Icons.add_link),
                  label: const Text('Add link'),
                ),
                OutlinedButton.icon(
                  onPressed: _addDocument,
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Add document'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (files.isEmpty)
              const Text(
                'No attachments',
                style: TextStyle(color: Colors.black87),
              ),
            for (final a in files.where((item) => item.kind != 'image'))
              Card(
                child: ListTile(
                  leading: Icon(
                    a.kind == 'audio'
                        ? Icons.audio_file
                        : a.kind == 'youtube'
                        ? Icons.smart_display
                        : a.kind == 'link'
                        ? Icons.link
                        : a.kind == 'image'
                        ? Icons.image
                        : Icons.attach_file,
                  ),
                  title: Text(a.title),
                  subtitle: Text(a.kind),
                  onTap: () => _open(a),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Share',
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () => ['link', 'youtube'].contains(a.kind)
                            ? SharePlus.instance.share(
                                ShareParams(text: a.value),
                              )
                            : SharePlus.instance.share(
                                ShareParams(files: [XFile(a.value)]),
                              ),
                      ),
                      IconButton(
                        tooltip: 'Delete attachment',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteAttachment(a),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

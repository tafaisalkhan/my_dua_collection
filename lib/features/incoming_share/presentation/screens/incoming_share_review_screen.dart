import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../media_library/presentation/controllers/media_library_controller.dart';
import '../controllers/incoming_share_queue.dart';

class IncomingShareReviewScreen extends ConsumerWidget {
  const IncomingShareReviewScreen({super.key});
  void _remove(WidgetRef ref, IncomingShareEntry item) {
    ref.read(incomingShareQueueProvider.notifier).state = [
      for (final value in ref.read(incomingShareQueueProvider))
        if (value.path != item.path) value,
    ];
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    IncomingShareEntry item,
  ) async {
    _remove(ref, item);
    if (item.isImage) {
      context.push('/add/crop?path=${Uri.encodeComponent(item.path)}');
      return;
    }
    if (item.isText) {
      final hasLink = RegExp(r'https?://[^\\s]+').hasMatch(item.path);
      final parameter = hasLink ? 'sharedLink' : 'ocrText';
      context.push(
        '/add/manual?' + parameter + '=' + Uri.encodeComponent(item.path),
      );
      return;
    }
    final id = await ref.read(mediaRepositoryProvider).importOne(item.path);
    if (id != null && context.mounted)
      context.push('/add/manual?libraryItemId=$id');
  }

  Future<void> _addTextToExisting(
    BuildContext context,
    WidgetRef ref,
    IncomingShareEntry item, {
    required bool asTranslation,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final duas = await db.select(db.duas).get();
    duas.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    if (!context.mounted) return;
    final duaId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(
          asTranslation
              ? 'Add translation to which Dua?'
              : 'Add Arabic/Dua text to which Dua?',
        ),
        children: [
          if (duas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No saved Duas found. Create the Dua first.'),
            ),
          for (final dua in duas)
            SimpleDialogOption(
              onPressed: () => dialogContext.pop(dua.id),
              child: Text(dua.title),
            ),
        ],
      ),
    );
    if (duaId == null) return;
    final dua = duas.firstWhere((value) => value.id == duaId);
    final sharedText = item.path.trim();
    if (asTranslation) {
      final current = dua.translation?.trim() ?? '';
      await (db.update(db.duas)..where((row) => row.id.equals(duaId))).write(
        DuasCompanion(
          translation: Value(
            current.isEmpty ? sharedText : '$current\n\n$sharedText',
          ),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      final current = dua.originalText.trim();
      await (db.update(db.duas)..where((row) => row.id.equals(duaId))).write(
        DuasCompanion(
          originalText: Value(
            current.isEmpty ? sharedText : '$current\n\n$sharedText',
          ),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
    _remove(ref, item);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            asTranslation
                ? 'Translation added to the selected Dua.'
                : 'Dua text added to the selected Dua.',
          ),
        ),
      );
      context.push('/dua/$duaId');
    }
  }

  Future<void> _attachToExisting(
    BuildContext context,
    WidgetRef ref,
    IncomingShareEntry item,
  ) async {
    final link = RegExp(r'https?://[^\s]+').firstMatch(item.path)?.group(0);
    if (link == null) return;
    final db = ref.read(appDatabaseProvider);
    final duas = await db.select(db.duas).get();
    duas.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    if (!context.mounted) return;
    final duaId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Attach to existing Dua'),
        children: [
          if (duas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No saved Duas found.'),
            ),
          for (final dua in duas)
            SimpleDialogOption(
              onPressed: () => dialogContext.pop(dua.id),
              child: Text(dua.title),
            ),
        ],
      ),
    );
    if (duaId == null) return;
    final uri = Uri.tryParse(link);
    final youtube =
        uri?.host.contains('youtube.com') == true ||
        uri?.host.contains('youtu.be') == true;
    await db
        .into(db.duaAttachments)
        .insert(
          DuaAttachmentsCompanion.insert(
            id: const Uuid().v4(),
            duaId: duaId,
            kind: youtube ? 'youtube' : 'link',
            title: youtube ? 'YouTube video' : (uri?.host ?? 'Website'),
            value: link,
            createdAt: DateTime.now(),
          ),
        );
    _remove(ref, item);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link attached to existing Dua.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(incomingShareQueueProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared items (${items.length})'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () =>
                  ref.read(incomingShareQueueProvider.notifier).state = [],
              child: const Text('Discard all'),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.done_all, size: 64),
                  const SizedBox(height: 12),
                  const Text('All shared items were handled.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        item.isImage
                            ? Icons.image_outlined
                            : item.isText
                            ? Icons.smart_display
                            : Icons.picture_as_pdf_outlined,
                      ),
                    ),
                    title: Text(item.path.split(RegExp(r'[/\\]')).last),
                    subtitle: Text(
                      item.isImage
                          ? 'Image • crop before creating Dua'
                          : item.isText
                          ? item.path
                          : 'PDF • attach to new Dua',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'create') {
                          _create(context, ref, item);
                        } else if (value == 'attach') {
                          _attachToExisting(context, ref, item);
                        } else {
                          _remove(ref, item);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'create',
                          child: Text('Create separate Dua'),
                        ),
                        if (item.isText &&
                            RegExp(r'https?://[^\s]+').hasMatch(item.path))
                          const PopupMenuItem(
                            value: 'attach',
                            child: Text('Attach link to existing Dua'),
                          ),
                        if (item.isText &&
                            !RegExp(
                              r'https?://[^\s]+',
                            ).hasMatch(item.path)) ...[
                          const PopupMenuItem(
                            value: 'dua_text',
                            child: Text('Add as Arabic/Dua text'),
                          ),
                          const PopupMenuItem(
                            value: 'translation',
                            child: Text('Add as translation'),
                          ),
                        ],
                        const PopupMenuItem(
                          value: 'discard',
                          child: Text('Discard'),
                        ),
                      ],
                    ),
                    onTap: () => _create(context, ref, item),
                  ),
                );
              },
            ),
    );
  }
}

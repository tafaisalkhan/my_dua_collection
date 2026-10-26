import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/app_database.dart';
import '../../../media_library/presentation/controllers/media_library_controller.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mediaItemsProvider);
    final selected = ref.watch(mediaKindProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dua Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Import files',
            onPressed: () async {
              final count = await ref.read(mediaRepositoryProvider).pickFiles();
              if (context.mounted && count > 0)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$count item(s) imported')),
                );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) =>
                  ref.read(mediaSearchProvider.notifier).state = v,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search title, tags or OCR text',
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final value in const [
                  'all',
                  'image',
                  'video',
                  'audio',
                  'document',
                  'text',
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        value == 'all'
                            ? 'All'
                            : '${value[0].toUpperCase()}${value.substring(1)}',
                      ),
                      selected: selected == value,
                      onSelected: (_) =>
                          ref.read(mediaKindProvider.notifier).state = value,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Library error: $e')),
              data: (rows) => rows.isEmpty
                  ? const Center(
                      child: Text(
                        'Import or share documents, images, video or audio to this app.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final item = rows[index];
                        final icon = switch (item.kind) {
                          'image' => Icons.image_outlined,
                          'video' => Icons.video_library_outlined,
                          'audio' => Icons.audio_file_outlined,
                          'document' => Icons.description_outlined,
                          'text' => Icons.notes_outlined,
                          _ => Icons.insert_drive_file_outlined,
                        };
                        return _LibraryItemCard(
                          key: ValueKey(item.id),
                          item: item,
                          icon: icon,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(mediaRepositoryProvider).pickFiles(),
        icon: const Icon(Icons.add),
        label: const Text('Import'),
      ),
    );
  }
}

class _LibraryItemCard extends StatefulWidget {
  const _LibraryItemCard({super.key, required this.item, required this.icon});
  final LibraryItem item;
  final IconData icon;

  @override
  State<_LibraryItemCard> createState() => _LibraryItemCardState();
}

class _LibraryItemCardState extends State<_LibraryItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final content = item.textContent?.trim().isNotEmpty == true
        ? item.textContent!.trim()
        : item.ocrText?.trim();
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push('/library/item/${item.id}'),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primary.withValues(alpha: .15),
                    child: Icon(widget.icon, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.tags.isEmpty
                              ? item.kind
                              : '${item.kind} • ${item.tags}',
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            if (content != null && content.isNotEmpty) ...[
              const SizedBox(height: 12),
              SelectableText(
                content,
                maxLines: _expanded ? null : 3,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? 'Show less' : 'Show full text'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Icon(icon)),
                            title: Text(item.title),
                            subtitle: Text(
                              item.tags.isEmpty
                                  ? item.kind
                                  : '${item.kind} • ${item.tags}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () =>
                                context.push('/library/item/${item.id}'),
                          ),
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

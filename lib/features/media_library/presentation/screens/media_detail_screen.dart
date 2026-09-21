import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:video_player/video_player.dart';
import '../controllers/media_library_controller.dart';

class MediaDetailScreen extends ConsumerStatefulWidget {
  const MediaDetailScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<MediaDetailScreen> createState() => _MediaDetailState();
}

class _MediaDetailState extends ConsumerState<MediaDetailScreen> {
  VideoPlayerController? video;
  final audio = AudioPlayer();
  String? initializedPath;
  @override
  void dispose() {
    video?.dispose();
    audio.dispose();
    super.dispose();
  }

  Future<void> _init(String kind, String? path) async {
    if (path == null || path == initializedPath) return;
    initializedPath = path;
    if (kind == 'video') {
      video = VideoPlayerController.file(File(path));
      await video!.initialize();
      if (mounted) setState(() {});
    }
    if (kind == 'audio') {
      await audio.setFilePath(path);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(mediaItemProvider(widget.id))
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
        data: (item) {
          if (item == null)
            return const Scaffold(body: Center(child: Text('Item not found')));
          _init(item.kind, item.filePath);
          return Scaffold(
            appBar: AppBar(
              title: Text(item.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () =>
                      ref.read(mediaRepositoryProvider).shareItem(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(mediaRepositoryProvider).deleteItem(item);
                    if (context.mounted) context.pop();
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (item.kind == 'image' && item.filePath != null)
                  Image.file(
                    File(item.filePath!),
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                if (item.kind == 'video' &&
                    video?.value.isInitialized == true) ...[
                  AspectRatio(
                    aspectRatio: video!.value.aspectRatio,
                    child: VideoPlayer(video!),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      video!.value.isPlaying ? video!.pause() : video!.play();
                      setState(() {});
                    },
                    icon: Icon(
                      video!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    label: const Text('Play / Pause'),
                  ),
                ],
                if (item.kind == 'audio')
                  StreamBuilder<PlayerState>(
                    stream: audio.playerStateStream,
                    builder: (_, s) => FilledButton.icon(
                      onPressed: () =>
                          audio.playing ? audio.pause() : audio.play(),
                      icon: Icon(
                        audio.playing ? Icons.pause : Icons.play_arrow,
                      ),
                      label: const Text('Play / Pause audio'),
                    ),
                  ),
                if (['document', 'other'].contains(item.kind) &&
                    item.filePath != null)
                  FilledButton.icon(
                    onPressed: () => OpenFilex.open(item.filePath!),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open document'),
                  ),
                if (item.textContent != null) SelectableText(item.textContent!),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: item.tags,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'morning, favorite, family',
                  ),
                  onFieldSubmitted: (v) async {
                    await ref.read(mediaRepositoryProvider).setTags(item.id, v);
                    ref.invalidate(mediaItemProvider(item.id));
                  },
                ),
                const SizedBox(height: 8),
                const Text('Enter comma-separated tags, then press Done.'),
              ],
            ),
          );
        },
      );
}

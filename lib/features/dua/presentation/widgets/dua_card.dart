import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/database/app_database.dart' as database;
import '../../../../core/theme/dua_palette.dart';
import '../../domain/entities/dua.dart';
import 'dua_text_view.dart';

class DuaCard extends ConsumerStatefulWidget {
  const DuaCard({
    super.key,
    required this.dua,
    required this.onTap,
    this.color,
  });
  final Dua dua;
  final VoidCallback onTap;
  final Color? color;

  @override
  ConsumerState<DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends ConsumerState<DuaCard> {
  final _audio = AudioPlayer();
  late Future<List<database.DuaAttachment>> _attachments;
  String? _playingPath;

  @override
  void initState() {
    super.initState();
    _attachments = _loadAttachments();
  }

  @override
  void didUpdateWidget(covariant DuaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dua.id != widget.dua.id) {
      _audio.stop();
      _playingPath = null;
      _attachments = _loadAttachments();
    }
  }

  Future<List<database.DuaAttachment>> _loadAttachments() {
    final db = ref.read(database.appDatabaseProvider);
    return (db.select(
      db.duaAttachments,
    )..where((row) => row.duaId.equals(widget.dua.id))).get();
  }

  Future<void> _open(database.DuaAttachment attachment) async {
    switch (attachment.kind) {
      case 'audio':
        if (_playingPath == attachment.value && _audio.playing) {
          await _audio.pause();
        } else {
          await _audio.setFilePath(attachment.value);
          _playingPath = attachment.value;
          await _audio.play();
        }
        if (mounted) setState(() {});
      case 'link':
      case 'youtube':
        if (mounted) {
          context.push(
            Uri(
              path: '/view/web',
              queryParameters: {
                'url': attachment.value,
                'title': attachment.title,
              },
            ).toString(),
          );
        }
      case 'document':
        if (mounted) {
          context.push(
            Uri(
              path: '/view/document',
              queryParameters: {
                'path': attachment.value,
                'title': attachment.title,
              },
            ).toString(),
          );
        }
      default:
        await OpenFilex.open(attachment.value);
    }
  }

  IconData _icon(String kind) => switch (kind) {
    'audio' => Icons.play_circle_fill,
    'video' => Icons.play_circle_outline,
    'image' => Icons.image_outlined,
    'document' => Icons.description_outlined,
    'youtube' => Icons.smart_display,
    'link' => Icons.language,
    _ => Icons.attach_file,
  };

  String _label(database.DuaAttachment attachment) => switch (attachment.kind) {
    'audio' =>
      _playingPath == attachment.value && _audio.playing
          ? 'Pause voice'
          : 'Play voice',
    'video' => 'Play video',
    'image' => 'View image',
    'document' => 'Open document',
    'youtube' => 'YouTube',
    'link' => 'Website',
    _ => attachment.title,
  };

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<database.DuaAttachment>>(
        future: _attachments,
        builder: (context, snapshot) {
          final attachments = snapshot.data ?? const <database.DuaAttachment>[];
          final images = attachments
              .where((item) => item.kind == 'image')
              .toList();
          final duaColor = widget.color ?? DuaPalette.forKey(widget.dua.id);
          return Card(
            color: duaColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.dua.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Open Dua details',
                          onPressed: widget.onTap,
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(images.first.value),
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                    if (widget.dua.originalText.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      DuaTextView(
                        widget.dua.originalText,
                        languageCode: widget.dua.detectedLanguage,
                        color: Colors.black87,
                      ),
                    ],
                    if (attachments.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          for (final attachment in attachments)
                            ActionChip(
                              avatar: Icon(_icon(attachment.kind), size: 18),
                              label: Text(_label(attachment)),
                              onPressed: () => _open(attachment),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
}

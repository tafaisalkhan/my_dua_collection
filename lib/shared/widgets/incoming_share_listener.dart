import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../features/incoming_share/presentation/controllers/incoming_share_queue.dart';
import '../../core/routing/app_router.dart';

class IncomingShareListener extends ConsumerStatefulWidget {
  const IncomingShareListener({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<IncomingShareListener> createState() => _State();
}

class _State extends ConsumerState<IncomingShareListener> {
  StreamSubscription<List<SharedMediaFile>>? sub;
  @override
  void initState() {
    super.initState();
    sub = ReceiveSharingIntent.instance.getMediaStream().listen(
      _receive,
      onError: (Object error) => debugPrint('Incoming share error: $error'),
    );
    ReceiveSharingIntent.instance.getInitialMedia().then((v) async {
      await _receive(v);
      await ReceiveSharingIntent.instance.reset();
    });
  }

  Future<void> _receive(List<SharedMediaFile> items) async {
    final accepted = <IncomingShareEntry>[];
    for (final item in items) {
      final mime = (item.mimeType ?? '').toLowerCase();
      final lowerPath = item.path.toLowerCase();
      final image =
          item.type == SharedMediaType.image ||
          mime.startsWith('image/') ||
          RegExp(
            r'\\.(jpg|jpeg|png|webp|gif|bmp|heic|heif)$',
          ).hasMatch(lowerPath);
      final pdf = mime == 'application/pdf' || lowerPath.endsWith('.pdf');
      final text = item.type == SharedMediaType.text || mime == 'text/plain';
      if (image || pdf || text)
        accepted.add(
          IncomingShareEntry(
            path: item.path,
            mimeType: mime,
            isImage: image,
            isText: text,
          ),
        );
    }
    if (accepted.isEmpty) return;
    ref.read(incomingShareQueueProvider.notifier).state = [
      ...ref.read(incomingShareQueueProvider),
      ...accepted,
    ];
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(appRouterProvider).go('/share-review');
      });
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

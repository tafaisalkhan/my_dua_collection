import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class IncomingShareEntry {
  const IncomingShareEntry({
    required this.path,
    required this.mimeType,
    required this.isImage,
    this.isText = false,
  });
  final String path, mimeType;
  final bool isImage;
  final bool isText;
}

final incomingShareQueueProvider = StateProvider<List<IncomingShareEntry>>(
  (ref) => const [],
);

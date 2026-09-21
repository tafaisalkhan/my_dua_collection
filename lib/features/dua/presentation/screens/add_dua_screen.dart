// ignore_for_file: curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ocr/domain/services/image_picker_service.dart';
import '../../../ocr/presentation/controllers/image_picker_controller.dart';

class AddDuaScreen extends ConsumerWidget {
  const AddDuaScreen({super.key});
  Future<void> _pick(BuildContext c, WidgetRef r, DuaImageSource s) async {
    final p = await r.read(imagePickerControllerProvider.notifier).pick(s);
    if (!c.mounted) return;
    if (p == null) {
      if (r.read(imagePickerControllerProvider).hasError)
        ScaffoldMessenger.of(c).showSnackBar(
          const SnackBar(content: Text('Could not open camera or gallery.')),
        );
      return;
    }
    c.push(
      '/add/image-preview?source=' + s.name + '&path=' + Uri.encodeComponent(p),
    );
  }

  Future<void> _pasteText(BuildContext context) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (!context.mounted) return;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copy Dua text first, then try again.')),
      );
      return;
    }
    context.push('/add/manual?ocrText=' + Uri.encodeComponent(text));
  }

  @override
  Widget build(BuildContext c, WidgetRef r) {
    final busy = r.watch(imagePickerControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Dua')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'How would you like to add it?',
                style: Theme.of(c).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              _Option(
                Icons.photo_camera_outlined,
                'Take a Photo',
                'Take a picture, then crop the Dua',
                busy ? null : () => _pick(c, r, DuaImageSource.camera),
              ),
              _Option(
                Icons.photo_library_outlined,
                'Choose From Gallery',
                'Choose a picture, then crop the Dua',
                busy ? null : () => _pick(c, r, DuaImageSource.gallery),
              ),
              _Option(
                Icons.edit_outlined,
                'Type Manually',
                'Enter Dua text yourself',
                busy ? null : () => c.push('/add/manual'),
              ),
              _Option(
                Icons.content_paste_go_outlined,
                'Paste Copied Dua Text',
                'Create a Dua from copied Arabic or other text',
                busy ? null : () => _pasteText(c),
              ),
            ],
          ),
          if (busy)
            const ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    ),
  );
}

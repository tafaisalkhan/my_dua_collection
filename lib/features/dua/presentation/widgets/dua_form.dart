import 'package:flutter/material.dart';

class DuaForm extends StatelessWidget {
  const DuaForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.textController,
    this.onSave,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController, textController;
  final VoidCallback? onSave;
  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Title *'),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Title is required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: textController,
          minLines: 5,
          maxLines: 10,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            labelText: 'Original / OCR Text *',
            alignLabelWithHint: true,
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Dua text is required' : null,
        ),
        const SizedBox(height: 14),
        for (final label in const [
          'Translation',
          'Transliteration',
          'Reference',
          'Notes',
        ]) ...[
          TextFormField(
            minLines: label == 'Notes' ? 3 : 1,
            maxLines: label == 'Notes' ? 5 : 1,
            decoration: InputDecoration(labelText: label),
          ),
          const SizedBox(height: 14),
        ],
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Primary Category'),
          items: const [
            'Morning',
            'Evening',
            'Night',
            'Protection',
            'Travel',
            'Personal',
          ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        const InputDecorator(
          decoration: InputDecoration(labelText: 'Tags'),
          child: Wrap(
            spacing: 8,
            children: [Chip(label: Text('Add tags later'))],
          ),
        ),
        const SizedBox(height: 14),
        const ListTile(
          leading: Icon(Icons.image_outlined),
          title: Text('Image'),
          subtitle: Text('Optional • Available after camera/gallery setup'),
        ),
        const ListTile(
          leading: Icon(Icons.mic_none),
          title: Text('Voice recording'),
          subtitle: Text('Available in a later step'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onSave,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          child: const Text('Save Dua'),
        ),
      ],
    ),
  );
}

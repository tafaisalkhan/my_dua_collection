import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/dua_palette.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../categories/presentation/controllers/category_controller.dart';
import '../widgets/category_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  IconData _icon(String name) => switch (name.toLowerCase()) {
    'morning' => Icons.wb_sunny_outlined,
    'evening' => Icons.nights_stay_outlined,
    'after prayer' => Icons.mosque_outlined,
    'protection' => Icons.shield_outlined,
    'travel' => Icons.flight_takeoff,
    'forgiveness' => Icons.volunteer_activism_outlined,
    _ => Icons.auto_stories_outlined,
  };

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Dua Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Category name',
            hintText: 'For example: Family',
          ),
          onSubmitted: (value) => dialogContext.pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    final db = ref.read(appDatabaseProvider);
    final existing = (await db.select(db.categories).get()).any(
      (row) => row.name.toLowerCase() == name.toLowerCase(),
    );
    if (existing) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That category already exists.')),
        );
      }
      return;
    }
    final count = await db
        .select(db.categories)
        .get()
        .then((rows) => rows.length);
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            id: const Uuid().v4(),
            name: name.trim(),
            isBuiltIn: const Value(false),
            sortOrder: Value(count),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    if (category.isBuiltIn) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${category.name}?'),
        content: const Text(
          'The category will be removed. Its Duas will be kept safely but will no longer belong to this category.',
        ),
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
    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await (db.update(db.duas)
            ..where((row) => row.primaryCategoryId.equals(category.id)))
          .write(const DuasCompanion(primaryCategoryId: Value(null)));
      await (db.delete(
        db.categories,
      )..where((row) => row.id.equals(category.id))).go();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Dua'),
        actions: [
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Assalamu Alaikum',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a category to see its Duas.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          SearchField(onTap: () => context.go('/library')),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/dua-bundle'),
            icon: const Icon(Icons.playlist_add),
            label: const Text('CREATE DUA BUNDLE'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: SectionHeader('Dua Categories')),
              TextButton.icon(
                onPressed: () => _addCategory(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
            ],
          ),
          categories.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Could not load categories: $error'),
            data: (items) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) => CategoryCard(
                name: items[index].name,
                icon: _icon(items[index].name),
                color: DuaPalette.forCategory(items[index].name),
                onTap: () => context.push(
                  '/category/${Uri.encodeComponent(items[index].name)}',
                ),
                onDelete: items[index].isBuiltIn
                    ? null
                    : () => _deleteCategory(context, ref, items[index]),
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => context.go('/add'),
            icon: const Icon(Icons.add),
            label: const Text('ADD NEW DUA'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
          ),
        ],
      ),
    );
  }
}

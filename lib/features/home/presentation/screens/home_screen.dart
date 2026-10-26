import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/audio/audio_playback_coordinator.dart';
import '../../../../core/database/app_database.dart' as database;
import '../../../../core/theme/app_colors.dart';
import '../../../categories/presentation/controllers/category_controller.dart';
import '../../../dua/domain/entities/dua.dart';
import '../../../dua/presentation/controllers/dua_controller.dart';
import '../../../settings/presentation/controllers/ad_entitlement_controller.dart';
import '../widgets/category_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _nextDayTimer;

  @override
  void initState() {
    super.initState();
    _scheduleNextDay();
  }

  void _scheduleNextDay() {
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    _nextDayTimer = Timer(nextDay.difference(now), () {
      if (!mounted) return;
      setState(() {});
      _scheduleNextDay();
    });
  }

  @override
  void dispose() {
    _nextDayTimer?.cancel();
    super.dispose();
  }

  IconData _icon(String name) => switch (name.toLowerCase()) {
    'morning' => Icons.wb_sunny_outlined,
    'evening' => Icons.nights_stay_outlined,
    'after prayer' => Icons.mosque_outlined,
    'protection' => Icons.shield_outlined,
    'travel' => Icons.flight_takeoff,
    'forgiveness' => Icons.volunteer_activism_outlined,
    _ => Icons.auto_stories_outlined,
  };

  void _showAllDuas() => context.push('/duas');

  Future<void> _addCategory() async {
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
    if (name == null || name.trim().isEmpty || !mounted) return;
    final db = ref.read(database.appDatabaseProvider);
    final rows = await db.select(db.categories).get();
    if (rows.any((row) => row.name.toLowerCase() == name.toLowerCase())) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That category already exists.')),
        );
      }
      return;
    }
    await db
        .into(db.categories)
        .insert(
          database.CategoriesCompanion.insert(
            id: const Uuid().v4(),
            name: name.trim(),
            isBuiltIn: const Value(false),
            sortOrder: Value(rows.length),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> _deleteCategory(database.Category category) async {
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
    final db = ref.read(database.appDatabaseProvider);
    await db.transaction(() async {
      await (db.update(db.duas)
            ..where((row) => row.primaryCategoryId.equals(category.id)))
          .write(const database.DuasCompanion(primaryCategoryId: Value(null)));
      await (db.delete(
        db.categories,
      )..where((row) => row.id.equals(category.id))).go();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final duas = ref.watch(duasProvider);
    final adsRemoved = ref.watch(adsRemovedProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite Dua',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'A moment of remembrance',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontFamily: 'serif', height: 1.15),
                      ),
                    ],
                  ),
                ),
                if (!adsRemoved)
                  OutlinedButton.icon(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.hide_source_outlined, size: 17),
                    label: const Text('Remove Ads'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            duas.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _HomeMessage(
                icon: Icons.error_outline,
                message: 'Could not load your Duas: $error',
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const _HomeMessage(
                    icon: Icons.auto_stories_outlined,
                    message: 'Your Duas will appear here.',
                  );
                }
                final visible = [...items]
                  ..sort((a, b) => a.id.compareTo(b.id));
                final now = DateTime.now();
                final random = Random(
                  now.year * 10000 + now.month * 100 + now.day,
                );
                final firstIndex = random.nextInt(visible.length);
                final first = visible[firstIndex];
                final second = visible.length > 1
                    ? visible[(firstIndex +
                              1 +
                              random.nextInt(visible.length - 1)) %
                          visible.length]
                    : null;
                return Column(
                  children: [
                    _HomeSection(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'Dua',
                      onViewAll: _showAllDuas,
                      child: _FeaturedDuaCard(dua: first),
                    ),
                    if (second != null) ...[
                      const SizedBox(height: 30),
                      _HomeSection(
                        icon: Icons.auto_awesome_outlined,
                        title: 'Reflection',
                        onViewAll: _showAllDuas,
                        child: _FeaturedDuaCard(dua: second),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Explore categories',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontFamily: 'serif'),
                  ),
                ),
                TextButton.icon(
                  onPressed: _addCategory,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Category'),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) => CategoryCard(
                  name: items[index].name,
                  icon: _icon(items[index].name),
                  onTap: () => context.push(
                    '/category/${Uri.encodeComponent(items[index].name)}',
                  ),
                  onDelete: items[index].isBuiltIn
                      ? null
                      : () => _deleteCategory(items[index]),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add a new Dua'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.icon,
    required this.title,
    required this.onViewAll,
    required this.child,
  });
  final IconData icon;
  final String title;
  final VoidCallback onViewAll;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .55)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: colors.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontFamily: 'serif'),
                ),
              ),
              TextButton(onPressed: onViewAll, child: const Text('View all')),
            ],
          ),
          const SizedBox(height: 14),
          _Ornament(color: colors.primary),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _Ornament extends StatelessWidget {
  const _Ornament({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(width: 48, height: 1, color: color.withValues(alpha: .35)),
      const SizedBox(width: 8),
      for (var i = 0; i < 3; i++) ...[
        Transform.rotate(
          angle: .785,
          child: Container(
            width: i == 1 ? 9 : 6,
            height: i == 1 ? 9 : 6,
            color: color.withValues(alpha: i == 1 ? .85 : .65),
          ),
        ),
        const SizedBox(width: 8),
      ],
      Container(width: 48, height: 1, color: color.withValues(alpha: .35)),
    ],
  );
}

class _FeaturedDuaCard extends ConsumerStatefulWidget {
  const _FeaturedDuaCard({required this.dua});
  final Dua dua;

  @override
  ConsumerState<_FeaturedDuaCard> createState() => _FeaturedDuaCardState();
}

class _FeaturedDuaCardState extends ConsumerState<_FeaturedDuaCard> {
  final _player = AudioPlayer();
  StreamSubscription<PlayerState>? _subscription;
  late Future<String?> _audioPath;

  @override
  void initState() {
    super.initState();
    AudioPlaybackCoordinator.instance.register(_player);
    _subscription = _player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
    _audioPath = _findAudio();
  }

  @override
  void didUpdateWidget(covariant _FeaturedDuaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dua.id != widget.dua.id) {
      unawaited(_player.stop());
      _audioPath = _findAudio();
    }
  }

  Future<String?> _findAudio() async {
    final db = ref.read(database.appDatabaseProvider);
    final rows = await (db.select(
      db.duaAttachments,
    )..where((row) => row.duaId.equals(widget.dua.id))).get();
    for (final row in rows) {
      if (row.kind == 'audio') return row.value;
    }
    return null;
  }

  Future<void> _toggleAudio(String path) async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await AudioPlaybackCoordinator.instance.stopOthers(_player);
      await _player.setFilePath(path);
      unawaited(_player.play());
    }
  }

  @override
  void dispose() {
    AudioPlaybackCoordinator.instance.unregister(_player);
    _subscription?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const cardInk = Color(0xFF183A29);
    const cardAccent = Color(0xFF397454);
    final dua = widget.dua;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('/dua/${dua.id}'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark ? const Color(0xFFE0EBD9) : const Color(0xFFF1F7EB),
                  isDark ? const Color(0xFFBFD7BF) : const Color(0xFFDFEDDA),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cardAccent.withValues(alpha: .38)),
            ),
            child: Column(
              children: [
                Text(
                  dua.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: cardInk,
                  ),
                ),
                const SizedBox(height: 20),
                const _Ornament(color: cardAccent),
                if (dua.originalText.trim().isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    dua.originalText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: cardInk, fontSize: 22, height: 1.55),
                  ),
                ],
                if (dua.translation?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 18),
                  const _Ornament(color: cardAccent),
                  const SizedBox(height: 20),
                  Text(
                    dua.translation!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: cardInk.withValues(alpha: .86),
                    ),
                  ),
                ],
                if (dua.reference?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: cardAccent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        dua.reference!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cardInk,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FutureBuilder<String?>(
              future: _audioPath,
              builder: (context, snapshot) => IconButton(
                tooltip: snapshot.data == null
                    ? 'Open Dua to add audio'
                    : _player.playing
                    ? 'Pause audio'
                    : 'Play audio',
                onPressed: snapshot.data == null
                    ? () => context.push('/dua/${dua.id}')
                    : () => _toggleAudio(snapshot.data!),
                icon: Icon(
                  snapshot.data == null
                      ? Icons.arrow_forward_rounded
                      : _player.playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 30,
                ),
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: 'Share Dua',
              onPressed: () => SharePlus.instance.share(
                ShareParams(
                  text: [
                    dua.title,
                    dua.originalText,
                    if (dua.translation != null) dua.translation!,
                    if (dua.reference != null) dua.reference!,
                  ].where((part) => part.trim().isNotEmpty).join('\n\n'),
                ),
              ),
              icon: const Icon(Icons.share_outlined),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: dua.isFavorite ? 'Remove favorite' : 'Add favorite',
              onPressed: () =>
                  ref.read(duaRepositoryProvider).toggleFavorite(dua.id),
              icon: Icon(
                dua.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeMessage extends StatelessWidget {
  const _HomeMessage({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Column(
      children: [
        Icon(icon, size: 42, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
      ],
    ),
  );
}

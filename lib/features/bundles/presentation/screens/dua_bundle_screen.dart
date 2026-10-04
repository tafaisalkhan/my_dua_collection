import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../data/dua_bundle_schedule_service.dart';

class _BundleItem {
  const _BundleItem(this.dua, this.category, this.audioPath);
  final Dua dua;
  final String category;
  final String? audioPath;
}

class DuaBundleScreen extends ConsumerStatefulWidget {
  const DuaBundleScreen({super.key});

  @override
  ConsumerState<DuaBundleScreen> createState() => _DuaBundleScreenState();
}

class _DuaBundleScreenState extends ConsumerState<DuaBundleScreen> {
  List<DuaBundleConfig> _bundles = const [];
  DuaBundleConfig? _editingBundle;

  final _name = TextEditingController(text: 'Morning Dua Bundle');
  final _selected = <String>{};
  final _repeats = <String, int>{};
  List<_BundleItem> _items = const [];
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  String _frequency = 'daily';
  int _weekday = DateTime.monday;
  int _dayOfMonth = 1;
  bool _loading = true;
  bool _saving = false;
  bool _isCreatingOrEditing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    final duas = await db.select(db.duas).get();
    final categories = await db.select(db.categories).get();
    final attachments = await db.select(db.duaAttachments).get();
    final categoryNames = {
      for (final value in categories) value.id: value.name,
    };
    final audioByDua = <String, String>{};
    for (final attachment in attachments) {
      if (attachment.kind == 'audio') {
        audioByDua[attachment.duaId] = attachment.value;
      }
    }

    final allBundles = await DuaBundleScheduleService.loadAll();

    if (!mounted) return;
    setState(() {
      _bundles = allBundles;
      _items = [
        for (final dua in duas)
          _BundleItem(
            dua,
            categoryNames[dua.primaryCategoryId] ?? 'Uncategorized',
            audioByDua[dua.id],
          ),
      ]..sort((a, b) {
          final category = a.category.compareTo(b.category);
          return category != 0
              ? category
              : a.dua.title.compareTo(b.dua.title);
        });
      _loading = false;
    });
  }

  void _startCreatingNew() {
    setState(() {
      _isCreatingOrEditing = true;
      _editingBundle = null;
      _name.text = 'Dua Bundle #${_bundles.length + 1}';
      _selected.clear();
      _repeats.clear();
      _time = const TimeOfDay(hour: 8, minute: 0);
      _frequency = 'daily';
      _weekday = DateTime.monday;
      _dayOfMonth = 1;
    });
  }

  void _startEditing(DuaBundleConfig bundle) {
    setState(() {
      _isCreatingOrEditing = true;
      _editingBundle = bundle;
      _name.text = bundle.name;
      _selected.clear();
      _selected.addAll(bundle.duaIds);
      _repeats.clear();
      _repeats.addAll(bundle.duaRepeats);
      _time = TimeOfDay(hour: bundle.hour, minute: bundle.minute);
      _frequency = bundle.frequency;
      _weekday = bundle.weekday;
      _dayOfMonth = bundle.dayOfMonth;
    });
  }

  Future<void> _chooseTime() async {
    final value = await showTimePicker(context: context, initialTime: _time);
    if (value != null && mounted) setState(() => _time = value);
  }

  Future<void> _save() async {
    final chosen = _items
        .where((item) => _selected.contains(item.dua.id))
        .toList();
    if (chosen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one Dua with voice.')),
      );
      return;
    }
    setState(() => _saving = true);

    final bundleId = _editingBundle?.id ?? const Uuid().v4();
    final config = DuaBundleConfig(
      id: bundleId,
      name: _name.text.trim().isEmpty ? 'Dua Bundle' : _name.text.trim(),
      duaIds: chosen.map((item) => item.dua.id).toList(),
      hour: _time.hour,
      minute: _time.minute,
      frequency: _frequency,
      weekday: _weekday,
      dayOfMonth: _dayOfMonth,
      duaRepeats: {
        for (final item in chosen) item.dua.id: _repeats[item.dua.id] ?? 1,
      },
    );

    await DuaBundleScheduleService.save(
      config: config,
      titles: chosen.map((item) => item.dua.title).toList(),
      audioPaths: chosen.map((item) => item.audioPath!).toList(),
      repeats: chosen.map((item) => _repeats[item.dua.id] ?? 1).toList(),
    );

    await _load();
    if (!mounted) return;
    setState(() {
      _saving = false;
      _isCreatingOrEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dua bundle "${config.name}" scheduled.')),
    );
    context.go('/home');
  }

  Future<void> _deleteBundle(DuaBundleConfig bundle) async {
    await DuaBundleScheduleService.cancel(bundle.id);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bundle "${bundle.name}" removed.')),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dua Bundle Scheduler')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isCreatingOrEditing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dua Bundles')),
        body: _bundles.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.playlist_play, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No Scheduled Bundles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create custom bundles of Duas to play automatically at your chosen times.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _startCreatingNew,
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Dua Bundle'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final bundle in _bundles)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => _startEditing(bundle),
                        leading: const CircleAvatar(
                          child: Icon(Icons.queue_music),
                        ),
                        title: Text(
                          bundle.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${TimeOfDay(hour: bundle.hour, minute: bundle.minute).format(context)} • ${bundle.frequency} • ${bundle.duaIds.length} Dua(s)',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _startEditing(bundle),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _deleteBundle(bundle),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
        floatingActionButton: _bundles.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: _startCreatingNew,
                icon: const Icon(Icons.add),
                label: const Text('New Bundle'),
              )
            : null,
      );
    }

    final playableItems = _items
        .where((item) => item.audioPath != null)
        .toList();
    final groups = <String, List<_BundleItem>>{};
    for (final item in playableItems) {
      groups.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_editingBundle == null ? 'Create Dua Bundle' : 'Edit Dua Bundle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _isCreatingOrEditing = false),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Bundle Name'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule),
            title: const Text('Playback Time'),
            subtitle: Text(_time.format(context)),
            onTap: _chooseTime,
          ),
          DropdownButtonFormField<String>(
            initialValue: _frequency,
            decoration: const InputDecoration(labelText: 'Repeat'),
            items: const [
              DropdownMenuItem(value: 'daily', child: Text('Every day')),
              DropdownMenuItem(value: 'weekly', child: Text('Every week')),
              DropdownMenuItem(value: 'monthly', child: Text('Every month')),
            ],
            onChanged: (value) => setState(() => _frequency = value ?? 'daily'),
          ),
          if (_frequency == 'weekly') ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _weekday,
              decoration: const InputDecoration(labelText: 'Weekday'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Monday')),
                DropdownMenuItem(value: 2, child: Text('Tuesday')),
                DropdownMenuItem(value: 3, child: Text('Wednesday')),
                DropdownMenuItem(value: 4, child: Text('Thursday')),
                DropdownMenuItem(value: 5, child: Text('Friday')),
                DropdownMenuItem(value: 6, child: Text('Saturday')),
                DropdownMenuItem(value: 7, child: Text('Sunday')),
              ],
              onChanged: (value) => setState(() => _weekday = value ?? 1),
            ),
          ],
          if (_frequency == 'monthly') ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _dayOfMonth,
              decoration: const InputDecoration(labelText: 'Day of month'),
              items: [
                for (var day = 1; day <= 28; day++)
                  DropdownMenuItem(value: day, child: Text('Day $day')),
              ],
              onChanged: (value) => setState(() => _dayOfMonth = value ?? 1),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Select Duas in playback order',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text('Only Duas with an attached voice are shown.'),
          const SizedBox(height: 10),
          if (playableItems.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No playable Duas found. Attach a voice to a Dua, then return here to schedule it.',
                ),
              ),
            ),
          for (final group in groups.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                group.key,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final item in group.value)
              CheckboxListTile(
                value: _selected.contains(item.dua.id),
                enabled: item.audioPath != null,
                title: Text(item.dua.title),
                subtitle: Text(
                  item.audioPath == null
                      ? 'Attach voice before selecting'
                      : 'Voice ready',
                ),
                secondary: _selected.contains(item.dua.id)
                    ? DropdownButton<int>(
                        value: _repeats[item.dua.id] ?? 1,
                        items: [
                          for (var count = 1; count <= 10; count++)
                            DropdownMenuItem(
                              value: count,
                              child: Text('×$count'),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          _repeats[item.dua.id] = value ?? 1;
                        }),
                      )
                    : null,
                onChanged: item.audioPath == null
                    ? null
                    : (value) => setState(() {
                        if (value == true) {
                          _selected.add(item.dua.id);
                          _repeats.putIfAbsent(item.dua.id, () => 1);
                        } else {
                          _selected.remove(item.dua.id);
                          _repeats.remove(item.dua.id);
                        }
                      }),
              ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(_saving ? 'Saving...' : 'Save Bundle'),
      ),
    );
  }
}

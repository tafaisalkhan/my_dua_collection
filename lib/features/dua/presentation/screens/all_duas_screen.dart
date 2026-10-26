import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/dua_controller.dart';
import '../widgets/dua_card.dart';

class AllDuasScreen extends ConsumerStatefulWidget {
  const AllDuasScreen({super.key});

  @override
  ConsumerState<AllDuasScreen> createState() => _AllDuasScreenState();
}

class _AllDuasScreenState extends ConsumerState<AllDuasScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final duas = ref.watch(duasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('All Duas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Duas',
              ),
            ),
          ),
          Expanded(
            child: duas.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Could not load Duas: $error')),
              data: (items) {
                final query = _query.toLowerCase();
                final visible = items.where((dua) {
                  if (query.isEmpty) return true;
                  return dua.title.toLowerCase().contains(query) ||
                      dua.originalText.toLowerCase().contains(query) ||
                      (dua.translation?.toLowerCase().contains(query) ?? false);
                }).toList();
                if (visible.isEmpty) {
                  return Center(
                    child: Text(
                      query.isEmpty
                          ? 'No Duas saved yet.'
                          : 'No matching Duas.',
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) => DuaCard(
                    key: ValueKey(visible[index].id),
                    dua: visible[index],
                    onTap: () => context.push('/dua/${visible[index].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

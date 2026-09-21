// ignore_for_file: unnecessary_underscores, prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/dua_palette.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../dua/presentation/controllers/dua_controller.dart';
import '../../../dua/presentation/widgets/dua_card.dart';

class CategoryDuasScreen extends ConsumerWidget {
  const CategoryDuasScreen({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final d = r.watch(categoryDuasProvider(name));
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: d.when(
        loading: () => const AppLoading(),
        error: (e, s) => AppError(e.toString()),
        data: (x) => x.isEmpty
            ? EmptyState(
                icon: Icons.auto_stories_outlined,
                title: 'No $name Duas yet',
                message: 'Add a Dua to this category.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: x.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (c, i) => DuaCard(
                  key: ValueKey(x[i].id),
                  dua: x[i],
                  color: DuaPalette.forCategory(name),
                  onTap: () => c.push('/dua/' + x[i].id),
                ),
              ),
      ),
    );
  }
}

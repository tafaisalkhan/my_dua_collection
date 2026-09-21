import 'package:flutter/material.dart';
import '../../../../shared/widgets/empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Favorites')),
    body: EmptyState(
      icon: Icons.favorite_outline,
      title: 'No favorites yet',
      message: 'Tap the heart on any Dua to keep it close.',
    ),
  );
}

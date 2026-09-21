import 'package:favorite_dua/app.dart';
import 'package:favorite_dua/features/categories/presentation/controllers/category_controller.dart';
import 'package:favorite_dua/features/dua/presentation/controllers/dua_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('launches Favorite Dua home', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          duasProvider.overrideWith((ref) => Stream.value(const [])),
          categoriesProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const FavoriteDuaApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Favorite Dua'), findsOneWidget);
    expect(find.text('Add Category'), findsOneWidget);
  });
}

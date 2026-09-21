import '../entities/category.dart';

abstract interface class CategoryRepository {
  Stream<List<Category>> watchAll();
  Future<void> create(Category category);
}

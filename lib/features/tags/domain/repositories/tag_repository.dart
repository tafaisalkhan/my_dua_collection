import '../entities/tag.dart';

abstract interface class TagRepository {
  Stream<List<Tag>> watchAll();
  Future<void> create(Tag tag);
}

class Category {
  const Category({
    required this.id,
    required this.name,
    this.isBuiltIn = false,
    this.sortOrder = 0,
  });
  final String id, name;
  final bool isBuiltIn;
  final int sortOrder;
}

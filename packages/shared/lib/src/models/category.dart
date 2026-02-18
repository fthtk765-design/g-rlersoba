class Category {
  final String id;
  final String name;
  final String slug;
  final int sortOrder;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.sortOrder,
    required this.isActive,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: (map['name'] ?? '') as String,
      slug: (map['slug'] ?? '') as String,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isActive: (map['is_active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}

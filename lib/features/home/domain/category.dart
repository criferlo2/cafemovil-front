class Category {
  const Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, Object?> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  final String id;
  final String name;
}

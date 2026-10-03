class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.categoryName,
    required this.presentation,
    required this.price,
    required this.featured,
  });

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      presentation: json['presentation']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      featured: json['featured'] == true,
    );
  }

  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final String categoryName;
  final String presentation;
  final double price;
  final bool featured;
}

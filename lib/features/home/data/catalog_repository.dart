import '../../../core/network/api_client.dart';
import '../domain/category.dart';
import '../domain/product.dart';

abstract interface class CatalogRepository {
  Future<List<Category>> fetchCategories();

  Future<List<Product>> fetchFeaturedProducts({String? categoryId, String? search});
}

class RemoteCatalogRepository implements CatalogRepository {
  const RemoteCatalogRepository({required this.client});

  final ApiClient client;

  @override
  Future<List<Category>> fetchCategories() async {
    final response = await client.get('/api/v1/categories');
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.map((item) => Category.fromJson(item as Map<String, Object?>)).toList();
  }

  @override
  Future<List<Product>> fetchFeaturedProducts({String? categoryId, String? search}) async {
    final query = <String, String>{
      if (categoryId != null && categoryId.isNotEmpty) 'category': categoryId,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response = await client.get('/api/v1/products/featured', queryParameters: query);
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.map((item) => Product.fromJson(item as Map<String, Object?>)).toList();
  }
}

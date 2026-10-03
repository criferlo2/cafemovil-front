import 'package:flutter_test/flutter_test.dart';

import 'package:cafemovil/features/home/data/catalog_repository.dart';
import 'package:cafemovil/features/home/domain/category.dart';
import 'package:cafemovil/features/home/domain/product.dart';
import 'package:cafemovil/features/home/presentation/home_view_model.dart';

class FakeCatalogRepository implements CatalogRepository {
  String? requestedCategoryId;
  String? requestedSearch;

  @override
  Future<List<Category>> fetchCategories() async {
    return const [
      Category(id: 'coffee', name: 'Café'),
      Category(id: 'accessories', name: 'Accesorios'),
    ];
  }

  @override
  Future<List<Product>> fetchFeaturedProducts({String? categoryId, String? search}) async {
    requestedCategoryId = categoryId;
    requestedSearch = search;
    return const [
      Product(
        id: 'prd_001',
        name: 'Origen Sierra Nevada',
        brand: 'Devoción',
        categoryId: 'coffee',
        categoryName: 'Café',
        presentation: 'Libra 500g',
        price: 42900,
        featured: true,
      ),
    ];
  }
}

void main() {
  test('loadHome loads coffee-first categories and featured products', () async {
    final repository = FakeCatalogRepository();
    final viewModel = HomeViewModel(repository: repository);

    await viewModel.loadHome();

    expect(viewModel.categories.first.name, 'Café');
    expect(viewModel.selectedCategoryId, 'coffee');
    expect(viewModel.products.single.brand, 'Devoción');
    expect(repository.requestedCategoryId, 'coffee');
  });

  test('searchByBrandOrProduct trims text and reloads products with current category', () async {
    final repository = FakeCatalogRepository();
    final viewModel = HomeViewModel(repository: repository);
    await viewModel.loadHome();

    await viewModel.searchByBrandOrProduct(' devocion ');

    expect(viewModel.searchText, 'devocion');
    expect(repository.requestedCategoryId, 'coffee');
    expect(repository.requestedSearch, 'devocion');
  });
}

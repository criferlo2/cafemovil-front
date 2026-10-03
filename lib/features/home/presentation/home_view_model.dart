import 'package:flutter/widgets.dart';

import '../data/catalog_repository.dart';
import '../domain/category.dart';
import '../domain/product.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.repository});

  final CatalogRepository repository;
  List<Category> _categories = const [];
  List<Product> _products = const [];
  String? _selectedCategoryId;
  String _searchText = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  String? get selectedCategoryId => _selectedCategoryId;
  String get searchText => _searchText;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHome() async {
    await _load(() async {
      _categories = await repository.fetchCategories();
      _selectedCategoryId = _categories.isEmpty ? null : _categories.first.id;
      _products = await repository.fetchFeaturedProducts(categoryId: _selectedCategoryId, search: _searchText);
    });
  }

  Future<void> selectCategory(String categoryId) async {
    _selectedCategoryId = categoryId;
    await _refreshProducts();
  }

  Future<void> searchByBrandOrProduct(String value) async {
    _searchText = value.trim();
    await _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    await _load(() async {
      _products = await repository.fetchFeaturedProducts(categoryId: _selectedCategoryId, search: _searchText);
    });
  }

  Future<void> _load(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

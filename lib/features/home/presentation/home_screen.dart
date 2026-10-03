import 'package:flutter/material.dart';

import '../../auth/domain/user_session.dart';
import '../domain/product.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.session, required this.viewModel});

  final UserSession session;
  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadHome();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Hola, ${widget.session.user.name}'),
            actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.shopping_cart_outlined))],
          ),
          body: RefreshIndicator(
            onRefresh: widget.viewModel.loadHome,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por marca o producto',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: widget.viewModel.searchByBrandOrProduct,
                ),
                const SizedBox(height: 20),
                Text('Categorías', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _CategoryList(viewModel: widget.viewModel),
                const SizedBox(height: 20),
                Text('Productos destacados', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (widget.viewModel.isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                else if (widget.viewModel.errorMessage != null)
                  Text('No pudimos cargar los productos. Intenta de nuevo.', style: TextStyle(color: Theme.of(context).colorScheme.error))
                else
                  _ProductGrid(products: widget.viewModel.products),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in viewModel.categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.name),
                selected: viewModel.selectedCategoryId == category.id,
                avatar: Icon(_iconForCategory(category.id), size: 18),
                onSelected: (_) => viewModel.selectCategory(category.id),
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String id) {
    return switch (id) {
      'coffee' => Icons.coffee,
      'accessories' => Icons.local_cafe_outlined,
      'machines' => Icons.coffee_maker_outlined,
      'manuals' => Icons.menu_book_outlined,
      'books' => Icons.auto_stories_outlined,
      _ => Icons.category_outlined,
    };
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No hay productos para esta búsqueda.')),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _ProductCard(product: products[index]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final price = product.price.toStringAsFixed(0);
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.coffee, size: 42),
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(product.brand, style: Theme.of(context).textTheme.bodySmall),
            Text(product.presentation, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text('\$$price COP', style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

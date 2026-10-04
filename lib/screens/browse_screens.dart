import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import '../widgets/common_widgets.dart';

void openProduct(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => ProductDetailsScreen(product: product),
    ),
  );
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore categories')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const Text(
            'Find your kind of home.',
            style: TextStyle(color: AppTheme.muted, fontSize: 14),
          ),
          const SizedBox(height: 18),
          ...MockData.categories.skip(1).map((category) {
            final count = MockData.products
                .where((product) => product.category == category.name)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(19),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ProductListScreen(category: category.name),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: const Color(0xFFF0F1EE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          category.icon,
                          color: AppTheme.green,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$count thoughtfully picked pieces',
                              style: const TextStyle(
                                color: AppTheme.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: AppTheme.muted,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          const Text(
            'A home that feels like you',
            style: TextStyle(
              color: AppTheme.green,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, this.category = 'All'});

  final String category;

  @override
  Widget build(BuildContext context) {
    final products = category == 'All'
        ? MockData.products
        : MockData.products
              .where((product) => product.category == category)
              .toList();
    return Scaffold(
      appBar: AppBar(title: Text(category == 'All' ? 'Shop all' : category)),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .66,
        ),
        itemBuilder: (context, index) => ProductCard(
          product: products[index],
          onTap: () => openProduct(context, products[index]),
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = MockData.products.where((product) {
      final matchesText =
          _query.isEmpty ||
          product.name.toLowerCase().contains(_query.toLowerCase()) ||
          product.category.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _category == 'All' || product.category == _category;
      return matchesText && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Try “table lamp” or “plants”',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: MockData.categories.map((category) {
                final selected = _category == category.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category.name),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _category = category.name),
                    selectedColor: AppTheme.paleGreen,
                    side: BorderSide(
                      color: selected
                          ? AppTheme.paleGreen
                          : const Color(0xFFE7EAE6),
                    ),
                    labelStyle: TextStyle(
                      color: selected ? AppTheme.green : AppTheme.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No matches just yet',
                    subtitle:
                        'Try another search or browse a different category.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: .66,
                        ),
                    itemBuilder: (context, index) => ProductCard(
                      product: results[index],
                      onTap: () => openProduct(context, results[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: product.color,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 14, top: 7, bottom: 7),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => shop.toggleFavorite(product),
                  icon: Icon(
                    shop.isFavorite(product)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: shop.isFavorite(product)
                        ? const Color(0xFFE56B68)
                        : AppTheme.ink,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ProductImage(product: product),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.green,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFFFB94D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}  ·  ${product.reviews} reviews',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      MoneyText(product.price, large: true),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Divider(),
                  const SizedBox(height: 18),
                  const Text(
                    'A little more about it',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const FeatureRow(
                    icon: Icons.local_shipping_outlined,
                    text: 'Free delivery on orders over \$75',
                  ),
                  const FeatureRow(
                    icon: Icons.replay_rounded,
                    text: 'Easy 30-day returns',
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Row(
          children: [
            Material(
              color: AppTheme.paleGreen,
              borderRadius: BorderRadius.circular(15),
              child: IconButton(
                onPressed: () {
                  shop.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to your bag'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_shopping_cart_rounded,
                  color: AppTheme.green,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  shop.addToCart(product);
                  Navigator.pushNamed(context, '/cart');
                },
                child: const Text('Add to bag'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  const FeatureRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppTheme.green),
          const SizedBox(width: 11),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

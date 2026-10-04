import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'browse_screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenCategories});

  final VoidCallback onOpenCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
          children: [
            Row(
              children: [
                const ClickMeLogo(compact: true),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const SearchScreen(),
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.ink,
                  ),
                  icon: const Icon(Icons.search_rounded),
                ),
                const SizedBox(width: 5),
                IconButton.filledTonal(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.ink,
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: AppTheme.green,
                ),
                const SizedBox(width: 5),
                const Text(
                  'DELIVERING TO',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Brooklyn, NY',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppTheme.ink,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Make room for\na little lovely.',
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 34,
                height: 1.08,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.1,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Thoughtful things for the place you call home.',
              style: TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
            const SizedBox(height: 22),
            const _PromoBanner(),
            const SizedBox(height: 27),
            SectionHeading(
              title: 'Shop by mood',
              action: 'See all',
              onAction: onOpenCategories,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 94,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.categories.length - 1,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final category = MockData.categories[index + 1];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: onOpenCategories,
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              category.icon,
                              color: AppTheme.green,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 27),
            SectionHeading(
              title: 'Little finds we love',
              action: 'View all',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ProductListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 272,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) => SizedBox(
                  width: 178,
                  child: ProductCard(
                    product: MockData.products[index],
                    onTap: () => openProduct(context, MockData.products[index]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            const _CareBanner(),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF286B4C), Color(0xFF174B37)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -5,
            top: 0,
            bottom: 0,
            width: 155,
            child: Opacity(
              opacity: .6,
              child: Image.network(
                MockData.products.first.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF174B37),
                    const Color(0xFF174B37).withValues(alpha: .9),
                    Colors.transparent,
                  ],
                  stops: const [0, .55, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'A FRESH SEASON',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                const Text(
                  'Little greens,\nbig happy.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.08,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 11),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const ProductListScreen(category: 'Plants'),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Shop plants',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareBanner extends StatelessWidget {
  const _CareBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBDD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco_outlined, color: AppTheme.green, size: 27),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good things, made thoughtfully',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  'Better materials. Better everyday.',
                  style: TextStyle(color: AppTheme.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: AppTheme.green, size: 19),
        ],
      ),
    );
  }
}

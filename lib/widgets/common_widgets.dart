import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

class ClickMeLogo extends StatelessWidget {
  const ClickMeLogo({super.key, this.light = false, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final foreground = light ? Colors.white : AppTheme.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 40,
          height: compact ? 34 : 40,
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: .16)
                : AppTheme.paleGreen,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: light ? Colors.white : AppTheme.green,
            size: compact ? 19 : 22,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'clickme',
          style: TextStyle(
            color: foreground,
            fontSize: compact ? 19 : 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -.8,
          ),
        ),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.fit = BoxFit.cover,
  });

  final Product product;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: product.color,
      child: Image.network(
        product.imageUrl,
        fit: fit,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppTheme.green.withValues(alpha: .45),
            size: 34,
          ),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.green.withValues(alpha: .5),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0F1EE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: ProductImage(product: product),
                    ),
                  ),
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${(((product.oldPrice - product.price) / product.oldPrice) * 100).round()}%',
                        style: const TextStyle(
                          color: AppTheme.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.white.withValues(alpha: .92),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        iconSize: 17,
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '\$${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFFFB94D),
                      ),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
              letterSpacing: -.4,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(action!),
          ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                color: AppTheme.paleGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.green, size: 38),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted, height: 1.5),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 22),
              SizedBox(
                width: 190,
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText(this.amount, {super.key, this.large = false});

  final double amount;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${amount.toStringAsFixed(2)}',
      style: TextStyle(
        color: AppTheme.ink,
        fontSize: large ? 20 : 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/product.dart';

class MockData {
  static const categories = <CategoryInfo>[
    CategoryInfo('All', Icons.grid_view_rounded, Color(0xFFE8F2E9)),
    CategoryInfo('Plants', Icons.spa_rounded, Color(0xFFE5F0E4)),
    CategoryInfo('Furniture', Icons.chair_rounded, Color(0xFFF3EBDD)),
    CategoryInfo('Lighting', Icons.light_rounded, Color(0xFFFFF0D6)),
    CategoryInfo('Decor', Icons.brush_rounded, Color(0xFFF3E8E4)),
    CategoryInfo('Kitchen', Icons.coffee_rounded, Color(0xFFE5EDF4)),
  ];

  static const products = <Product>[
    Product(
      id: 'p1',
      name: 'Monstera Deliciosa',
      category: 'Plants',
      price: 32,
      oldPrice: 42,
      rating: 4.9,
      reviews: 128,
      imageUrl:
          'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=700',
      color: Color(0xFFE2EFE4),
      description:
          'A leafy statement plant that brings a little calm to every corner. Easy to care for and happy in bright, indirect light.',
    ),
    Product(
      id: 'p2',
      name: 'Sculpted Lounge Chair',
      category: 'Furniture',
      price: 249,
      oldPrice: 299,
      rating: 4.8,
      reviews: 86,
      imageUrl:
          'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=700',
      color: Color(0xFFF1E5D6),
      description:
          'A beautifully considered chair with a soft, supportive silhouette. Designed for slow mornings and long conversations.',
    ),
    Product(
      id: 'p3',
      name: 'Mellow Table Lamp',
      category: 'Lighting',
      price: 68,
      oldPrice: 84,
      rating: 4.7,
      reviews: 54,
      imageUrl:
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=700',
      color: Color(0xFFFFEFCF),
      description:
          'Warm ambient light with a simple sculptural shape. The perfect bedside companion for winding down.',
    ),
    Product(
      id: 'p4',
      name: 'Cloud Ceramic Vase',
      category: 'Decor',
      price: 38,
      oldPrice: 48,
      rating: 4.9,
      reviews: 103,
      imageUrl:
          'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?w=700',
      color: Color(0xFFF1E7E0),
      description:
          'Hand-finished ceramic with a tactile matte glaze. Lovely on its own or filled with a few stems from the garden.',
    ),
    Product(
      id: 'p5',
      name: 'Oak Coffee Table',
      category: 'Furniture',
      price: 189,
      oldPrice: 229,
      rating: 4.8,
      reviews: 72,
      imageUrl:
          'https://images.unsplash.com/photo-1499933374294-4584851497cc?w=700',
      color: Color(0xFFF2E8D9),
      description:
          'Solid oak warmth meets clean, contemporary lines. A versatile centrepiece for relaxed living spaces.',
    ),
    Product(
      id: 'p6',
      name: 'Everyday Stoneware Set',
      category: 'Kitchen',
      price: 54,
      oldPrice: 69,
      rating: 4.6,
      reviews: 41,
      imageUrl:
          'https://images.unsplash.com/photo-1490312278390-ab64016e0aa9?w=700',
      color: Color(0xFFE5EDF2),
      description:
          'A set of four thoughtfully made stoneware pieces for everyday rituals, from a slow coffee to dinner with friends.',
    ),
    Product(
      id: 'p7',
      name: 'Olive Branch Plant',
      category: 'Plants',
      price: 45,
      oldPrice: 55,
      rating: 4.7,
      reviews: 63,
      imageUrl:
          'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=700',
      color: Color(0xFFE7F0E6),
      description:
          'Soft olive-green foliage and a graceful shape make this an effortless addition to your home.',
    ),
    Product(
      id: 'p8',
      name: 'Linen Cushion Cover',
      category: 'Decor',
      price: 26,
      oldPrice: 34,
      rating: 4.8,
      reviews: 90,
      imageUrl:
          'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=700',
      color: Color(0xFFF3E9E2),
      description:
          'Soft, breathable linen with a relaxed texture. An easy way to give your favourite sofa a fresh feel.',
    ),
  ];
}

class CategoryInfo {
  const CategoryInfo(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}

import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.color,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;
  final String imageUrl;
  final Color color;
  final String description;
}

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;
  double get total => product.price * quantity;
}

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = 'On the way',
  });

  final String id;
  final DateTime date;
  final List<CartLine> items;
  final double total;
  final String status;
}

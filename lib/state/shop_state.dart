import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/product.dart';

class ShopState extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};
  final List<OrderRecord> _orders = [];

  List<CartLine> get cartLines => _cart.entries
      .map(
        (entry) =>
            CartLine(product: _productFor(entry.key), quantity: entry.value),
      )
      .toList(growable: false);

  int get cartCount => _cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get subtotal => cartLines.fold(0, (sum, line) => sum + line.total);
  Set<String> get favorites => Set.unmodifiable(_favorites);
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  void addToCart(Product product) {
    _cart.update(product.id, (quantity) => quantity + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void changeQuantity(Product product, int delta) {
    final next = (_cart[product.id] ?? 0) + delta;
    if (next <= 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = next;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product.id);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (!_favorites.add(product.id)) _favorites.remove(product.id);
    notifyListeners();
  }

  bool isFavorite(Product product) => _favorites.contains(product.id);

  OrderRecord placeOrder() {
    final items = cartLines;
    final order = OrderRecord(
      id: 'CM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      items: items,
      total: subtotal + (subtotal == 0 ? 0 : 6.50),
      status: 'Preparing',
    );
    _orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    return order;
  }

  Product _productFor(String id) =>
      MockData.products.firstWhere((product) => product.id == id);
}

class ShopScope extends InheritedNotifier<ShopState> {
  const ShopScope({
    required ShopState notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static ShopState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShopScope>();
    assert(scope != null, 'ShopScope is missing above this context.');
    return scope!.notifier!;
  }
}

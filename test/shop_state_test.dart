import 'package:clickme/data/mock_data.dart';
import 'package:clickme/state/shop_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ShopState shop;

  setUp(() => shop = ShopState());
  tearDown(() => shop.dispose());

  test('cart quantities, subtotal, and order placement stay in sync', () {
    final plant = MockData.products.first;
    shop.addToCart(plant);
    shop.addToCart(plant);

    expect(shop.cartCount, 2);
    expect(shop.subtotal, plant.price * 2);

    shop.changeQuantity(plant, -1);
    expect(shop.cartCount, 1);

    final order = shop.placeOrder();
    expect(order.items.single.quantity, 1);
    expect(order.total, plant.price + 6.50);
    expect(shop.cartCount, 0);
    expect(shop.orders.single.id, order.id);
  });

  test('favourites can be toggled on and off', () {
    final product = MockData.products.first;

    shop.toggleFavorite(product);
    expect(shop.isFavorite(product), isTrue);
    expect(shop.favorites, contains(product.id));

    shop.toggleFavorite(product);
    expect(shop.isFavorite(product), isFalse);
    expect(shop.favorites, isEmpty);
  });
}

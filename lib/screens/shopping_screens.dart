import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import '../widgets/common_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final lines = shop.cartLines;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your bag'),
        actions: [
          if (lines.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  '${shop.cartCount} items',
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: lines.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your bag is taking a little break',
              subtitle:
                  'When you find something you love, it’ll be waiting here.',
              actionLabel: 'Explore the collection',
              onAction: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (_) => false,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                    itemCount: lines.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) =>
                        _CartLineCard(line: lines[index]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const _SummaryRow(label: 'Subtotal', value: null),
                        _SummaryRow(
                          label: 'Delivery',
                          value: shop.subtotal >= 75 ? 'FREE' : '\$6.50',
                          green: shop.subtotal >= 75,
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            MoneyText(
                              shop.subtotal + (shop.subtotal >= 75 ? 0 : 6.50),
                              large: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          ),
                          child: const Text('Continue to checkout'),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Free delivery on orders over \$75',
                          style: TextStyle(color: AppTheme.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({required this.line});
  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F1EE)),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 88,
              height: 96,
              child: ProductImage(product: line.product),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 9,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  line.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                MoneyText(line.product.price),
                const SizedBox(height: 7),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () => shop.changeQuantity(line.product, -1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${line.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () => shop.changeQuantity(line.product, 1),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => shop.removeFromCart(line.product),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: AppTheme.paleGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.green, size: 15),
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Alex Morgan');
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _zip = TextEditingController();
  int _payment = 0;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _city.dispose();
    _zip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final delivery = shop.subtotal >= 75 ? 0.0 : 6.50;
    final total = shop.subtotal + delivery;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            const _CheckoutHeading(
              number: '01',
              title: 'Delivery details',
              subtitle: 'Where should we bring the good stuff?',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Street address',
                prefixIcon: Icon(Icons.home_outlined),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: _required,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 116,
                  child: TextFormField(
                    controller: _zip,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'ZIP code'),
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            const _CheckoutHeading(
              number: '02',
              title: 'Payment method',
              subtitle: 'Choose how you’d like to pay.',
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              title: 'Credit or debit card',
              subtitle: 'Visa, Mastercard, Amex',
              icon: Icons.credit_card_rounded,
              selected: _payment == 0,
              onTap: () => setState(() => _payment = 0),
            ),
            const SizedBox(height: 9),
            _PaymentOption(
              title: 'Cash on delivery',
              subtitle: 'Pay when your order arrives',
              icon: Icons.payments_outlined,
              selected: _payment == 1,
              onTap: () => setState(() => _payment = 1),
            ),
            const SizedBox(height: 27),
            const _CheckoutHeading(
              number: '03',
              title: 'Order summary',
              subtitle: 'A lovely choice, if we may say so.',
            ),
            const SizedBox(height: 13),
            ...shop.cartLines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${line.product.name}  ×  ${line.quantity}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    MoneyText(line.total),
                  ],
                ),
              ),
            ),
            const Divider(height: 25),
            _SummaryRow(
              label: 'Subtotal',
              value: '\$${shop.subtotal.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: 'Delivery',
              value: delivery == 0
                  ? 'FREE'
                  : '\$${delivery.toStringAsFixed(2)}',
              green: delivery == 0,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                MoneyText(total, large: true),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (shop.cartLines.isEmpty) {
                  Navigator.pop(context);
                  return;
                }
                if (!_formKey.currentState!.validate()) return;
                final order = shop.placeOrder();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => OrderSuccessScreen(order: order),
                  ),
                );
              },
              child: Text('Place order · \$${total.toStringAsFixed(2)}'),
            ),
            const SizedBox(height: 9),
            const Center(
              child: Text(
                'Secure checkout · This is a demo, no real payment is taken',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.muted, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: const BoxDecoration(
                  color: AppTheme.paleGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppTheme.green,
                  size: 55,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'A little joy is\non its way!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.ink,
                  fontSize: 32,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your order is confirmed. We can’t wait for you to see it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.muted, height: 1.5),
              ),
              const SizedBox(height: 23),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF0F1EE)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ORDER NUMBER',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '#${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(child: Text('${order.items.length} items')),
                        MoneyText(order.total),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (_) => false,
                ),
                child: const Text('Back to home'),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => route.isFirst,
                ),
                child: const Text('Continue shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = ShopScope.of(context).orders;
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: orders.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              subtitle: 'Your next favourite find is just around the corner.',
              actionLabel: 'Start exploring',
              onAction: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (_) => false,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final OrderRecord order;

  @override
  Widget build(BuildContext context) {
    final date = order.date;
    final dateLabel = '${_month(date.month)} ${date.day}, ${date.year}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFF0F1EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.paleGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    color: AppTheme.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            dateLabel,
            style: const TextStyle(color: AppTheme.muted, fontSize: 12),
          ),
          const Divider(height: 24),
          Row(
            children: [
              ...order.items
                  .take(3)
                  .map(
                    (line) => Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(right: 7),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: line.product.color,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: ProductImage(product: line.product),
                    ),
                  ),
              if (order.items.length > 3)
                Text(
                  '+${order.items.length - 3}',
                  style: const TextStyle(color: AppTheme.muted),
                ),
              const Spacer(),
              MoneyText(order.total),
            ],
          ),
        ],
      ),
    );
  }

  String _month(int number) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][number];
}

class _CheckoutHeading extends StatelessWidget {
  const _CheckoutHeading({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppTheme.paleGreen,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppTheme.green,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected ? AppTheme.paleGreen : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? AppTheme.green : const Color(0xFFE9ECE8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.green, size: 21),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppTheme.green : AppTheme.muted,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.green = false,
  });

  final String label;
  final String? value;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final shownValue = label == 'Subtotal'
        ? '\$${shop.subtotal.toStringAsFixed(2)}'
        : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
          ),
          Text(
            shownValue ?? '',
            style: TextStyle(
              color: green ? AppTheme.green : AppTheme.ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../state/shop_state.dart';
import 'browse_screens.dart';
import 'home_screen.dart';
import 'profile_screens.dart';
import 'shopping_screens.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});
  static const routeName = '/home';

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _selectedIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final pages = [
      HomeScreen(onOpenCategories: () => setState(() => _selectedIndex = 1)),
      const CategoriesScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.paleGreen,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: _CartNavIcon(count: shop.cartCount),
            selectedIcon: _CartNavIcon(count: shop.cartCount, selected: true),
            label: 'Bag',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CartNavIcon extends StatelessWidget {
  const _CartNavIcon({required this.count, this.selected = false});
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: Icon(
        selected ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined,
      ),
    );
  }
}

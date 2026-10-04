import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/mock_data.dart';
import '../state/shop_state.dart';
import '../widgets/common_widgets.dart';
import 'auth_screens.dart';
import 'browse_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.green,
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .17),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Morgan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'alex.morgan@email.com',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showMessage(
                    context,
                    'Profile editing is part of this demo.',
                  ),
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'Your account'),
          const SizedBox(height: 10),
          _ProfileOption(
            icon: Icons.receipt_long_outlined,
            title: 'My orders',
            subtitle: '${shop.orders.length} orders',
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          _ProfileOption(
            icon: Icons.favorite_border_rounded,
            title: 'Saved items',
            subtitle: '${shop.favorites.length} lovely finds',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SavedItemsScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.location_on_outlined,
            title: 'Delivery addresses',
            subtitle: 'Manage your saved places',
            onTap: () => _showMessage(context, 'Brooklyn, NY · Home'),
          ),
          _ProfileOption(
            icon: Icons.credit_card_outlined,
            title: 'Payment methods',
            subtitle: 'Manage your payment options',
            onTap: () => _showMessage(
              context,
              'Demo checkout supports card or cash on delivery.',
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeading(title: 'A little help'),
          const SizedBox(height: 10),
          _ProfileOption(
            icon: Icons.support_agent_rounded,
            title: 'Help & support',
            subtitle: 'We’re always happy to help',
            onTap: () =>
                _showMessage(context, 'Our demo support team is here for you.'),
          ),
          _ProfileOption(
            icon: Icons.info_outline_rounded,
            title: 'About ClickMe',
            subtitle: 'Thoughtful things for your home',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'ClickMe',
              applicationVersion: '1.0.0',
              applicationIcon: const ClickMeLogo(compact: true),
              children: const [
                Text('A friendly home and lifestyle shopping demo.'),
              ],
            ),
          ),
          const SizedBox(height: 17),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              LoginScreen.routeName,
              (_) => false,
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFB64F4A),
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: Color(0xFFF0DAD7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'MADE WITH A LITTLE HEART  ·  CLICKME',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.paleGreen,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: AppTheme.green, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: const TextStyle(color: AppTheme.muted, fontSize: 11),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.muted,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ShopScope.of(context).favorites;
    final products = MockData.products
        .where((product) => favoriteIds.contains(product.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Saved items')),
      body: products.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Nothing saved just yet',
              subtitle: 'Tap the heart on anything you love to save it here.',
            )
          : GridView.builder(
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

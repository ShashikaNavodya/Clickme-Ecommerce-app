import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/auth_screens.dart';
import 'screens/main_shell.dart';
import 'state/shop_state.dart';

class ClickMeApp extends StatefulWidget {
  const ClickMeApp({super.key});

  @override
  State<ClickMeApp> createState() => _ClickMeAppState();
}

class _ClickMeAppState extends State<ClickMeApp> {
  final ShopState _shopState = ShopState();

  @override
  void dispose() {
    _shopState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShopScope(
      notifier: _shopState,
      child: MaterialApp(
        title: 'ClickMe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
          MainShell.routeName: (_) => const MainShell(),
          '/cart': (_) => const MainShell(initialIndex: 2),
          '/orders': (_) => const MainShell(initialIndex: 3),
        },
      ),
    );
  }
}

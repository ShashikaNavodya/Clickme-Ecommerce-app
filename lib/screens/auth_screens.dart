import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.green,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ClickMeLogo(light: true),
            const SizedBox(height: 16),
            Text(
              'A little joy for your everyday.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .78),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 46),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainShell.routeName,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'WELCOME BACK',
      title: 'Good to see\nyou again.',
      subtitle: 'Sign in to pick up where your home story left off.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthLabel('Email address'),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'hello@example.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(child: AuthLabel('Password')),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ForgotPasswordScreen.routeName,
                    ),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              TextFormField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.length < 6
                    ? 'Use at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _continue,
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New to ClickMe? ',
              style: TextStyle(color: AppTheme.muted),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RegisterScreen.routeName),
              child: const Text('Create account'),
            ),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: _continueAsGuest,
            child: const Text('Continue as a guest'),
          ),
        ),
      ],
    );
  }

  void _continueAsGuest() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainShell.routeName,
      (_) => false,
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'JOIN THE GOOD LIFE',
      title: 'Make yourself\nat home.',
      subtitle: 'Create an account and find your next favourite thing.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthLabel('Your name'),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Alex Morgan',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              const AuthLabel('Email address'),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'hello@example.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              const AuthLabel('Password'),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'At least 6 characters',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
                validator: (value) => value == null || value.length < 6
                    ? 'Use at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MainShell.routeName,
                      (_) => false,
                    );
                  }
                },
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: AppTheme.muted),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'PASSWORD RESET',
      title: _sent ? 'Check your\ninbox.' : 'Forgot your\npassword?',
      subtitle: _sent
          ? 'In this demo, your reset link is ready to be sent to ${_email.text}.'
          : 'No worries. Enter your email and we’ll help you get back in.',
      children: [
        if (!_sent) ...[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthLabel('Email address'),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'hello@example.com',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Enter a valid email address'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _sent = true);
                    }
                  },
                  child: const Text('Send reset link'),
                ),
              ],
            ),
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.paleGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.mark_email_read_outlined, color: AppTheme.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This is a demo screen. No email is actually sent.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Back to sign in'),
          ),
        ),
      ],
    );
  }
}

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Spacer(),
                  const ClickMeLogo(compact: true),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                eyebrow,
                style: const TextStyle(
                  color: AppTheme.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 35,
                  height: 1.08,
                  letterSpacing: -1.1,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 30),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class AuthLabel extends StatelessWidget {
  const AuthLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: AppTheme.ink,
        ),
      ),
    );
  }
}

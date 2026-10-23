import 'package:flutter/material.dart';

import 'home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const HomeShell(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0.0, 1.0).toDouble(),
            child: Transform.scale(scale: 0.8 + 0.2 * value, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.style_rounded,
                    size: 64, color: scheme.onPrimary),
              ),
              const SizedBox(height: 24),
              Text(
                'Flashcard Quiz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Learn smarter, one card at a time',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
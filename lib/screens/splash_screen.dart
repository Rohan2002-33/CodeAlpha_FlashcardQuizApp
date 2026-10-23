import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
                child: Icon(
                  Icons.style_rounded,
                  size: 64,
                  color: scheme.onPrimary,
                ),
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
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

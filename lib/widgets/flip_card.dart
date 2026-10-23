import 'dart:math';

import 'package:flutter/material.dart';

/// Card that flips in 3D between [front] and [back].
class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.showBack,
    required this.front,
    required this.back,
    this.onTap,
  });

  final bool showBack;
  final Widget front;
  final Widget back;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: showBack ? 1 : 0),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
        builder: (context, value, _) {
          final isBack = value >= 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * pi),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: back,
                  )
                : front,
          );
        },
      ),
    );
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable glassmorphism card widget with frosted effect and subtle glow border.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? glowColor;
  final double blurAmount;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.glowColor,
    this.blurAmount = 12,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? AppTheme.accentOrange;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withValues(alpha: opacity),
            border: Border.all(
              color: glow.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: glow.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: -4,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

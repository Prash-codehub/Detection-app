import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'detection_screen.dart';

/// Home / landing screen with hero section, feature cards, and CTA button.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToDetection() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const DetectionScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // ── Hero Section ──
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: AppTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppTheme.accentOrange.withValues(alpha: 0.35),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fastfood_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.primaryGradient.createShader(bounds),
                        child: Text(
                          'SnackSpotter',
                          style: AppTheme.displayLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Real-time AI snack detection\npowered by YOLOv8',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Detectable Items ──
                    Text(
                      'WHAT IT DETECTS',
                      style: AppTheme.labelSmall.copyWith(
                        letterSpacing: 3,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSnackCard(
                      icon: '🟠',
                      name: 'Bhujiya',
                      description: 'Crunchy sev & bhujiya snacks',
                      color: AppTheme.accentOrange,
                    ),
                    const SizedBox(height: 12),
                    _buildSnackCard(
                      icon: '🔵',
                      name: 'Dorito',
                      description: 'Triangular tortilla chips',
                      color: AppTheme.accentCyan,
                    ),
                    const SizedBox(height: 12),
                    _buildSnackCard(
                      icon: '🔴',
                      name: 'Maggie Masala',
                      description: 'Instant noodle seasoning packs',
                      color: AppTheme.accentPink,
                    ),
                    const SizedBox(height: 48),

                    // ── CTA Button ──
                    Center(
                      child: _AnimatedGlowButton(
                        label: 'Start Detecting',
                        icon: Icons.camera_alt_rounded,
                        onPressed: _navigateToDetection,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Footer info ──
                    Center(
                      child: Text(
                        'Model: YOLOv8n · INT8 Quantized · TFLite',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textMuted.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSnackCard({
    required String icon,
    required String name,
    required String description,
    required Color color,
  }) {
    return GlassCard(
      glowColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: color.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.headlineMedium.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated CTA button with a pulsing glow effect.
class _AnimatedGlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _AnimatedGlowButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_AnimatedGlowButton> createState() => _AnimatedGlowButtonState();
}

class _AnimatedGlowButtonState extends State<_AnimatedGlowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentOrange
                    .withValues(alpha: _glowAnimation.value),
                blurRadius: 24,
                spreadRadius: -2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: AppTheme.primaryGradient,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: AppTheme.labelLarge.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

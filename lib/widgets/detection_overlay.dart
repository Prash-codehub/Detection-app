import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Floating overlay panel showing real-time detection statistics.
/// Displays the count of each detected class with animated transitions.
class DetectionOverlay extends StatelessWidget {
  final Map<String, int> detectionCounts;
  final double fps;
  final int totalDetections;

  const DetectionOverlay({
    super.key,
    required this.detectionCounts,
    required this.fps,
    required this.totalDetections,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.primaryDark.withValues(alpha: 0.7),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with FPS
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fps > 15
                          ? AppTheme.accentGreen
                          : AppTheme.accentOrange,
                      boxShadow: [
                        BoxShadow(
                          color: (fps > 15
                                  ? AppTheme.accentGreen
                                  : AppTheme.accentOrange)
                              .withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE',
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.accentGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${fps.toStringAsFixed(0)} FPS',
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              if (totalDetections > 0) ...[
                const SizedBox(height: 10),
                // Detection counts per class
                ...detectionCounts.entries.map((entry) {
                  final color = AppTheme.getClassColor(entry.key);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatClassName(entry.key),
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: color.withValues(alpha: 0.2),
                          ),
                          child: Text(
                            '${entry.value}',
                            style: AppTheme.bodyMedium.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  'Point camera at snacks...',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatClassName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../theme/app_theme.dart';
import '../widgets/detection_overlay.dart';

/// Full-screen live detection view using YOLOView with custom overlay controls.
class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with SingleTickerProviderStateMixin {
  final YOLOViewController _yoloController = YOLOViewController();

  // Detection state
  Map<String, int> _detectionCounts = {};
  int _totalDetections = 0;
  double _fps = 0;
  double _confidenceThreshold = 0.5;
  bool _showControls = true;

  // For FPS calculation
  DateTime? _lastResultTime;
  final List<double> _fpsBuffer = [];

  late final AnimationController _controlsAnimController;
  late final Animation<double> _controlsFade;

  @override
  void initState() {
    super.initState();
    _controlsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _controlsFade = CurvedAnimation(
      parent: _controlsAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controlsAnimController.dispose();
    super.dispose();
  }

  void _onResults(List<YOLOResult> results) {
    // Calculate FPS
    final now = DateTime.now();
    if (_lastResultTime != null) {
      final elapsed = now.difference(_lastResultTime!).inMilliseconds;
      if (elapsed > 0) {
        final currentFps = 1000.0 / elapsed;
        _fpsBuffer.add(currentFps);
        if (_fpsBuffer.length > 10) _fpsBuffer.removeAt(0);
        _fps = _fpsBuffer.reduce((a, b) => a + b) / _fpsBuffer.length;
      }
    }
    _lastResultTime = now;

    // Count detections per class
    final counts = <String, int>{};
    for (final r in results) {
      if (r.confidence >= _confidenceThreshold) {
        final name = r.className;
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }

    if (mounted) {
      setState(() {
        _detectionCounts = counts;
        _totalDetections = counts.values.fold(0, (a, b) => a + b);
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _controlsAnimController.forward();
    } else {
      _controlsAnimController.reverse();
    }
  }

  void _showThresholdSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ThresholdBottomSheet(
        currentValue: _confidenceThreshold,
        onChanged: (val) {
          setState(() {
            _confidenceThreshold = val;
          });
          _yoloController.setConfidenceThreshold(val);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen YOLO Camera View ──
          Positioned.fill(
            child: YOLOView(
              modelPath: 'assets/models/best_int8.tflite',
              task: YOLOTask.detect,
              controller: _yoloController,
              onResult: _onResults,
            ),
          ),

          // ── Tap to toggle controls ──
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleControls,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // ── Top controls ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _controlsFade,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryDark.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Back button
                    _CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SnackSpotter',
                            style: AppTheme.headlineMedium.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'YOLOv8n · INT8',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Settings
                    _CircleIconButton(
                      icon: Icons.tune_rounded,
                      onPressed: _showThresholdSheet,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Detection overlay (top-left) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            child: FadeTransition(
              opacity: _controlsFade,
              child: DetectionOverlay(
                detectionCounts: _detectionCounts,
                fps: _fps,
                totalDetections: _totalDetections,
              ),
            ),
          ),

          // ── Bottom total count badge ──
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _controlsFade,
              child: Center(
                child: _TotalCountBadge(count: _totalDetections),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular icon button with glass effect.
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.1),
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white12),
          ),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 22, color: AppTheme.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

/// Total detection count badge shown at the bottom.
class _TotalCountBadge extends StatelessWidget {
  final int count;

  const _TotalCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: count > 0
                ? AppTheme.accentOrange.withValues(alpha: 0.2)
                : AppTheme.primaryDark.withValues(alpha: 0.6),
            border: Border.all(
              color: count > 0
                  ? AppTheme.accentOrange.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                count > 0 ? Icons.check_circle_rounded : Icons.search_rounded,
                size: 20,
                color:
                    count > 0 ? AppTheme.accentOrange : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                count > 0
                    ? '$count item${count != 1 ? 's' : ''} detected'
                    : 'Scanning...',
                style: AppTheme.labelLarge.copyWith(
                  color:
                      count > 0 ? AppTheme.accentOrange : AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for adjusting the confidence threshold.
class _ThresholdBottomSheet extends StatefulWidget {
  final double currentValue;
  final ValueChanged<double> onChanged;

  const _ThresholdBottomSheet({
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<_ThresholdBottomSheet> createState() => _ThresholdBottomSheetState();
}

class _ThresholdBottomSheetState extends State<_ThresholdBottomSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppTheme.textMuted.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 20),
          Text('Detection Settings', style: AppTheme.headlineMedium),
          const SizedBox(height: 24),

          // Confidence threshold
          Row(
            children: [
              Text(
                'Confidence',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.accentOrange.withValues(alpha: 0.15),
                ),
                child: Text(
                  '${(_value * 100).toStringAsFixed(0)}%',
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.accentOrange,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.accentOrange,
              inactiveTrackColor: AppTheme.textMuted.withValues(alpha: 0.2),
              thumbColor: AppTheme.accentOrange,
              overlayColor: AppTheme.accentOrange.withValues(alpha: 0.15),
              trackHeight: 4,
            ),
            child: Slider(
              value: _value,
              min: 0.1,
              max: 0.95,
              onChanged: (v) {
                setState(() => _value = v);
                widget.onChanged(v);
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('More detections',
                  style: AppTheme.labelSmall
                      .copyWith(color: AppTheme.textMuted)),
              Text('Higher accuracy',
                  style: AppTheme.labelSmall
                      .copyWith(color: AppTheme.textMuted)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          ),
        ],
      ),
    );
  }
}

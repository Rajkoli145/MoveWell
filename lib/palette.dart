import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const bg = Color(0xFFE9F2F9);
  static const launchBg = Color(0xFFF0F8FF);
  static const cardTint = Color(0xFFE6F2FD);
  static const ink = Color(0xFF111827);
  static const primary = Color(0xFF1F2937);
  static const moveBlue = Color(0xFF5B8FC4);
  static const lightBlue = Color(0xFFDCEFFF);
  static const slate = Color(0xFF55677A);
  static const secondary = Color(0xFF6B829A);
  static const faint = Color(0xFF647590);
  static const border = Color(0xFFD8E6F2);
  static const surface = Color(0xFFFFFFFF);
  static const softBlue = Color(0xFFC5D6E5);
  static const iconFill = Color(0xFFC0DCEE);
  static const iconGlyph = Color(0xFF2E4257);
  static const featTitle = Color(0xFF202738);
  static const featSub = Color(0xFF3D4E62);
  static const skyBlue = Color(0xFFA2D9FC);
}

class AppAssets {
  static const logo = 'assets/icons/logo1.png';
  static const hero = 'assets/images/hero.png';
  static const onboard = 'assets/images/onboard.png';
  static const bottleLogin = 'assets/images/bottle_login.png';
  static const forgotPasswordHero = 'assets/images/forgot_password_hero.png';
  static const avatar = 'assets/images/avatar.png';
  static const workoutHero = 'assets/images/workout_hero.png';
  static const exerciseGuide = 'assets/references/artwork/girl.png';
  static const exercisesLevelGrid = 'assets/images/exercises_level_grid.png';
  static const exercisesCardioYogaGrid =
      'assets/images/exercises_cardio_yoga_grid.png';
  static const exercisesCoreMobilityGrid =
      'assets/images/exercises_core_mobility_grid.png';
  static const articleNutrition = 'assets/images/article_nutrition.png';
  static const articleConsistency = 'assets/images/article_consistency.png';
  static const articleRoutine = 'assets/images/article_routine.png';
}

class AppAvatarImage extends StatelessWidget {
  const AppAvatarImage({
    super.key,
    required this.avatarPath,
    this.fit = BoxFit.cover,
    this.placeholderColor = const Color(0xFFD6EDFC),
    this.iconColor = Palette.ink,
  });

  final String avatarPath;
  final BoxFit fit;
  final Color placeholderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final clean = avatarPath.trim();
    if (clean.startsWith('data:image')) {
      try {
        final comma = clean.indexOf(',');
        if (comma != -1) {
          final bytes = base64Decode(clean.substring(comma + 1));
          return Image.memory(
            bytes,
            fit: fit,
            errorBuilder: (_, _, _) => _placeholder(),
          );
        }
      } catch (_) {}
    }
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return Image.network(
        clean,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return Image.asset(
      clean.isEmpty ? AppAssets.avatar : clean,
      fit: fit,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
    color: placeholderColor,
    alignment: Alignment.center,
    child: Icon(Icons.person, color: iconColor),
  );
}

class MoveWellLogo extends StatelessWidget {
  const MoveWellLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, width: 44, height: 44),
        const SizedBox(height: 8),
        Text(
          'MoveWell',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
            color: Palette.ink,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'A HEALTHIER YOU, EVERYDAY',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
            color: Palette.secondary,
          ),
        ),
      ],
    );
  }
}

/// Universal Professional Slide Action Pill Button:
/// - Smooth left-to-right dragging matching brand palette
/// - Grounded, solid resting knob (no floating drift)
/// - Snappy, instant checkmark completion without sluggish delays
class SlideActionPillButton extends StatefulWidget {
  const SlideActionPillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52.0,
    this.backgroundColor = const Color(0xFF1E2430),
    this.knobColor = const Color(0xFFA2D9FC),
    this.iconColor = const Color(0xFF101419),
    this.fontSize = 15.0,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final Color backgroundColor;
  final Color knobColor;
  final Color iconColor;
  final double fontSize;

  @override
  State<SlideActionPillButton> createState() => _SlideActionPillButtonState();
}

class _SlideActionPillButtonState extends State<SlideActionPillButton>
    with TickerProviderStateMixin {
  late final AnimationController _springController;
  late final AnimationController _holdController;
  final ValueNotifier<double> _dragProgress = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> _isCompleted = ValueNotifier<bool>(false);

  Animation<double>? _springAnim;
  bool _navigating = false;
  double _pointerStartX = 0.0;
  double _startDragProgress = 0.0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _springController.addListener(() {
      if (_springAnim != null) {
        _dragProgress.value = _springAnim!.value;
      }
    });

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _holdController.addListener(() {
      if (!_navigating) {
        _dragProgress.value = _holdController.value;
      }
    });
    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_navigating) {
        _triggerComplete();
      }
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _springController.dispose();
    _holdController.dispose();
    _dragProgress.dispose();
    _isCompleted.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!mounted || _navigating) return;
    _resetTimer?.cancel();
    _springController.stop();
    _springAnim = null;
    _pointerStartX = event.position.dx;
    _startDragProgress = _dragProgress.value;

    final current = _dragProgress.value;
    final remaining = (1.0 - current).clamp(0.0, 1.0);
    final durationMs = (remaining * 650).round().clamp(60, 650);
    _holdController.duration = Duration(milliseconds: durationMs);
    _holdController.forward(from: current);
  }

  void _onPointerMove(PointerMoveEvent event, double maxDrag) {
    if (!mounted || _navigating) return;
    final deltaX = event.position.dx - _pointerStartX;
    if (deltaX.abs() > 3.0) {
      _holdController.stop();
      _springController.stop();
      _springAnim = null;
      final nextVal = (_startDragProgress + deltaX / maxDrag).clamp(0.0, 1.0);
      _dragProgress.value = nextVal;
    }
  }

  void _onPointerUpOrCancel() {
    if (!mounted || _navigating) return;
    _holdController.stop();

    if (_dragProgress.value >= 0.60) {
      _triggerComplete();
    } else {
      _resetToStart();
    }
  }

  void _triggerComplete() {
    if (!mounted || _navigating) return;
    _navigating = true;
    _holdController.stop();
    _springController.stop();

    _dragProgress.value = 1.0;
    _isCompleted.value = true;
    widget.onTap();

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _isCompleted.value = false;
      _dragProgress.value = 0.0;
      _navigating = false;
    });
  }

  void _resetToStart() {
    if (!mounted) return;
    _springAnim = Tween<double>(begin: _dragProgress.value, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.easeOutQuad),
    );

    _springController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final double btnH = widget.height;
    final double padding = btnH <= 30.0 ? 2.0 : (btnH <= 36.0 ? 3.0 : (btnH < 44.0 ? 4.0 : 6.0));
    final double knobSize = btnH - (padding * 2);
    final double iconSize = (knobSize * 0.50).clamp(10.0, 22.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = (constraints.maxWidth - knobSize - (padding * 2))
            .clamp(10.0, 600.0);

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _onPointerDown,
          onPointerMove: (event) => _onPointerMove(event, maxDrag),
          onPointerUp: (_) => _onPointerUpOrCancel(),
          onPointerCancel: (_) => _onPointerUpOrCancel(),
          child: Container(
            width: double.infinity,
            height: btnH,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(btnH / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // 1. Subtle smooth brand-colored progress fill
                ValueListenableBuilder<double>(
                  valueListenable: _dragProgress,
                  builder: (context, progress, _) {
                    final trackWidth =
                        (padding + knobSize + (progress * maxDrag)).clamp(
                          knobSize,
                          constraints.maxWidth,
                        );
                    return Container(
                      width: trackWidth,
                      height: btnH,
                      decoration: BoxDecoration(
                        color: widget.knobColor.withValues(
                          alpha: (0.10 + 0.15 * progress).clamp(0.0, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(btnH / 2),
                      ),
                    );
                  },
                ),

                // 2. Centered Typography with soft fade
                ValueListenableBuilder<double>(
                  valueListenable: _dragProgress,
                  builder: (context, progress, child) {
                    final opacity = (1.0 - progress * 1.6).clamp(0.0, 1.0);
                    return Opacity(opacity: opacity, child: child);
                  },
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: knobSize * 0.4),
                        Text(
                          widget.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Crisp, Grounded Draggable Knob in MoveWell Sky Blue
                Positioned(
                  left: padding,
                  top: padding,
                  child: ValueListenableBuilder<double>(
                    valueListenable: _dragProgress,
                    builder: (context, progress, _) {
                      return Transform.translate(
                        offset: Offset(progress * maxDrag, 0),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isCompleted,
                          builder: (context, completed, child) {
                            return Container(
                              width: knobSize,
                              height: knobSize,
                              decoration: BoxDecoration(
                                color: widget.knobColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.16),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  completed
                                      ? Icons.check_rounded
                                      : Icons.arrow_forward_rounded,
                                  key: ValueKey(completed ? 'check' : 'arrow'),
                                  size: iconSize,
                                  color: widget.iconColor,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated floating organic blue wave background
class FloatingWaveBackground extends StatefulWidget {
  const FloatingWaveBackground({
    super.key,
    this.height = 320.0,
  });

  final double height;

  @override
  State<FloatingWaveBackground> createState() => _FloatingWaveBackgroundState();
}

class _FloatingWaveBackgroundState extends State<FloatingWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: AppTopWavePainter(animationValue: _controller.value),
            size: Size(double.infinity, widget.height),
          );
        },
      ),
    );
  }
}

/// Organic, smooth light blue top-right wave background painter
/// Matching the exact curved shape and soft gradient from the MoveWell design references.
class AppTopWavePainter extends CustomPainter {
  const AppTopWavePainter({this.animationValue = 0.0});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final offset = (animationValue - 0.5) * 16.0;
    final waveShift = math.sin(animationValue * 2 * math.pi) * 10.0;

    // 1. Primary soft light-blue wave
    final primaryWavePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFDBEDFC), Color(0xFFE8F3FD)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(w * 0.40 + waveShift, 0);
    path1.cubicTo(
      w * 0.48 + waveShift * 0.8, h * 0.20 + offset,
      w * 0.26 - waveShift * 0.5, h * 0.46 + offset,
      w * 0.46 + waveShift * 0.6, h * 0.76 + offset,
    );
    path1.cubicTo(
      w * 0.56 + waveShift * 0.4, h * 0.90 + offset,
      w * 0.76 - waveShift * 0.3, h * 0.97 + offset,
      w, h * 0.92 + offset,
    );
    path1.lineTo(w, 0);
    path1.close();

    canvas.drawPath(path1, primaryWavePaint);

    // 2. Secondary delicate inner wave accent
    final accentWavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFCCE4FA).withValues(alpha: 0.65),
          const Color(0xFFE2F0FD).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(w * 0.58 - waveShift * 0.6, 0);
    path2.cubicTo(
      w * 0.64 - waveShift * 0.5, h * 0.22 - offset * 0.7,
      w * 0.42 + waveShift * 0.7, h * 0.48 - offset * 0.7,
      w * 0.62 - waveShift * 0.4, h * 0.78 - offset * 0.7,
    );
    path2.cubicTo(
      w * 0.72 + waveShift * 0.3, h * 0.92 - offset * 0.7,
      w * 0.88 - waveShift * 0.2, h * 0.98 - offset * 0.7,
      w, h * 0.96 - offset * 0.7,
    );
    path2.lineTo(w, 0);
    path2.close();

    canvas.drawPath(path2, accentWavePaint);
  }

  @override
  bool shouldRepaint(covariant AppTopWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  late final Animation<double> _progressAnim;
  Timer? _timer;
  bool _moved = false;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8500),
    );
    _progressAnim = CurvedAnimation(
      parent: _progress,
      curve: Curves.easeInOut,
    );
    _progress.forward();
    _timer = Timer(const Duration(milliseconds: 8500), _finish);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  void _finish() {
    if (_moved) return;
    _moved = true;
    widget.onDone();
  }

  TextStyle _headline(double fontSize) => GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        height: .98,
        letterSpacing: -1.2,
        color: Palette.ink,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.launchBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screen = constraints.biggest;
          final isNarrow = screen.width < 380;
          final headlineSize = (screen.width * 0.095).clamp(34.0, 42.0);
          final leftPadding = isNarrow ? 32.0 : 40.0;

          return Stack(
            children: [
              // 1. Full Continuous Hero Artwork Composition
              Positioned.fill(
                child: Image.asset(
                  AppAssets.hero,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (_, _, _) => const SizedBox.expand(),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(leftPadding, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: double.infinity, child: MoveWellLogo()),
                      SizedBox(height: isNarrow ? 20 : 28),
                      Text('Move', style: _headline(headlineSize)),
                      Text('Better', style: _headline(headlineSize)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Live ', style: _headline(headlineSize)),
                            TextSpan(
                              text: 'Fuller',
                              style: _headline(headlineSize).copyWith(
                                color: Palette.moveBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Small steps.\nA healthier, happier you.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isNarrow ? 12 : 13,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                          color: Palette.secondary,
                        ),
                      ),
                      SizedBox(height: isNarrow ? 12 : 16),
                      Transform.rotate(
                        angle: -0.22,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STRONGER\nTHAN\nYESTERDAY',
                              style: GoogleFonts.permanentMarker(
                                fontSize: isNarrow ? 12.5 : 13.5,
                                height: 1.12,
                                letterSpacing: 0.4,
                                color: Palette.secondary.withValues(alpha: 0.88),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const CustomPaint(
                              size: Size(52, 9),
                              painter: _ScribblePainter(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 92,
                        height: 4.5,
                        child: AnimatedBuilder(
                          animation: _progressAnim,
                          builder: (context, _) => ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: _progressAnim.value,
                              minHeight: 4.5,
                              backgroundColor: Palette.border.withValues(alpha: 0.6),
                              valueColor: const AlwaysStoppedAnimation(
                                Palette.moveBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'BUILDING A HEALTHIER TOMORROW',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.8,
                          color: Palette.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
  }
}

class _ScribblePainter extends CustomPainter {
  const _ScribblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Palette.secondary.withValues(alpha: .7);
    for (var i = 0; i < 3; i++) {
      final y = 2.0 + i * 4.0;
      final path = Path()
        ..moveTo(0, y + (i == 1 ? 1 : 0))
        ..quadraticBezierTo(size.width * .3, y - 1.5 + i, size.width * .62, y + 1)
        ..quadraticBezierTo(size.width * .85, y + 2, size.width, y - 1 + i);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

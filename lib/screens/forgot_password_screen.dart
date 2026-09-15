import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
    this.onResetSent,
  });

  final VoidCallback onBack;
  final VoidCallback? onResetSent;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email address first.')),
      );
      return;
    }
    if (_isSending) return;
    setState(() => _isSending = true);
    try {
      await AuthService.instance.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
      if (widget.onResetSent != null) {
        widget.onResetSent!();
      } else {
        widget.onBack();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.instance.readableError(error))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screen = constraints.biggest;
          final screenW = screen.width;
          final screenH = screen.height;
          final isNarrow = screenW < 360;

          // Hero artwork occupies ~52% of mobile screen height
          final heroH = (screenH * 0.52).clamp(340.0, 480.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Clean 3D Hero Artwork: Bottle on right, rolled mat, towel, platform, palms, wave
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: heroH,
                child: IgnorePointer(
                  child: Image.asset(
                    AppAssets.forgotPasswordHero,
                    fit: BoxFit.cover,
                    alignment: Alignment.topRight,
                  ),
                ),
              ),

              // 2. Full-Viewport Interactive Foreground (Unified Mobile Coordinate System)
              SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Back Button + Centered MoveWell Branding
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Circular Back Button
                            Material(
                              color: const Color(0xFFE5F1FA),
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: widget.onBack,
                                child: const SizedBox(
                                  width: 38,
                                  height: 38,
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 15,
                                    color: Palette.ink,
                                  ),
                                ),
                              ),
                            ),

                            // Centered MoveWell Logo & Wordmark
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppAssets.logo,
                                    width: 28,
                                    height: 28,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'MoveWell',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.1,
                                      color: Palette.ink,
                                    ),
                                  ),
                                  Text(
                                    'A HEALTHIER YOU, EVERYDAY',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 6.8,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Balance Spacer for perfect horizontal centering of branding
                            const SizedBox(width: 38),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Upper-Left Content: Headline, Description, Handwritten Accent
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isNarrow ? 20 : 26,
                          0,
                          16,
                          0,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: (screenW * 0.52).clamp(170.0, 240.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main Headline: Forgot Your Password?
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Forgot\nYour\n',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isNarrow ? 26 : 30,
                                        fontWeight: FontWeight.w800,
                                        height: 1.05,
                                        letterSpacing: -0.6,
                                        color: Palette.ink,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Password?',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isNarrow ? 26 : 30,
                                        fontWeight: FontWeight.w800,
                                        height: 1.05,
                                        letterSpacing: -0.6,
                                        color: const Color(0xFF3880FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Description Copy
                              Text(
                                "No worries. Enter your\nemail and we'll send you\ninstructions to reset it.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: isNarrow ? 12 : 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.34,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Handwritten Accent (Slanted): SMALL STEPS STILL COUNT
                              Transform.rotate(
                                angle: -0.10,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SMALL\nSTEPS\nSTILL COUNT',
                                      style: GoogleFonts.permanentMarker(
                                        fontSize: 10.5,
                                        height: 1.12,
                                        letterSpacing: 0.4,
                                        color: const Color(0xFF64748B)
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const _SmallStepsScribble(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Gap aligning the Form Panel below the hero 3D objects
                      SizedBox(
                        height: (heroH - (isNarrow ? 290 : 315)).clamp(
                          10.0,
                          50.0,
                        ),
                      ),

                      // Reset Form Panel (Rounded white/icy card)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isNarrow ? 14 : 18,
                          0,
                          isNarrow ? 14 : 18,
                          18,
                        ),
                        child: _buildResetPanel(isNarrow),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResetPanel(bool isNarrow) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 18 : 22,
        vertical: isNarrow ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE2EBF2), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email Label
          Text(
            'Email',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Palette.ink,
            ),
          ),
          const SizedBox(height: 6),

          // Email Input Field
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFCFE),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE1EBF2), width: 1.1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.mail_outline_rounded,
                  size: 19,
                  color: Color(0xFF7B91A6),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      border: InputBorder.none,
                      hintText: 'you@example.com',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Send Reset Link Action Button with Drag/Slide Arrow
          SlideActionPillButton(
            label: _isSending ? 'Sending...' : 'Send Reset Link',
            onTap: _handleReset,
            height: 48,
            fontSize: isNarrow ? 14 : 15,
          ),
          const SizedBox(height: 18),

          // OR Divider
          Row(
            children: [
              Expanded(
                child: Container(height: 1, color: const Color(0xFFE2EBF2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'OR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: const Color(0xFF8FA2B5),
                  ),
                ),
              ),
              Expanded(
                child: Container(height: 1, color: const Color(0xFFE2EBF2)),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Back to Log In Link
          Center(
            child: GestureDetector(
              onTap: widget.onBack,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: Color(0xFF3880FF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Back to Log In',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3880FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStepsScribble extends StatelessWidget {
  const _SmallStepsScribble();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(56, 9),
      painter: _SmallStepsScribblePainter(),
    );
  }
}

class _SmallStepsScribblePainter extends CustomPainter {
  const _SmallStepsScribblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF64748B).withValues(alpha: 0.75);
    for (var i = 0; i < 2; i++) {
      final y = 2.0 + i * 3.5;
      final path = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(size.width * .35, y - 1.5, size.width * .65, y + 1)
        ..quadraticBezierTo(size.width * .85, y + 1.5, size.width, y - 0.5);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

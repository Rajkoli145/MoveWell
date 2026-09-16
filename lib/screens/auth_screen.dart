import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.onAuthenticated,
    required this.onForgot,
    this.onSignUpSuccess,
  });

  final Future<void> Function() onAuthenticated;
  final Future<void> Function()? onSignUpSuccess;
  final VoidCallback onForgot;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _runAuthentication(Future<void> Function() operation) async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await operation();
      if (!_isLogin && widget.onSignUpSuccess != null) {
        await widget.onSignUpSuccess!();
      } else {
        await widget.onAuthenticated();
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = AuthService.instance.readableError(error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    if (email.isEmpty || password.isEmpty || (!_isLogin && name.isEmpty)) {
      setState(() => _errorMessage = 'Please complete all required fields.');
      return;
    }
    await _runAuthentication(() async {
      if (AuthService.instance.currentUser != null) return;
      if (_isLogin) {
        await AuthService.instance.signInWithEmail(email, password);
      } else {
        await AuthService.instance.signUpWithEmail(
          name: name,
          email: email,
          password: password,
        );
      }
    });
  }

  Future<void> _submitGoogle() => _runAuthentication(() async {
    if (AuthService.instance.currentUser != null) return;
    await AuthService.instance.signInWithGoogle();
  });

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
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

          // In Figma mobile (375x792), hero occupies ~44% of screen height
          final heroH = (screenH * 0.44).clamp(300.0, 420.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. High-Res 3D Hero Artwork: Pinned to Y=0 of the root mobile viewport
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: heroH,
                child: IgnorePointer(
                  child: Image.asset(
                    AppAssets.bottleLogin,
                    fit: BoxFit.cover,
                    alignment: Alignment.topRight,
                  ),
                ),
              ),

              // 2. Full Viewport Interactive Foreground (Aligned to Screen Top)
              SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upper-Left Branding & Authentic Figma Headline/Copy
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isNarrow ? 20 : 26,
                          6,
                          16,
                          0,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: (screenW * 0.50).clamp(165.0, 230.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // MoveWell Header
                              const _MoveWellHeaderLeft(),
                              const SizedBox(height: 12),

                              // Authentic Figma Headline: Disciplined Today / Happier Tomorrow
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Disciplined\nToday\n',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isNarrow ? 21 : 23.5,
                                        fontWeight: FontWeight.w800,
                                        height: 1.04,
                                        letterSpacing: -0.5,
                                        color: Palette.ink,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Happier\nTomorrow',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: isNarrow ? 21 : 23.5,
                                        fontWeight: FontWeight.w800,
                                        height: 1.04,
                                        letterSpacing: -0.5,
                                        color: const Color(0xFF3880FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Supporting Copy
                              Text(
                                _isLogin
                                    ? 'Log in to continue\nyour journey.'
                                    : 'Create your account\nto get started.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: isNarrow ? 11.5 : 12.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.32,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 9),

                              // Handwritten Accent (Slanted)
                              Transform.rotate(
                                angle: -0.08,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PROGRESS\nLIVES HERE',
                                      style: GoogleFonts.permanentMarker(
                                        fontSize: 9.8,
                                        height: 1.1,
                                        letterSpacing: 0.4,
                                        color: const Color(0xFF64748B)
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const _MiniScribble(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Gap aligning the Login Card directly beneath the towel & platform
                      SizedBox(
                        height: (heroH - (isNarrow ? 255 : 275)).clamp(
                          8.0,
                          45.0,
                        ),
                      ),

                      // Rounded Login / Sign Up Panel (Fills mobile viewport width with standard margin)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isNarrow ? 14 : 18,
                          0,
                          isNarrow ? 14 : 18,
                          16,
                        ),
                        child: _buildPanel(isNarrow),
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

  Widget _buildPanel(bool isNarrow) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 20,
        vertical: isNarrow ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2EBF2), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tabs: Log In vs Sign Up
          Row(
            children: [
              _TabItem(
                label: 'Log In',
                active: _isLogin,
                onTap: () => setState(() => _isLogin = true),
              ),
              const SizedBox(width: 26),
              _TabItem(
                label: 'Sign Up',
                active: !_isLogin,
                onTap: () => setState(() => _isLogin = false),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name Field (Sign Up only)
          if (!_isLogin) ...[
            _buildFieldLabel('Full Name'),
            const SizedBox(height: 5),
            _buildInputField(
              controller: _nameController,
              hint: 'John Doe',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 10),
          ],

          // Email Field
          _buildFieldLabel('Email'),
          const SizedBox(height: 5),
          _buildInputField(
            controller: _emailController,
            hint: 'you@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),

          // Password Field
          _buildFieldLabel('Password'),
          const SizedBox(height: 5),
          _buildInputField(
            controller: _passwordController,
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 19,
                color: const Color(0xFF7B91A6),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),

          // Forgot Password link (Log In only)
          if (_isLogin) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: widget.onForgot,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3880FF),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            const SizedBox(height: 14),
          ],

          // Log In / Create Account Action Button with Interactive Left-to-Right Drag / Slide Arrow
          SlideActionPillButton(
            label: _isSubmitting
                ? 'Please wait...'
                : (_isLogin ? 'Log In' : 'Sign Up'),
            onTap: _submitEmail,
            height: 48,
            fontSize: isNarrow ? 14 : 15,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 9),
            Text(
              _errorMessage!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
          const SizedBox(height: 14),

          // OR Divider
          Row(
            children: [
              Expanded(
                child: Container(height: 0.9, color: const Color(0xFFE2EBF2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                child: Container(height: 0.9, color: const Color(0xFFE2EBF2)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Social Login Buttons: Google, Apple, Facebook
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SocialButton(
                icon: Icons.g_mobiledata_rounded,
                isGoogle: true,
                label: 'Google',
                onTap: _isSubmitting ? null : _submitGoogle,
              ),
              const _SocialButton(icon: Icons.apple_rounded, label: 'Apple'),
              const _SocialButton(
                icon: Icons.facebook_rounded,
                isFacebook: true,
                label: 'Facebook',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sign Up / Log In Footer
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? 'Sign Up' : 'Log In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3880FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EBF2), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7B91A6)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Palette.ink,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          ?suffixIcon,
        ],
      ),
    );
  }
}

class _MoveWellHeaderLeft extends StatelessWidget {
  const _MoveWellHeaderLeft();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.logo, width: 26, height: 26),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  fontSize: 7.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              color: active ? Palette.ink : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 62,
            height: 2.6,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF3880FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    this.isGoogle = false,
    this.isFacebook = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isGoogle;
  final bool isFacebook;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F0F8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isGoogle
                    ? Text(
                        'G',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4285F4),
                        ),
                      )
                    : Icon(
                        icon,
                        size: 20,
                        color: isFacebook
                            ? const Color(0xFF1877F2)
                            : Palette.ink,
                      ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniScribble extends StatelessWidget {
  const _MiniScribble();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(48, 8),
      painter: _MiniScribblePainter(),
    );
  }
}

class _MiniScribblePainter extends CustomPainter {
  const _MiniScribblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF64748B).withValues(alpha: 0.75);
    for (var i = 0; i < 2; i++) {
      final y = 1.6 + i * 3.0;
      final path = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(
          size.width * .35,
          y - 1.2,
          size.width * .65,
          y + 0.8,
        )
        ..quadraticBezierTo(size.width * .85, y + 1.2, size.width, y - 0.4);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

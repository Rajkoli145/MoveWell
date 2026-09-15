import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'setup_models.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({
    super.key,
    required this.data,
    required this.onFinish,
    required this.onBack,
  });

  final SetupProfileData data;
  final VoidCallback onFinish;
  final VoidCallback onBack;

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _checkScaleAnim;
  late final Animation<double> _glowScaleAnim;
  late final Animation<double> _confettiAnim;
  late final Animation<double> _headerFadeAnim;
  late final Animation<Offset> _headerSlideAnim;
  late final Animation<double> _listFadeAnim;
  late final Animation<Offset> _listSlideAnim;
  late final Animation<double> _btnFadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _checkScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.60, curve: Curves.elasticOut),
      ),
    );

    _glowScaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _confettiAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.10, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _headerFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.70, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    _listFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );

    _listSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _btnFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildVerifiedRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Palette.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7B91A6),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Palette.ink,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFE1F8EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 14,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            SetupHeader(
              currentStep: 6,
              onBack: widget.onBack,
            ),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Celebration Hero with animated check & confetti
                    SizedBox(
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated Confetti sparkles
                          AnimatedBuilder(
                            animation: _confettiAnim,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _confettiAnim.value,
                                child: Transform.scale(
                                  scale: 0.6 + (_confettiAnim.value * 0.4),
                                  child: child,
                                ),
                              );
                            },
                            child: const _ConfettiParticles(),
                          ),

                          // Glowing outer soft ring with subtle pulse
                          AnimatedBuilder(
                            animation: _glowScaleAnim,
                            builder: (context, _) {
                              return Transform.scale(
                                scale: _glowScaleAnim.value,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF9F1).withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Bouncing Checkmark Circle
                          AnimatedBuilder(
                            animation: _checkScaleAnim,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _checkScaleAnim.value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4F5E3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 44,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Animated Headline & Subtitle
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _headerFadeAnim,
                          child: SlideTransition(
                            position: _headerSlideAnim,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            "You’re all set!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your profile is complete. Let’s start\nyour fitness journey!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.38,
                              color: const Color(0xFF7B91A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Verified Parameter List Card with smooth entrance
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _listFadeAnim,
                          child: SlideTransition(
                            position: _listSlideAnim,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE5EEF6),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildVerifiedRow(
                              icon: Icons.person_outline_rounded,
                              iconBg: const Color(0xFFD8EEFA),
                              label: "Full Name",
                              value: widget.data.fullName,
                            ),
                            const Divider(height: 1, color: Color(0xFFF0F5FA)),
                            _buildVerifiedRow(
                              icon: Icons.male_rounded,
                              iconBg: const Color(0xFFD8EEFA),
                              label: "Gender",
                              value: widget.data.gender,
                            ),
                            const Divider(height: 1, color: Color(0xFFF0F5FA)),
                            _buildVerifiedRow(
                              icon: Icons.calendar_today_outlined,
                              iconBg: const Color(0xFFDCF5E5),
                              label: "Date of Birth",
                              value: widget.data.dateOfBirth,
                            ),
                            const Divider(height: 1, color: Color(0xFFF0F5FA)),
                            _buildVerifiedRow(
                              icon: Icons.straighten_rounded,
                              iconBg: const Color(0xFFE9E2FE),
                              label: "Height",
                              value: '${widget.data.height} ${widget.data.heightUnit}',
                            ),
                            const Divider(height: 1, color: Color(0xFFF0F5FA)),
                            _buildVerifiedRow(
                              icon: Icons.monitor_weight_outlined,
                              iconBg: const Color(0xFFFEE1DC),
                              label: "Weight",
                              value: '${widget.data.weight.round()} ${widget.data.weightUnit}',
                            ),
                            const Divider(height: 1, color: Color(0xFFF0F5FA)),
                            _buildVerifiedRow(
                              icon: Icons.directions_run_rounded,
                              iconBg: const Color(0xFFFEF1D0),
                              label: "Activity Level",
                              value: widget.data.activityLevel,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 3. Bottom CTA
            AnimatedBuilder(
              animation: _btnFadeAnim,
              builder: (context, child) {
                return Opacity(
                  opacity: _btnFadeAnim.value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                child: SlideActionPillButton(
                  label: "Go to Dashboard",
                  onTap: widget.onFinish,
                  height: 52,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticles extends StatelessWidget {
  const _ConfettiParticles();

  @override
  Widget build(BuildContext context) {
    const sparkles = [
      (0.20, 0.20, Color(0xFF38BDF8), 0.4),
      (0.80, 0.18, Color(0xFFFBBF24), -0.5),
      (0.12, 0.45, Color(0xFF60A5FA), 0.3),
      (0.88, 0.42, Color(0xFFC084FC), -0.3),
      (0.22, 0.78, Color(0xFFF472B6), 0.6),
      (0.80, 0.75, Color(0xFF34D399), -0.4),
      (0.50, 0.08, Color(0xFF34D399), 0.0),
      (0.18, 0.60, Color(0xFFFBBF24), -0.2),
    ];

    return SizedBox(
      width: 220,
      height: 150,
      child: Stack(
        children: sparkles.map((s) {
          return Positioned(
            left: s.$1 * 200,
            top: s.$2 * 130,
            child: Transform.rotate(
              angle: s.$4,
              child: Container(
                width: 14,
                height: 5.5,
                decoration: BoxDecoration(
                  color: s.$3,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: s.$3.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

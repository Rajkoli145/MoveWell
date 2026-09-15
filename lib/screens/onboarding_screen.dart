import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onGetStarted});
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final isCompact = h < 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: [
                    SizedBox(height: isCompact ? 8 : 14),

                    // 1. MoveWell Branding (respects horizontal padding)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: MoveWellLogo(),
                    ),
                    SizedBox(height: isCompact ? 4 : 8),

                    // 2. Integrated Hero Composition (Approaches screen edges, 1.12x immersive zoom)
                    Expanded(
                      flex: 12,
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          AppAssets.onboard,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? 8 : 12),

                    // 3. Lower Content with standard safe margins (24px)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: isCompact ? 4 : 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Headline
                          Text(
                            'Move Better\nLive Fuller',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isCompact ? 28 : 34,
                              fontWeight: FontWeight.w800,
                              height: 1.06,
                              letterSpacing: -0.6,
                              color: Palette.ink,
                            ),
                          ),
                          SizedBox(height: isCompact ? 6 : 10),

                          // Description
                          Text(
                            'Your all-in-one companion for workouts,\nnutrition, and a healthier, happier you.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isCompact ? 12 : 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                              color: Palette.secondary,
                            ),
                          ),
                          SizedBox(height: isCompact ? 14 : 20),

                          // Three Feature Items with Vertical Dividers
                          const _FeatureRow(),
                          SizedBox(height: isCompact ? 16 : 22),

                          // Get Started CTA Pill Button with Sliding Arrow
                          SlideActionPillButton(
                            label: 'Get Started',
                            onTap: onGetStarted,
                            height: 58,
                            knobColor: Palette.skyBlue,
                            fontSize: 16,
                          ),

                          // Subtle iOS Home Indicator
                          const SizedBox(height: 12),
                          Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Palette.ink.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _FeatureItem(
              icon: Icons.leaderboard_rounded,
              line1: 'Personalized',
              line2: 'Guidance',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _FeatureItem(
              icon: Icons.fitness_center_rounded,
              line1: 'Workouts',
              line2: 'for Every Level',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _FeatureItem(
              icon: Icons.eco_rounded,
              line1: 'Nutrition',
              line2: 'Made Simple',
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Palette.border,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.line1,
    required this.line2,
  });

  final IconData icon;
  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Palette.iconFill,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Palette.iconGlyph),
        ),
        const SizedBox(height: 7),
        Text(
          line1,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Palette.featTitle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          line2,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Palette.featSub,
          ),
        ),
      ],
    );
  }
}

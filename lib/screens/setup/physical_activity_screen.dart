import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'why_we_ask_card.dart';

class PhysicalActivityScreen extends StatefulWidget {
  const PhysicalActivityScreen({
    super.key,
    required this.selectedActivity,
    required this.onActivityChanged,
    required this.onNext,
    required this.onBack,
  });

  final String selectedActivity;
  final ValueChanged<String> onActivityChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  late String _currentActivity;

  final _activities = const [
    (
      'Sedentary',
      Icons.weekend_outlined,
      'Little or no exercise',
    ),
    (
      'Lightly Active',
      Icons.directions_walk_rounded,
      'Light exercise 1–3 days/week',
    ),
    (
      'Moderately Active',
      Icons.directions_run_rounded,
      'Moderate exercise 3–5 days/week',
    ),
    (
      'Very Active',
      Icons.fitness_center_rounded,
      'Hard exercise 6–7 days/week',
    ),
    (
      'Extremely Active',
      Icons.signal_cellular_alt_rounded,
      'Very intense exercise, physical job or 2x workouts/day',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.selectedActivity;
  }

  void _select(String act) {
    setState(() => _currentActivity = act);
    widget.onActivityChanged(act);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'What’s your physical activity level?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us create a plan that fits\nyour lifestyle and daily routine.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. Activity Level List
                    ..._activities.map((act) {
                      final isSelected = _currentActivity == act.$1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _select(act.$1),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD6EDFC)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3880FF)
                                    : const Color(0xFFE5EEF6),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.025),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon Circle
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF8CE3F2)
                                        : const Color(0xFFD8EEFA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    act.$2,
                                    size: 22,
                                    color: Palette.ink,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        act.$1,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: Palette.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        act.$3,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkmark / Radio
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF3880FF)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF3880FF)
                                          : const Color(0xFFD0DFEC),
                                      width: isSelected ? 0 : 2.0,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // 4. Why We Ask Card
                    const WhyWeAskCard(
                      icon: Icons.fitness_center_rounded,
                      text: 'Your activity level helps us create accurate calorie targets, workout recommendations and a plan that fits your daily routine.',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 5. Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
              child: SlideActionPillButton(
                label: 'Next',
                onTap: widget.onNext,
                height: 52,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

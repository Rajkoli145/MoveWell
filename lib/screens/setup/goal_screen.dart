import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({
    super.key,
    required this.selectedGoal,
    required this.onGoalChanged,
    required this.onNext,
    required this.onBack,
  });

  final String selectedGoal;
  final ValueChanged<String> onGoalChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late String _currentGoal;

  final _goals = const [
    (
      'Build Muscle',
      Icons.fitness_center_rounded,
      'Gain strength and build lean muscle.',
      Color(0xFFD4EEFA),
    ),
    (
      'Lose Weight',
      Icons.monitor_weight_outlined,
      'Burn fat and get in shape.',
      Color(0xFFDCF5E5),
    ),
    (
      'Improve Health',
      Icons.favorite_border_rounded,
      'Feel better and boost your energy.',
      Color(0xFFFEE1DC),
    ),
    (
      'Increase Endurance',
      Icons.directions_run_rounded,
      'Build stamina and be more active.',
      Color(0xFFE7DEFE),
    ),
    (
      'General Fitness',
      Icons.star_border_rounded,
      'Stay active and maintain a healthy lifestyle.',
      Color(0xFFFEF1D0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.selectedGoal;
  }

  void _select(String goal) {
    setState(() => _currentGoal = goal);
    widget.onGoalChanged(goal);
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
              currentStep: 5,
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
                      'What is your goal?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us create a personalized\nplan for your fitness journey.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Goal Selection Cards
                    ..._goals.map((g) {
                      final isSelected = _currentGoal == g.$1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () => _select(g.$1),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD6EDFC)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
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
                                // Colored Icon badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: g.$4,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    g.$2,
                                    size: 24,
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
                                        g.$1,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.2,
                                          color: Palette.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        g.$3,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Radio indicator
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF1E2430)
                                          : const Color(0xFFD0DFEC),
                                      width: isSelected ? 6.5 : 2.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // 4. Bottom CTA
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

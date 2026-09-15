import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onNext,
    required this.onBack,
  });

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  late String _currentGender;

  final _options = const [
    ('Male', Icons.male_rounded),
    ('Female', Icons.female_rounded),
    ('Prefer not to say', Icons.transgender_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _currentGender = widget.selectedGender;
  }

  void _select(String gender) {
    setState(() => _currentGender = gender);
    widget.onGenderChanged(gender);
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
              currentStep: 1,
              onBack: widget.onBack,
            ),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'What’s your gender?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us personalize your\nexperience.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 3. Selection Cards
                    ..._options.map((opt) {
                      final isSelected = _currentGender == opt.$1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _select(opt.$1),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
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
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF8CE3F2)
                                        : const Color(0xFFD8EEFA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    opt.$2,
                                    size: 26,
                                    color: Palette.ink,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Label
                                Expanded(
                                  child: Text(
                                    opt.$1,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.ink,
                                    ),
                                  ),
                                ),

                                // Custom Radio Indicator
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

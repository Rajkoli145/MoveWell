import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'why_we_ask_card.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({
    super.key,
    required this.selectedAgeRange,
    required this.onAgeRangeChanged,
    required this.onNext,
    required this.onBack,
  });

  final String selectedAgeRange;
  final ValueChanged<String> onAgeRangeChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  late String _currentRange;

  final _ranges = const [
    ('13 – 17', 'Teen'),
    ('18 – 24', 'Young Adult'),
    ('25 – 34', 'Adult'),
    ('35 – 44', 'Mid Adult'),
    ('45 – 54', 'Adult'),
    ('55 – 64', 'Pre-Senior'),
    ('65+', 'Senior'),
  ];

  @override
  void initState() {
    super.initState();
    _currentRange = widget.selectedAgeRange;
  }

  void _select(String range) {
    setState(() => _currentRange = range);
    widget.onAgeRangeChanged(range);
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
              currentStep: 2,
              onBack: widget.onBack,
            ),

            // 2. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'How old are you?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us create a plan that\nfits your needs.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. 3-Column Grid for Age ranges
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _ranges.map((item) {
                        final isSelected = _currentRange == item.$1;
                        final cardWidth = (MediaQuery.of(context).size.width - 44 - 24) / 3;

                        return GestureDetector(
                          onTap: () => _select(item.$1),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: cardWidth,
                            height: 86,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD6EDFC) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF3880FF) : const Color(0xFFE5EEF6),
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isSelected)
                                  Positioned(
                                    top: 0,
                                    right: 2,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E6FD9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.$1,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                        color: Palette.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.$2,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF7B91A6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // 4. Why We Ask Card
                    const WhyWeAskCard(
                      icon: Icons.cake_outlined,
                      text: 'Your age helps us tailor workout intensity, nutrition plans and goals for safe and effective results.',
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

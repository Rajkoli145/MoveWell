import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'why_we_ask_card.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({
    super.key,
    required this.selectedHeight,
    required this.selectedUnit,
    required this.onHeightChanged,
    required this.onUnitChanged,
    required this.onNext,
    required this.onBack,
  });

  final int selectedHeight;
  final String selectedUnit;
  final ValueChanged<int> onHeightChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  late String _unit;
  late int _selectedHeight;
  late FixedExtentScrollController _scrollController;

  static const int minCm = 120;
  static const int maxCm = 230;

  @override
  void initState() {
    super.initState();
    _unit = widget.selectedUnit;
    _selectedHeight = widget.selectedHeight.clamp(minCm, maxCm);
    final initialIndex = _selectedHeight - minCm;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex.clamp(0, 150));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onUnitSwitch(String newUnit) {
    if (_unit == newUnit) return;
    setState(() => _unit = newUnit);
    widget.onUnitChanged(newUnit);
  }

  String _formatDisplay(int cm) {
    if (_unit == 'ft & in') {
      final totalInches = (cm / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet' $inches\"";
    }
    return '$cm';
  }

  @override
  Widget build(BuildContext context) {
    const count = maxCm - minCm + 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            SetupHeader(
              currentStep: 4,
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
                      'What is your height?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us create a personalized\nplan for your fitness and nutrition goals.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Main Wheel Picker Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: const Color(0xFFE5EEF6),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Unit Switcher Pill
                          Container(
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F1F9),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onUnitSwitch('cm'),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _unit == 'cm'
                                            ? const Color(0xFF8CE3F2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'cm',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _unit == 'cm'
                                              ? Palette.ink
                                              : const Color(0xFF7B91A6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onUnitSwitch('ft & in'),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _unit == 'ft & in'
                                            ? const Color(0xFF8CE3F2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'ft & in',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _unit == 'ft & in'
                                              ? Palette.ink
                                              : const Color(0xFF7B91A6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Vertical Drum Wheel Picker with ruler ticks
                          SizedBox(
                            height: 180,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Selection highlight pill
                                Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE4F3FD),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),

                                // Side vertical subtle ruler tick marks
                                Positioned(
                                  left: 36,
                                  top: 10,
                                  bottom: 10,
                                  child: Container(
                                    width: 1,
                                    color: const Color(0xFFE2EBF2),
                                  ),
                                ),
                                Positioned(
                                  right: 36,
                                  top: 10,
                                  bottom: 10,
                                  child: Container(
                                    width: 1,
                                    color: const Color(0xFFE2EBF2),
                                  ),
                                ),

                                // Wheel view
                                ListWheelScrollView.useDelegate(
                                  controller: _scrollController,
                                  itemExtent: 44,
                                  physics: const FixedExtentScrollPhysics(),
                                  perspective: 0.003,
                                  diameterRatio: 1.5,
                                  onSelectedItemChanged: (index) {
                                    final val = minCm + index;
                                    setState(() => _selectedHeight = val);
                                    widget.onHeightChanged(val);
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: count,
                                    builder: (context, index) {
                                      final val = minCm + index;
                                      final isSelected = val == _selectedHeight;
                                      final displayStr = _formatDisplay(val);

                                      return Center(
                                        child: isSelected
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                textBaseline: TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    displayStr,
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.w800,
                                                      color: Palette.ink,
                                                    ),
                                                  ),
                                                  if (_unit == 'cm') ...[
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'cm',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xFF64748B),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              )
                                            : Text(
                                                displayStr,
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 4. Why We Ask Card
                    const WhyWeAskCard(
                      icon: Icons.straighten_rounded,
                      text: 'Your height helps us calculate your BMI, set accurate calorie goals and create better workout recommendations.',
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

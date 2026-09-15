import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'why_we_ask_card.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({
    super.key,
    required this.selectedWeight,
    required this.selectedUnit,
    required this.onWeightChanged,
    required this.onUnitChanged,
    required this.onNext,
    required this.onBack,
  });

  final double selectedWeight;
  final String selectedUnit;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  late String _unit;
  late int _selectedWeightInt;
  late FixedExtentScrollController _scrollController;

  static const int minKg = 35;
  static const int maxKg = 180;
  static const int minLbs = 75;
  static const int maxLbs = 400;

  @override
  void initState() {
    super.initState();
    _unit = widget.selectedUnit;
    _selectedWeightInt = widget.selectedWeight.round().clamp(minKg, maxKg);
    final initialIndex = _selectedWeightInt - (_unit == 'kg' ? minKg : minLbs);
    _scrollController = FixedExtentScrollController(initialItem: initialIndex.clamp(0, 200));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onUnitSwitch(String newUnit) {
    if (_unit == newUnit) return;
    setState(() {
      _unit = newUnit;
      if (newUnit == 'lbs') {
        _selectedWeightInt = (_selectedWeightInt * 2.20462).round().clamp(minLbs, maxLbs);
      } else {
        _selectedWeightInt = (_selectedWeightInt / 2.20462).round().clamp(minKg, maxKg);
      }
      final initialIndex = _selectedWeightInt - (newUnit == 'kg' ? minKg : minLbs);
      _scrollController.jumpToItem(initialIndex.clamp(0, 300));
    });
    widget.onUnitChanged(newUnit);
    widget.onWeightChanged(_selectedWeightInt.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final minVal = _unit == 'kg' ? minKg : minLbs;
    final maxVal = _unit == 'kg' ? maxKg : maxLbs;
    final count = maxVal - minVal + 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            SetupHeader(
              currentStep: 3,
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
                      'What is your weight?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us personalize your\nplan and give better recommendations.',
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
                                    onTap: () => _onUnitSwitch('kg'),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _unit == 'kg'
                                            ? const Color(0xFF8CE3F2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'kg',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _unit == 'kg'
                                              ? Palette.ink
                                              : const Color(0xFF7B91A6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onUnitSwitch('lbs'),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _unit == 'lbs'
                                            ? const Color(0xFF8CE3F2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'lbs',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _unit == 'lbs'
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

                          // Vertical Drum Wheel Picker
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

                                // Wheel view
                                ListWheelScrollView.useDelegate(
                                  controller: _scrollController,
                                  itemExtent: 44,
                                  physics: const FixedExtentScrollPhysics(),
                                  perspective: 0.003,
                                  diameterRatio: 1.5,
                                  onSelectedItemChanged: (index) {
                                    final val = minVal + index;
                                    setState(() => _selectedWeightInt = val);
                                    widget.onWeightChanged(val.toDouble());
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: count,
                                    builder: (context, index) {
                                      final val = minVal + index;
                                      final isSelected = val == _selectedWeightInt;
                                      return Center(
                                        child: isSelected
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                textBaseline: TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    '$val',
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.w800,
                                                      color: Palette.ink,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _unit,
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                '$val',
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
                      icon: Icons.monitor_weight_outlined,
                      text: 'Your weight helps us calculate your BMI, set accurate calorie goals and create a plan that fits your needs.',
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

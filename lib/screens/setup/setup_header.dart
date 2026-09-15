import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
    required this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Circular Back Button
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F1FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17,
                color: Palette.ink,
              ),
            ),
          ),

          // 2. Segmented Progress Bar (6 segments)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (index) {
              final isPassed = index < currentStep;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 22,
                height: 4.0,
                decoration: BoxDecoration(
                  color: isPassed
                      ? const Color(0xFF60A5FA)
                      : const Color(0xFFE2EBF2),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              );
            }),
          ),

          // 3. Step fraction indicator (e.g. 1/6)
          SizedBox(
            width: 44,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$currentStep',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                    ),
                  ),
                  TextSpan(
                    text: '/$totalSteps',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B91A6),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

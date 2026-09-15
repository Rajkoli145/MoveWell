import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';

class WhyWeAskCard extends StatelessWidget {
  const WhyWeAskCard({
    super.key,
    required this.icon,
    required this.text,
    this.title = 'Why we ask?',
    this.iconBgColor = const Color(0xFFD8EEFA),
    this.iconColor = const Color(0xFF1E2430),
  });

  final IconData icon;
  final String text;
  final String title;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5EEF6),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: Palette.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    height: 1.34,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

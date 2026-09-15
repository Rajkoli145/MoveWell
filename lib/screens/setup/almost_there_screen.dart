import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'setup_models.dart';

class AlmostThereScreen extends StatelessWidget {
  const AlmostThereScreen({
    super.key,
    required this.data,
    required this.onEditProfile,
    required this.onNext,
    required this.onBack,
  });

  final SetupProfileData data;
  final VoidCallback onEditProfile;
  final VoidCallback onNext;
  final VoidCallback onBack;

  Widget _buildSummaryCell({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Palette.ink),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7B91A6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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
              onBack: onBack,
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
                      "Almost there!",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Here’s a summary of your information.\nYou can edit it anytime.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. User Profile Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  AppAssets.avatar,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 60,
                                    height: 60,
                                    color: const Color(0xFFD6EDFC),
                                    child: const Icon(Icons.person, color: Palette.ink),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -3,
                                bottom: -3,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD6EDFC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 13,
                                    color: Color(0xFF3880FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Profile",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF7B91A6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.fullName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Palette.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${data.age} years old · ${data.gender}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF7B91A6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: onEditProfile,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F6FB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: Palette.ink,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Edit",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 4. Parameter Summary Grid (2-Column)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFFE5EEF6),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.male_rounded,
                                  iconBg: const Color(0xFFD8EEFA),
                                  label: "Gender",
                                  value: data.gender,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.calendar_today_outlined,
                                  iconBg: const Color(0xFFDDF5E6),
                                  label: "Age",
                                  value: '${data.age} years',
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFF0F5FA)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.monitor_weight_outlined,
                                  iconBg: const Color(0xFFFEE2DD),
                                  label: "Weight",
                                  value: '${data.weight.round()} ${data.weightUnit}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.straighten_rounded,
                                  iconBg: const Color(0xFFE9E2FE),
                                  label: "Height",
                                  value: '${data.height} ${data.heightUnit}',
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFF0F5FA)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.adjust_rounded,
                                  iconBg: const Color(0xFFFEF2D5),
                                  label: "Goal",
                                  value: data.goal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSummaryCell(
                                  icon: Icons.directions_run_rounded,
                                  iconBg: const Color(0xFFDCF2FC),
                                  label: "Activity Level",
                                  value: data.activityLevel == "Moderately Active" ? "Moderate" : data.activityLevel,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 5. You are all set motivation card
                    Container(
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
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD8EEFA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_outlined,
                              size: 22,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You’re all set!",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Palette.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Let’s build a healthier, stronger and happier you. 💪",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // 6. Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
              child: SlideActionPillButton(
                label: "Continue",
                onTap: onNext,
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

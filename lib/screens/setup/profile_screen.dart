import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../palette.dart';
import 'setup_header.dart';
import 'setup_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  final SetupProfileData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ---------------------------------------------------------------------------
  // Bottom Sheet Helpers for Interactive Dropdowns
  // ---------------------------------------------------------------------------

  void _editFullName() {
    final controller = TextEditingController(text: widget.data.fullName);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit Full Name',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  filled: true,
                  fillColor: const Color(0xFFF7FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE5EEF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        widget.data.fullName = controller.text.trim();
                      });
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Save Name',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectGender() {
    const genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
    _showOptionsSheet(
      title: 'Select Gender',
      options: genders,
      currentValue: widget.data.gender,
      onSelected: (val) {
        setState(() => widget.data.gender = val);
      },
    );
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 5, 12),
      firstDate: DateTime(1930),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Palette.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      setState(() {
        widget.data.dateOfBirth = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _selectHeight() {
    double tempHeight = widget.data.height.toDouble();
    String tempUnit = widget.data.heightUnit;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Height',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${tempHeight.round()} $tempUnit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  Slider(
                    value: tempHeight.clamp(100.0, 230.0),
                    min: 100,
                    max: 230,
                    activeColor: const Color(0xFF2563EB),
                    inactiveColor: const Color(0xFFE5EEF6),
                    onChanged: (val) {
                      setSheetState(() => tempHeight = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2430),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.data.height = tempHeight.round();
                          widget.data.heightUnit = tempUnit;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'Confirm Height',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectWeight() {
    double tempWeight = widget.data.weight;
    String tempUnit = widget.data.weightUnit;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Weight',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${tempWeight.round()} $tempUnit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  Slider(
                    value: tempWeight.clamp(30.0, 180.0),
                    min: 30,
                    max: 180,
                    activeColor: const Color(0xFF2563EB),
                    inactiveColor: const Color(0xFFE5EEF6),
                    onChanged: (val) {
                      setSheetState(() => tempWeight = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2430),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.data.weight = tempWeight;
                          widget.data.weightUnit = tempUnit;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'Confirm Weight',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectActivityLevel() {
    const activities = [
      'Beginner',
      'Intermediate',
      'Moderately Active',
      'Very Active',
    ];
    _showOptionsSheet(
      title: 'Select Activity Level',
      options: activities,
      currentValue: widget.data.activityLevel,
      onSelected: (val) {
        setState(() => widget.data.activityLevel = val);
      },
    );
  }

  void _showOptionsSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Palette.ink,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...options.map((option) {
                final isSelected = option.toLowerCase() == currentValue.toLowerCase();
                return InkWell(
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF7FAFD),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5EEF6),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? const Color(0xFF2563EB) : Palette.ink,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldCard({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool hasArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: Palette.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                    ),
                  ),
                ],
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF7B91A6),
                size: 22,
              ),
          ],
        ),
      ),
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
                      "Fill your profile",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This information helps us personalize\nyour fitness plan and experience.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. Photo Card
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile photo updated'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE5EEF6),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      AppAssets.avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: const Color(0xFFD6EDFC),
                                        child: const Icon(Icons.person, color: Palette.ink),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF38BDF8),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add a profile photo",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "A clear photo helps us personalize your experience.",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                      color: const Color(0xFF7B91A6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Interactive Input Field Cards
                    _buildFieldCard(
                      icon: Icons.person_outline_rounded,
                      iconBg: const Color(0xFFD8EEFA),
                      label: "Full Name",
                      value: widget.data.fullName,
                      hasArrow: false,
                      onTap: _editFullName,
                    ),
                    _buildFieldCard(
                      icon: Icons.male_rounded,
                      iconBg: const Color(0xFFD8EEFA),
                      label: "Gender",
                      value: widget.data.gender,
                      onTap: _selectGender,
                    ),
                    _buildFieldCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFDCF5E5),
                      label: "Date of Birth",
                      value: widget.data.dateOfBirth,
                      onTap: _selectDateOfBirth,
                    ),
                    _buildFieldCard(
                      icon: Icons.straighten_rounded,
                      iconBg: const Color(0xFFE9E2FE),
                      label: "Height",
                      value: '${widget.data.height} ${widget.data.heightUnit}',
                      onTap: _selectHeight,
                    ),
                    _buildFieldCard(
                      icon: Icons.monitor_weight_outlined,
                      iconBg: const Color(0xFFFEE1DC),
                      label: "Weight",
                      value: '${widget.data.weight.round()} ${widget.data.weightUnit}',
                      onTap: _selectWeight,
                    ),
                    _buildFieldCard(
                      icon: Icons.directions_run_rounded,
                      iconBg: const Color(0xFFFEF1D0),
                      label: "Activity Level",
                      value: widget.data.activityLevel,
                      onTap: _selectActivityLevel,
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // 5. Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
              child: SlideActionPillButton(
                label: "Complete Profile",
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

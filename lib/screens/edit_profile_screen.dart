import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../palette.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserProfileNotifier _notifier = UserProfileNotifier.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late String _dateOfBirth;
  late String _gender;
  late int _height;
  late String _heightUnit;
  late double _weight;
  late String _weightUnit;
  late String _activityLevel;
  late String _goal;
  late String _language;
  late String _theme;
  late bool _notifications;
  late String _avatarPath;

  @override
  void initState() {
    super.initState();
    final p = _notifier.profile;
    _nameController = TextEditingController(text: p.fullName);
    _emailController = TextEditingController(text: p.email);
    _dateOfBirth = p.dateOfBirth;
    _gender = p.gender;
    _height = p.height;
    _heightUnit = p.heightUnit;
    _weight = p.weight;
    _weightUnit = p.weightUnit;
    _activityLevel = p.activityLevel;
    _goal = p.goal;
    _language = p.language;
    _theme = p.theme;
    _notifications = p.notificationsEnabled;
    _avatarPath = p.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    _notifier.updateField(
      fullName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : _notifier.profile.fullName,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : _notifier.profile.email,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      height: _height,
      heightUnit: _heightUnit,
      weight: _weight,
      weightUnit: _weightUnit,
      activityLevel: _activityLevel,
      goal: _goal,
      language: _language,
      theme: _theme,
      notificationsEnabled: _notifications,
      avatarPath: _avatarPath,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 20),
            const SizedBox(width: 10),
            Text(
              'Profile updated successfully!',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E2430),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ---------------------------------------------------------------------------
  // Interactive Pickers
  // ---------------------------------------------------------------------------

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 6, 12),
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
        _dateOfBirth = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _pickGender() {
    const genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
    _showSelectModal(
      title: 'Select Gender',
      options: genders,
      currentValue: _gender,
      onSelected: (val) => setState(() => _gender = val),
    );
  }

  void _pickHeight() {
    double tempHeight = _height.toDouble();
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
                    '${tempHeight.round()} $_heightUnit',
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
                    onChanged: (val) => setSheetState(() => tempHeight = val),
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
                        setState(() => _height = tempHeight.round());
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

  void _pickWeight() {
    double tempWeight = _weight;
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
                    '${tempWeight.round()} $_weightUnit',
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
                    onChanged: (val) => setSheetState(() => tempWeight = val),
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
                        setState(() => _weight = tempWeight);
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

  void _pickActivityLevel() {
    const activities = [
      'Beginner',
      'Intermediate',
      'Moderately Active',
      'Very Active',
    ];
    _showSelectModal(
      title: 'Select Activity Level',
      options: activities,
      currentValue: _activityLevel,
      onSelected: (val) => setState(() => _activityLevel = val),
    );
  }

  void _pickGoal() {
    const goals = [
      'Build Strength',
      'Lose Weight',
      'Keep Fit',
      'Build Muscle',
      'Improve Endurance',
    ];
    _showSelectModal(
      title: 'Select Fitness Goal',
      options: goals,
      currentValue: _goal,
      onSelected: (val) => setState(() => _goal = val),
    );
  }

  void _pickLanguage() {
    const langs = ['English', 'Spanish', 'French', 'German', 'Hindi', 'Japanese'];
    _showSelectModal(
      title: 'Select Language',
      options: langs,
      currentValue: _language,
      onSelected: (val) => setState(() => _language = val),
    );
  }

  void _pickTheme() {
    const themes = ['Light', 'Dark', 'System Default'];
    _showSelectModal(
      title: 'Select Theme',
      options: themes,
      currentValue: _theme,
      onSelected: (val) => setState(() => _theme = val),
    );
  }

  void _showSelectModal({
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                            fontSize: 14.5,
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

  void _showAvatarPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avatar image is synchronized'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: Stack(
        children: [
          // 1. Organic Smooth Light Blue Top-Right Wave Background
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            height: 320,
            child: IgnorePointer(
              child: CustomPaint(
                painter: const AppTopWavePainter(),
                size: const Size(double.infinity, 320),
              ),
            ),
          ),

          // 2. Scrollable Body
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Scrollable Form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar + Full Name & Email Input Card
                        _buildUserHeaderCard(),
                        const SizedBox(height: 20),

                        // Personal Information Section
                        _buildSectionHeader('Personal Information'),
                        const SizedBox(height: 10),
                        _buildPersonalInfoCard(),
                        const SizedBox(height: 20),

                        // Fitness Goals Section
                        _buildSectionHeader('Fitness Goals'),
                        const SizedBox(height: 10),
                        _buildFitnessGoalsCard(),
                        const SizedBox(height: 20),

                        // Preferences Section
                        _buildSectionHeader('Preferences'),
                        const SizedBox(height: 10),
                        _buildPreferencesCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Action Save Changes Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F2FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 26,
                    color: Palette.ink,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Edit Profile',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Palette.ink,
                  ),
                ),
              ),
              const SizedBox(width: 42), // Balance the back button
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Keep your information up to date\nfor a better experience.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              height: 1.35,
              color: const Color(0xFF7B91A6),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // User Header Card (Avatar + Name & Email text fields)
  // ---------------------------------------------------------------------------
  Widget _buildUserHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with Camera Badge
          GestureDetector(
            onTap: _showAvatarPicker,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD6EDFC),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _avatarPath,
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
          ),
          const SizedBox(width: 16),

          // Inputs Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Palette.ink,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Palette.ink,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Palette.ink,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16.5,
        fontWeight: FontWeight.w800,
        color: Palette.ink,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Personal Information Card
  // ---------------------------------------------------------------------------
  Widget _buildPersonalInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          _buildPillActionRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date of Birth',
            valueText: _dateOfBirth,
            onTap: _pickDateOfBirth,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildPillActionRow(
            icon: Icons.male_rounded,
            title: 'Gender',
            valueText: _gender,
            onTap: _pickGender,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildPillActionRow(
            icon: Icons.accessibility_new_outlined,
            title: 'Height',
            valueText: '$_height $_heightUnit',
            onTap: _pickHeight,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildPillActionRow(
            icon: Icons.shopping_bag_outlined,
            title: 'Weight',
            valueText: '${_weight.round()} $_weightUnit',
            onTap: _pickWeight,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildPillActionRow(
            icon: Icons.directions_run_rounded,
            title: 'Activity Level',
            valueText: _activityLevel,
            onTap: _pickActivityLevel,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fitness Goals Card
  // ---------------------------------------------------------------------------
  Widget _buildFitnessGoalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: _buildPillActionRow(
        icon: Icons.track_changes_rounded,
        title: 'Your Goal',
        valueText: _goal,
        onTap: _pickGoal,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Preferences Card
  // ---------------------------------------------------------------------------
  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          _buildPillActionRow(
            icon: Icons.translate_rounded,
            title: 'Language',
            valueText: _language,
            onTap: _pickLanguage,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          _buildPillActionRow(
            icon: Icons.nightlight_outlined,
            title: 'Theme',
            valueText: _theme,
            onTap: _pickTheme,
          ),
          const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.notifications_none_rounded, size: 21, color: Palette.ink),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Notifications',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: CupertinoSwitch(
                    value: _notifications,
                    activeTrackColor: const Color(0xFF2563EB),
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillActionRow({
    required IconData icon,
    required String title,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 21, color: Palette.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valueText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF7B91A6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Save Changes CTA Button
  // ---------------------------------------------------------------------------
  Widget _buildSaveButton() {
    return SlideActionPillButton(
      label: 'Save Changes',
      onTap: _saveChanges,
      height: 52,
      fontSize: 15,
    );
  }
}

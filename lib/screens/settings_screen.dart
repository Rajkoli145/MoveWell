import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../palette.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.onBack,
    this.onHomeTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserProfileNotifier _notifier = UserProfileNotifier.instance;

  String _selectedTheme = 'Light';
  String _fontSize = 'Medium';
  String _units = 'Metric (kg, cm)';
  String _language = 'English';
  bool _darkMode = false;
  bool _notifications = true;
  int _navIndex = 3;

  @override
  void initState() {
    super.initState();
    _selectedTheme = _notifier.profile.theme;
    _darkMode = _selectedTheme == 'Dark';
    _language = _notifier.profile.language;
    _notifications = _notifier.profile.notificationsEnabled;
    _notifier.addListener(_onProfileChange);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onProfileChange);
    super.dispose();
  }

  void _onProfileChange() {
    if (mounted) {
      setState(() {
        _selectedTheme = _notifier.profile.theme;
        _darkMode = _selectedTheme == 'Dark';
        _language = _notifier.profile.language;
        _notifications = _notifier.profile.notificationsEnabled;
      });
    }
  }

  UserProfile get _profile => _notifier.profile;

  // ---------------------------------------------------------------------------
  // Modal Sheet Helpers
  // ---------------------------------------------------------------------------

  void _showEditEmailModal() {
    final controller = TextEditingController(text: _profile.email);
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
            left: 22,
            right: 22,
            top: 18,
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
                'Change Email Address',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter new email',
                  filled: true,
                  fillColor: const Color(0xFFF7FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5EEF6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                    final newEmail = controller.text.trim();
                    if (newEmail.isNotEmpty) {
                      _notifier.updateField(email: newEmail);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email updated successfully'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Save Email',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
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

  void _showChangePasswordModal() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
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
            left: 22,
            right: 22,
            top: 18,
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
                'Change Password',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: oldPass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  filled: true,
                  fillColor: const Color(0xFFF7FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5EEF6)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  filled: true,
                  fillColor: const Color(0xFFF7FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5EEF6)),
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
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password updated securely'),
                        backgroundColor: Color(0xFF1E2430),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Update Password',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
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

  void _showFontSizeModal() {
    final sizes = ['Small', 'Medium', 'Large'];
    _showOptionsSheet(
      title: 'Select Font Size',
      options: sizes,
      currentValue: _fontSize,
      onSelected: (val) => setState(() => _fontSize = val),
    );
  }

  void _showUnitsModal() {
    final unitsList = ['Metric (kg, cm)', 'Imperial (lbs, ft/in)'];
    _showOptionsSheet(
      title: 'Select Measurement Units',
      options: unitsList,
      currentValue: _units,
      onSelected: (val) {
        setState(() {
          _units = val;
          if (val.contains('Metric')) {
            _notifier.updateField(weightUnit: 'kg', heightUnit: 'cm');
          } else {
            _notifier.updateField(weightUnit: 'lbs', heightUnit: 'ft');
          }
        });
      },
    );
  }

  void _showLanguageModal() {
    final langs = ['English', 'Spanish', 'French', 'German', 'Hindi', 'Japanese'];
    _showOptionsSheet(
      title: 'Select Language',
      options: langs,
      currentValue: _language,
      onSelected: (val) {
        setState(() => _language = val);
        _notifier.updateField(language: val);
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

  void _showInfoModal(String title, String content, IconData icon, Color color) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                content,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  height: 1.5,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Got It',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
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

  void _showDeleteAccountDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Text(
            'Delete Account?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFEF4444),
            ),
          ),
          content: Text(
            'This action is permanent and cannot be undone. All your workout records, statistics, and profile data will be permanently wiped.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.4,
              color: const Color(0xFF64748B),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7B91A6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion requested'),
                    backgroundColor: Color(0xFF1E2430),
                  ),
                );
              },
              child: Text(
                'Delete Forever',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Text(
            'Log Out?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Palette.ink,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of MoveWell? Your workout data is synced safely.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.4,
              color: const Color(0xFF64748B),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7B91A6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Color(0xFF1E2430),
                  ),
                );
                if (widget.onBack != null) {
                  widget.onBack!();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: Stack(
        children: [
          // 1. Organic Smooth Light Blue Top-Right Wave Background
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            height: 320,
            child: FloatingWaveBackground(height: 320),
          ),

          // 2. Main Scrollable Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Scrollable Setting Sections
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Account Section
                        _buildSectionHeader('Account'),
                        const SizedBox(height: 10),
                        _buildAccountCard(),
                        const SizedBox(height: 20),

                        // Appearance Section
                        _buildSectionHeader('Appearance'),
                        const SizedBox(height: 10),
                        _buildAppearanceCard(),
                        const SizedBox(height: 20),

                        // App Preferences Section
                        _buildSectionHeader('App Preferences'),
                        const SizedBox(height: 10),
                        _buildPreferencesCard(),
                        const SizedBox(height: 20),

                        // Data & Privacy Section
                        _buildSectionHeader('Data & Privacy'),
                        const SizedBox(height: 10),
                        _buildDataPrivacyCard(),
                        const SizedBox(height: 20),

                        // About / Application Section
                        _buildSectionHeader('About'),
                        const SizedBox(height: 10),
                        _buildAboutCard(),
                        const SizedBox(height: 20),

                        // Logout Section Tile
                        _buildLogoutTile(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavBar(),
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
                  'Settings',
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
            'Customize your experience\nand make MoveWell yours.',
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
  // Account Card
  // ---------------------------------------------------------------------------
  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          // Edit Profile Row with Avatar
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => EditProfileScreen(
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD6EDFC), width: 1.5),
                    ),
                    child: ClipOval(
                      child: AppAvatarImage(
                        avatarPath: _profile.avatarPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Update your personal information',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF7B91A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF7B91A6), size: 20),
                ],
              ),
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Email Row
          _buildActionRow(
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF0284C7),
            iconBg: const Color(0xFFE0F2FE),
            title: 'Email',
            subtitle: _profile.email,
            onTap: _showEditEmailModal,
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Change Password Row
          _buildActionRow(
            icon: Icons.lock_outline_rounded,
            iconColor: const Color(0xFF7C3AED),
            iconBg: const Color(0xFFEDE9FE),
            title: 'Change Password',
            subtitle: 'Keep your account secure',
            onTap: _showChangePasswordModal,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Appearance Card
  // ---------------------------------------------------------------------------
  Widget _buildAppearanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          // Theme Segmented Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.nightlight_outlined, color: Palette.ink, size: 19),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Palette.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Choose your preferred theme',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Segmented buttons
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Light', 'Dark', 'System'].map((themeName) {
                      final isSelected = _selectedTheme == themeName;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTheme = themeName;
                            _darkMode = themeName == 'Dark';
                          });
                          _notifier.updateField(theme: themeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFDCEBFC) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            themeName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Font Size
          _buildActionRow(
            icon: Icons.format_size_rounded,
            iconColor: const Color(0xFF0F172A),
            iconBg: const Color(0xFFF1F5F9),
            title: 'Font Size',
            subtitle: 'Adjust text size for better readability',
            trailingValue: _fontSize,
            onTap: _showFontSizeModal,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App Preferences Card
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
          // Dark Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.dark_mode_outlined, color: Palette.ink, size: 19),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Dark Mode',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: CupertinoSwitch(
                    value: _darkMode,
                    activeTrackColor: const Color(0xFF2563EB),
                    onChanged: (val) {
                      setState(() {
                        _darkMode = val;
                        _selectedTheme = val ? 'Dark' : 'Light';
                      });
                      _notifier.updateField(theme: _selectedTheme);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Language
          _buildActionRow(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF16A34A),
            iconBg: const Color(0xFFDCFCE7),
            title: 'Language',
            subtitle: 'Choose your app language',
            trailingValue: _language,
            onTap: _showLanguageModal,
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Notifications
          _buildActionRow(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFFEA580C),
            iconBg: const Color(0xFFFFEDD5),
            title: 'Notifications',
            subtitle: 'Manage what you want to be notified about',
            trailingValue: _notifications ? 'On' : 'Off',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => NotificationScreen(
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),

          // Units
          _buildActionRow(
            icon: Icons.straighten_rounded,
            iconColor: const Color(0xFF2563EB),
            iconBg: const Color(0xFFE0F2FE),
            title: 'Units',
            subtitle: 'Set your preferred measurement units',
            trailingValue: _units,
            onTap: _showUnitsModal,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Data & Privacy Card
  // ---------------------------------------------------------------------------
  Widget _buildDataPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          _buildActionRow(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF2563EB),
            iconBg: const Color(0xFFE0F2FE),
            title: 'Privacy & Security',
            subtitle: 'Manage your data and privacy settings',
            onTap: () => _showInfoModal(
              'Privacy & Security',
              'Your data is securely stored with AES-256 encryption. We never sell your personal fitness records or biometric statistics.',
              Icons.shield_outlined,
              const Color(0xFF2563EB),
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),
          _buildActionRow(
            icon: Icons.cloud_download_outlined,
            iconColor: const Color(0xFF16A34A),
            iconBg: const Color(0xFFDCFCE7),
            title: 'Download My Data',
            subtitle: 'Get a copy of your workouts and profile data',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your export request has been processed. Download link sent to email.'),
                  backgroundColor: Color(0xFF1E2430),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),
          _buildActionRow(
            icon: Icons.delete_outline_rounded,
            iconColor: const Color(0xFFDC2626),
            iconBg: const Color(0xFFFEE2E2),
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // About Card
  // ---------------------------------------------------------------------------
  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        children: [
          _buildActionRow(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF0284C7),
            iconBg: const Color(0xFFE0F2FE),
            title: 'About MoveWell',
            subtitle: 'Version 1.0.0 • Build 2026.09',
            trailingValue: 'v1.0.0',
            onTap: () => _showInfoModal(
              'About MoveWell',
              'MoveWell is designed to make healthy fitness habits joyful, mindful, and sustainable. Crafted with dedication to help you become a healthier you, everyday.',
              Icons.info_outline_rounded,
              const Color(0xFF0284C7),
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),
          _buildActionRow(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF0D9488),
            iconBg: const Color(0xFFCCFBF1),
            title: 'Terms of Service',
            subtitle: 'Review terms and community rules',
            onTap: () => _showInfoModal(
              'Terms of Service',
              'By using MoveWell, you agree to follow our terms of service, maintain accurate profile metrics for workout calculations, and respect community standards.',
              Icons.description_outlined,
              const Color(0xFF0D9488),
            ),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF1F5F9)),
          _buildActionRow(
            icon: Icons.verified_user_outlined,
            iconColor: const Color(0xFF16A34A),
            iconBg: const Color(0xFFDCFCE7),
            title: 'Privacy Policy',
            subtitle: 'How we handle and protect your data',
            onTap: () => _showInfoModal(
              'Privacy Policy',
              'We prioritize your privacy. All your biometric and training metrics are encrypted locally and in transit. You retain full control to export or delete your data at any time.',
              Icons.verified_user_outlined,
              const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Logout Tile
  // ---------------------------------------------------------------------------
  Widget _buildLogoutTile() {
    return InkWell(
      onTap: _showLogoutDialog,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sign out from your account',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFEF4444), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? subtitle,
    String? trailingValue,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Palette.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF7B91A6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingValue != null) ...[
              Text(
                trailingValue,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF7B91A6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Navigation Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavBar() {
    final navItems = [
      {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded},
      {'label': 'Resources', 'icon': Icons.menu_book_outlined, 'activeIcon': Icons.menu_book_rounded},
      {'label': 'Favorite', 'icon': Icons.favorite_border_rounded, 'activeIcon': Icons.favorite_rounded},
      {'label': 'Support', 'icon': Icons.support_agent_outlined, 'activeIcon': Icons.support_agent_rounded},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = _navIndex == index;
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                if (widget.onHomeTap != null) {
                  widget.onHomeTap!();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              } else {
                setState(() => _navIndex = index);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected
                        ? (navItems[index]['activeIcon'] as IconData)
                        : (navItems[index]['icon'] as IconData),
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                    size: 24,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    navItems[index]['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../palette.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({
    super.key,
    this.onBack,
    this.onHomeTap,
    this.onResourcesTap,
    this.onFavoriteTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;
  final VoidCallback? onResourcesTap;
  final VoidCallback? onFavoriteTap;

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final UserProfileNotifier _notifier = UserProfileNotifier.instance;
  int _navIndex = 3; // Support/Profile is index 3

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_onProfileChange);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onProfileChange);
    super.dispose();
  }

  void _onProfileChange() {
    if (mounted) setState(() {});
  }

  UserProfile get _profile => _notifier.profile;

  // ---------------------------------------------------------------------------
  // Navigation & Interactive Sheets
  // ---------------------------------------------------------------------------

  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EditProfileScreen(
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _navigateToNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NotificationScreen(
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showProgressModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
              child: Column(
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
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF2563EB), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Fitness Journey',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Palette.ink,
                              ),
                            ),
                            Text(
                              '18 workouts completed this month',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: const Color(0xFF7B91A6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // Progress Highlights Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressStatTile(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFF97316),
                          iconBg: const Color(0xFFFFEDD5),
                          value: '14,280',
                          unit: 'kcal burned',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProgressStatTile(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFF2563EB),
                          iconBg: const Color(0xFFE0F2FE),
                          value: '12.5 hrs',
                          unit: 'active time',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressStatTile(
                          icon: Icons.emoji_events_outlined,
                          iconColor: const Color(0xFF10B981),
                          iconBg: const Color(0xFFD1FAE5),
                          value: '5 Badges',
                          unit: 'unlocked',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProgressStatTile(
                          icon: Icons.bolt_rounded,
                          iconColor: const Color(0xFF8B5CF6),
                          iconBg: const Color(0xFFEDE9FE),
                          value: '14 Days',
                          unit: 'longest streak',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Weekly Activity Breakdown',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildWeeklyActivityBar(),
                  const SizedBox(height: 24),
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
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Close Progress',
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
      },
    );
  }

  Widget _buildProgressStatTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Palette.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7B91A6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityBar() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final heights = [0.8, 0.6, 0.95, 0.4, 0.75, 1.0, 0.5];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EEF6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final isToday = index == 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 70 * heights[index],
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday ? const Color(0xFF2563EB) : const Color(0xFF7B91A6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showGoalsModal() {
    const goalOptions = [
      {'title': 'Build Strength', 'desc': 'Get stronger, improve endurance and feel great.'},
      {'title': 'Lose Weight', 'desc': 'Burn calories, lose fat and improve body composition.'},
      {'title': 'Keep Fit', 'desc': 'Maintain daily energy, mobility and overall wellness.'},
      {'title': 'Build Muscle', 'desc': 'Gain lean mass and sculpted muscle definition.'},
      {'title': 'Improve Endurance', 'desc': 'Increase stamina for running, sports and daily vitality.'},
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                'Select Fitness Goal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 12),
              ...goalOptions.map((g) {
                final isSelected = g['title'] == _profile.goal;
                return InkWell(
                  onTap: () {
                    _notifier.updateField(goal: g['title']!);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Goal updated to ${g['title']}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF7FAFD),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5EEF6),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? const Color(0xFF2563EB) : Palette.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                g['desc']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFF7B91A6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB), size: 20),
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

  void _showInfoSheet(String title, String content, IconData icon) {
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
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

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Profile Card (Avatar, Name, Metrics)
                        _buildProfileHeaderCard(),
                        const SizedBox(height: 16),

                        // "View Your Progress" Card
                        _buildViewProgressCard(),
                        const SizedBox(height: 20),

                        // Goals Section
                        _buildGoalsSection(),
                        const SizedBox(height: 20),

                        // Account Section
                        _buildAccountSection(),
                        const SizedBox(height: 20),

                        // Support Section
                        _buildSupportSection(),
                        const SizedBox(height: 20),

                        // Log Out Action Button
                        _buildLogoutButton(),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
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

          // Title
          Text(
            'Profile',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Palette.ink,
            ),
          ),

          // Settings Button
          GestureDetector(
            onTap: () => _showInfoSheet(
              'App Settings',
              'MoveWell Version 2.4.0\n\n• Cloud Sync: Active\n• Units: Metric\n• Analytics: Privacy Friendly\n• Cache: 12.4 MB',
              Icons.settings_outlined,
            ),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F2FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.settings_outlined,
                size: 20,
                color: Palette.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Header Card
  // ---------------------------------------------------------------------------
  Widget _buildProfileHeaderCard() {
    return Container(
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
      child: Column(
        children: [
          // Top row: Avatar + Name + Chevron
          InkWell(
            onTap: _navigateToEditProfile,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Row(
                children: [
                  // Avatar with Camera Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD6EDFC),
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            _profile.avatarPath,
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
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Name and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profile.fullName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _profile.subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF7B91A6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron Right
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF7B91A6),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Bottom 4-Column Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              children: [
                _buildStatColumn('${_profile.age}', 'Age'),
                _buildVerticalDivider(),
                _buildStatColumn('${_profile.weight.round()} ${_profile.weightUnit}', 'Weight'),
                _buildVerticalDivider(),
                _buildStatColumn('${_profile.height} ${_profile.heightUnit}', 'Height'),
                _buildVerticalDivider(),
                _buildStatColumn(_profile.activityLevel, 'Activity Level', isSmall: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isSmall = false}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isSmall ? 12.5 : 14.5,
                fontWeight: FontWeight.w800,
                color: Palette.ink,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7B91A6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 26,
      color: const Color(0xFFE5EEF6),
    );
  }

  // ---------------------------------------------------------------------------
  // "View Your Progress" Card
  // ---------------------------------------------------------------------------
  Widget _buildViewProgressCard() {
    return InkWell(
      onTap: _showProgressModal,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF5FE),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD6E7FA)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Your Progress',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'See your stats, journey and achievements.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7B91A6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF7B91A6),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Goals Section
  // ---------------------------------------------------------------------------
  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Goals',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Palette.ink,
              ),
            ),
            GestureDetector(
              onTap: _showGoalsModal,
              child: Text(
                'Edit',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _showGoalsModal,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5EEF6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.center_focus_strong_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Goal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _profile.goal,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Palette.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Get stronger, improve endurance and feel great.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF7B91A6),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Account Section
  // ---------------------------------------------------------------------------
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: Palette.ink,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5EEF6)),
          ),
          child: Column(
            children: [
              _buildListRow(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                onTap: _navigateToEditProfile,
              ),
              const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
              _buildListRow(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                onTap: _navigateToNotifications,
              ),
              const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
              _buildListRow(
                icon: Icons.shield_outlined,
                title: 'Privacy & Security',
                onTap: () => _showInfoSheet(
                  'Privacy & Security',
                  'Your health and workout data is encrypted and securely stored. You have full ownership of your data at all times.\n\n• Biometric Lock: Available\n• Two-Factor Authentication: Enabled\n• Data Export: Supported',
                  Icons.shield_outlined,
                ),
              ),
              const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
              _buildListRow(
                icon: Icons.settings_outlined,
                title: 'App Settings',
                onTap: () => _showInfoSheet(
                  'App Settings',
                  'Manage app configurations, caching, synchronization frequency, and developer settings.',
                  Icons.settings_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Support Section
  // ---------------------------------------------------------------------------
  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: Palette.ink,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5EEF6)),
          ),
          child: Column(
            children: [
              _buildListRow(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                onTap: () => _showInfoSheet(
                  'Help Center',
                  'Frequently Asked Questions:\n\n1. How do I change my weekly goal?\nGo to Profile > Goals > Edit.\n\n2. How do I log water intake?\nTap the water cup card on your Home dashboard.\n\n3. Can I connect a smartwatch?\nYes, Apple Health and Google Fit syncing are supported in App Settings.',
                  Icons.help_outline_rounded,
                ),
              ),
              const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
              _buildListRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Online Support',
                onTap: () => _showInfoSheet(
                  'Online Support',
                  'Our fitness coaching and technical team are available 24/7.\n\nAverage response time: under 5 minutes.\n\nEmail: support@movewell.app',
                  Icons.chat_bubble_outline_rounded,
                ),
              ),
              const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
              _buildListRow(
                icon: Icons.info_outline_rounded,
                title: 'About MoveWell',
                onTap: () => _showInfoSheet(
                  'About MoveWell',
                  'MoveWell - A Healthier You, Everyday.\n\nVersion: 2.4.0 (Build 2026.09)\nMade with dedication to empowering personal wellness and mindful fitness.',
                  Icons.info_outline_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 21, color: Palette.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
            ),
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
  // Log Out Button
  // ---------------------------------------------------------------------------
  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _showLogoutDialog,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 19),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
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

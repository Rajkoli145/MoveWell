import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../palette.dart';

class NotificationItemModel {
  final String id;
  final String category; // 'Workouts', 'Nutrition', 'Community', 'System'
  final String section; // 'Today', 'This Week', 'Earlier'
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  bool isRead;

  NotificationItemModel({
    required this.id,
    required this.category,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
    this.onBack,
    this.onHomeTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedCategory = 'All';
  int _navIndex = 0;

  final List<String> _categories = [
    'All',
    'Workouts',
    'Nutrition',
    'Community',
    'System',
  ];

  late List<NotificationItemModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      // Today
      NotificationItemModel(
        id: '1',
        category: 'Workouts',
        section: 'Today',
        title: 'Time for your workout!',
        subtitle: 'Your Full Body Strength session is scheduled for today.',
        time: '2h ago',
        icon: Icons.fitness_center_rounded,
        iconColor: const Color(0xFF0284C7),
        iconBg: const Color(0xFFE0F2FE),
        isRead: false,
      ),
      NotificationItemModel(
        id: '2',
        category: 'Workouts',
        section: 'Today',
        title: "You're on a streak!",
        subtitle: "You've completed 3 workouts this week. Keep it going!",
        time: '5h ago',
        icon: Icons.emoji_events_outlined,
        iconColor: const Color(0xFF16A34A),
        iconBg: const Color(0xFFDCFCE7),
        isRead: false,
      ),
      NotificationItemModel(
        id: '3',
        category: 'Nutrition',
        section: 'Today',
        title: 'Great progress!',
        subtitle: "You're 80% closer to your weekly calorie goal.",
        time: '8h ago',
        icon: Icons.local_fire_department_rounded,
        iconColor: const Color(0xFFEA580C),
        iconBg: const Color(0xFFFFEDD5),
        isRead: false,
      ),

      // This Week
      NotificationItemModel(
        id: '4',
        category: 'Nutrition',
        section: 'This Week',
        title: 'New article for you',
        subtitle: '5 Simple Nutrition Tips for Better Energy',
        time: '2d ago',
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF7C3AED),
        iconBg: const Color(0xFFEDE9FE),
        isRead: true,
      ),
      NotificationItemModel(
        id: '5',
        category: 'Community',
        section: 'This Week',
        title: 'Community challenge',
        subtitle: 'Join the MoveWell 5K Steps Challenge!',
        time: '3d ago',
        icon: Icons.group_outlined,
        iconColor: const Color(0xFFDB2777),
        iconBg: const Color(0xFFFCE7F3),
        isRead: true,
      ),
      NotificationItemModel(
        id: '6',
        category: 'Workouts',
        section: 'This Week',
        title: 'Weekly report is ready',
        subtitle: 'View your progress summary for this week.',
        time: '5d ago',
        icon: Icons.bar_chart_rounded,
        iconColor: const Color(0xFF0284C7),
        iconBg: const Color(0xFFE0F2FE),
        isRead: true,
      ),

      // Earlier
      NotificationItemModel(
        id: '7',
        category: 'System',
        section: 'Earlier',
        title: 'Welcome to MoveWell!',
        subtitle: "Let's start your fitness journey together.",
        time: '1w ago',
        icon: Icons.card_giftcard_rounded,
        iconColor: const Color(0xFF0D9488),
        iconBg: const Color(0xFFCCFBF1),
        isRead: true,
      ),
      NotificationItemModel(
        id: '8',
        category: 'System',
        section: 'Earlier',
        title: 'Profile updated',
        subtitle: 'Your profile information has been updated.',
        time: '1w ago',
        icon: Icons.settings_outlined,
        iconColor: const Color(0xFF0284C7),
        iconBg: const Color(0xFFE0F2FE),
        isRead: true,
      ),
    ];
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.done_all_rounded, color: Color(0xFF34D399), size: 20),
            const SizedBox(width: 10),
            Text(
              'All notifications marked as read',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E2430),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _onNotificationTap(NotificationItemModel item) {
    setState(() {
      item.isRead = true;
    });

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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Palette.ink,
                          ),
                        ),
                        Text(
                          '${item.category} • ${item.time}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7B91A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 1.45,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 22),
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
                    'Dismiss',
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

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedCategory == 'All'
        ? _notifications
        : _notifications.where((n) => n.category == _selectedCategory).toList();

    final todayItems = filteredList.where((n) => n.section == 'Today').toList();
    final thisWeekItems = filteredList.where((n) => n.section == 'This Week').toList();
    final earlierItems = filteredList.where((n) => n.section == 'Earlier').toList();

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

          // 2. Main Scrollable View
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Category Filter Pills
                _buildCategoryFilters(),

                // Notifications Sections List
                Expanded(
                  child: filteredList.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (todayItems.isNotEmpty) ...[
                                _buildSectionTitle('Today'),
                                const SizedBox(height: 10),
                                _buildSectionCard(todayItems),
                                const SizedBox(height: 20),
                              ],
                              if (thisWeekItems.isNotEmpty) ...[
                                _buildSectionTitle('This Week'),
                                const SizedBox(height: 10),
                                _buildSectionCard(thisWeekItems),
                                const SizedBox(height: 20),
                              ],
                              if (earlierItems.isNotEmpty) ...[
                                _buildSectionTitle('Earlier'),
                                const SizedBox(height: 10),
                                _buildSectionCard(earlierItems),
                                const SizedBox(height: 16),
                              ],
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
                'Notifications',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),

              // Mark All As Read Pill Button
              GestureDetector(
                onTap: _markAllAsRead,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF5FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Mark all as read',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Stay updated with your progress,\nworkouts and more.',
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
  // Category Filter Pills
  // ---------------------------------------------------------------------------
  Widget _buildCategoryFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDCEBFC) : const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Headers & Notification Cards
  // ---------------------------------------------------------------------------
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Palette.ink,
      ),
    );
  }

  Widget _buildSectionCard(List<NotificationItemModel> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                ),
                onDismissed: (_) {
                  setState(() {
                    _notifications.removeWhere((n) => n.id == item.id);
                  });
                },
                child: InkWell(
                  onTap: () => _onNotificationTap(item),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colored Circle Icon
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: item.iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item.icon, size: 20, color: item.iconColor),
                        ),
                        const SizedBox(width: 14),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Palette.ink,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.35,
                                  color: const Color(0xFF7B91A6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Time & Blue Unread Dot
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.time,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (!item.isRead)
                              Container(
                                width: 7.5,
                                height: 7.5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle,
                                ),
                              )
                            else
                              const SizedBox(height: 7.5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                const Divider(height: 1, indent: 72, color: Color(0xFFF1F5F9)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications in this category',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Palette.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check back later for updates and activities.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: const Color(0xFF7B91A6),
            ),
          ),
        ],
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

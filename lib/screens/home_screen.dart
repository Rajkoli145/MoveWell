import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../palette.dart';
import 'notification_screen.dart';
import 'nutrition_screen.dart';
import 'profile_view_screen.dart';
import 'search_screen.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Raj',
    this.onStartWorkout,
    this.onViewAllRecommended,
    this.onViewAllChallenges,
    this.onViewAllArticles,
  });

  final String userName;
  final VoidCallback? onStartWorkout;
  final VoidCallback? onViewAllRecommended;
  final VoidCallback? onViewAllChallenges;
  final VoidCallback? onViewAllArticles;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserProfileNotifier _profileNotifier = UserProfileNotifier.instance;
  int _currentNavIndex = 0;
  int _waterGlasses = 3;
  int _dailySteps = 4320;
  final int _caloriesBurned = 1200;
  int _challengeDays = 2;

  @override
  void initState() {
    super.initState();
    _profileNotifier.addListener(_onProfileUpdate);
  }

  @override
  void dispose() {
    _profileNotifier.removeListener(_onProfileUpdate);
    super.dispose();
  }

  void _onProfileUpdate() {
    if (mounted) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // Interactive Modal Handlers
  // ---------------------------------------------------------------------------

  void _showWorkoutStartSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      AppAssets.workoutHero,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Body Strength',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Palette.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '30 min • Intermediate • 240 kcal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7B91A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Exercises in this workout',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 10),
              _buildExerciseItem('1. Warm Up & Joint Mobility', '5 mins'),
              _buildExerciseItem('2. Bodyweight Lunges & Squats', '3 sets × 12 reps'),
              _buildExerciseItem('3. Dumbbell Push Press', '3 sets × 10 reps'),
              _buildExerciseItem('4. Core Plank & Mountain Climbers', '3 sets × 45 secs'),
              _buildExerciseItem('5. Cool Down & Full Body Stretch', '5 mins'),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Starting Full Body Strength workout! Let’s crush it 💪',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xFF1E2430),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start Workout Now',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseItem(String title, String reps) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Palette.ink,
            ),
          ),
          Text(
            reps,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7B91A6),
            ),
          ),
        ],
      ),
    );
  }

  void _showArticleSheet(String title, String readTime, String assetPath) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      assetPath,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 14, color: Color(0xFF7B91A6)),
                      const SizedBox(width: 4),
                      Text(
                        readTime,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title.replaceAll('\n', ' '),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Building long-term health and consistent energy starts with small, daily habits. Focus on nutrient-dense whole foods, staying properly hydrated throughout the morning, and prioritizing steady sleep schedules. Regular movement compounded over weeks creates massive fitness transformation.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.55,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        'Done Reading',
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

          // 2. Main Scrollable View
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Body content based on active nav
                Expanded(
                  child: _currentNavIndex == 0
                      ? _buildHomeDashboard()
                      : _buildTabPlaceholder(_currentNavIndex),
                ),
              ],
            ),
          ),

          // 3. Floating Bottom Navigation Bar
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
  // Home Dashboard Scrollable Content
  // ---------------------------------------------------------------------------
  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Progress Stamp
          _buildGreetingSection(),
          const SizedBox(height: 16),

          // Top Modules Shortcut Menu (Workout, Progress, Nutrition, Community)
          _buildTopModulesMenu(),
          const SizedBox(height: 16),

          // Daily Metrics Stats Card (Steps, Water, Calories, Workout)
          _buildMetricsCard(),
          const SizedBox(height: 24),

          // Recommended For You Section
          _buildSectionHeader(
            title: "Recommended for you",
            onViewAll: widget.onViewAllRecommended ?? _showWorkoutStartSheet,
          ),
          const SizedBox(height: 12),
          _buildRecommendedCard(),
          const SizedBox(height: 24),

          // Weekly Challenge Section
          _buildSectionHeader(
            title: "Weekly Challenge",
            onViewAll: widget.onViewAllChallenges ?? () {},
          ),
          const SizedBox(height: 12),
          _buildWeeklyChallengeCard(),
          const SizedBox(height: 24),

          // Articles & Tips Section
          _buildSectionHeader(
            title: "Articles & Tips",
            onViewAll: widget.onViewAllArticles ?? () {},
          ),
          const SizedBox(height: 12),
          _buildArticlesList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab Placeholder for Resources / Favorite / Support
  // ---------------------------------------------------------------------------
  Widget _buildTabPlaceholder(int index) {
    final titles = ['Home', 'Resources & Workouts', 'Favorite Workouts', 'Support & Help'];
    final subtitles = [
      '',
      'Explore guided strength training, stretching routines, and personalized plans.',
      'Your saved workouts and favorite routines appear here.',
      'Need guidance? Contact our certified trainers and fitness experts 24/7.',
    ];
    final icons = [
      Icons.home_rounded,
      Icons.auto_stories_outlined,
      Icons.favorite_rounded,
      Icons.support_agent_rounded,
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(icons[index], size: 36, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            Text(
              titles[index],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Palette.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitles[index],
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: const Color(0xFF7B91A6),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => setState(() => _currentNavIndex = 0),
              child: Text(
                'Back to Home Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // MoveWell Logo & Wordmark
          Row(
            children: [
              Image.asset(
                AppAssets.logo,
                width: 38,
                height: 38,
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MoveWell',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: Palette.ink,
                    ),
                  ),
                  Text(
                    'A HEALTHIER YOU, EVERYDAY',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: const Color(0xFF7B91A6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Top Actions: Search, Notification Bell & Avatar
          Row(
            children: [
              // Search Icon Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => SearchScreen(
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  );
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
                    Icons.search_rounded,
                    size: 22,
                    color: Palette.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Notification Bell with Badge
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => NotificationScreen(
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F2FA),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 22,
                        color: Palette.ink,
                      ),
                      Positioned(
                        top: 9,
                        right: 11,
                        child: Container(
                          width: 7.5,
                          height: 7.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Clean User Profile Avatar (Tappable to open ProfileViewScreen)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ProfileViewScreen(
                        onBack: () => Navigator.pop(context),
                        onHomeTap: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD6EDFC),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _profileNotifier.profile.avatarPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFD6EDFC),
                        child: const Icon(Icons.person, color: Palette.ink),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Greeting Section
  // ---------------------------------------------------------------------------
  Widget _buildGreetingSection() {
    final displayName = _profileNotifier.profile.fullName.trim().split(' ').first;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Greeting Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mon, 16 Sep',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7B91A6),
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Good Morning,\n',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.15,
                        color: Palette.ink,
                      ),
                    ),
                    TextSpan(
                      text: displayName.isNotEmpty ? displayName : widget.userName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.15,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Small steps today\nlead to big results.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: const Color(0xFF7B91A6),
                ),
              ),
            ],
          ),
        ),

        // Right Slanted Motivational Stamp Badge
        Padding(
          padding: const EdgeInsets.only(top: 18, right: 6),
          child: Transform.rotate(
            angle: -0.21,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PROGRESS',
                  style: GoogleFonts.kalam(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    height: 1.0,
                    color: const Color(0xFF455A70),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'LIVES HERE',
                  style: GoogleFonts.kalam(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    height: 1.0,
                    color: const Color(0xFF455A70),
                  ),
                ),
                const SizedBox(height: 3),
                // Stylized hand-drawn underline bar
                Transform.rotate(
                  angle: 0.03,
                  child: Container(
                    width: 78,
                    height: 2.2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF455A70),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Top Menu / Core Content Modules: 7.1 Workout, 7.2 Progress, 7.3 Nutrition, 7.4 Community
  // ---------------------------------------------------------------------------
  Widget _buildTopModulesMenu() {
    final modules = [
      {
        'title': 'Workout',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFF2563EB),
        'bg': const Color(0xFFEFF6FF),
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => WorkoutScreen(onBack: () => Navigator.pop(context)),
              ),
            ),
      },
      {
        'title': 'Nutrition',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFF16A34A),
        'bg': const Color(0xFFF0FDF4),
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => NutritionScreen(onBack: () => Navigator.pop(context)),
              ),
            ),
      },
      {
        'title': 'Progress',
        'icon': Icons.bar_chart_rounded,
        'color': const Color(0xFF9333EA),
        'bg': const Color(0xFFFAF5FF),
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ProfileViewScreen(
                  onBack: () => Navigator.pop(context),
                  onHomeTap: () => Navigator.pop(context),
                ),
              ),
            ),
      },
      {
        'title': 'Community',
        'icon': Icons.groups_rounded,
        'color': const Color(0xFFEA580C),
        'bg': const Color(0xFFFFEDD5),
        'onTap': () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const SearchScreen(initialCategory: 'Community'),
              ),
            ),
      },
    ];

    return Row(
      children: modules.map((mod) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: mod['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: mod['bg'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (mod['color'] as Color).withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mod['icon'] as IconData, size: 20, color: mod['color'] as Color),
                    const SizedBox(height: 4),
                    Text(
                      mod['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Daily Metrics Row Card: Interactive
  // ---------------------------------------------------------------------------
  Widget _buildMetricsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5EEF6),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricColumn(
              icon: Icons.directions_run_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBg: const Color(0xFFE0F2FE),
              value: '$_dailySteps',
              label: 'Steps',
              subtext: 'of 7,000',
              onTap: () {
                setState(() => _dailySteps += 250);
              },
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildMetricColumn(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBg: const Color(0xFFE0F2FE),
              value: '$_waterGlasses',
              label: 'Water',
              subtext: 'of 8 glasses',
              onTap: () {
                setState(() {
                  _waterGlasses = (_waterGlasses % 8) + 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged 1 glass of water ($_waterGlasses/8) 💧'),
                    duration: const Duration(milliseconds: 900),
                    backgroundColor: const Color(0xFF0284C7),
                  ),
                );
              },
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildMetricColumn(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xFFEA580C),
              iconBg: const Color(0xFFFFEDD5),
              value: '$_caloriesBurned',
              label: 'Calories',
              subtext: 'of 2,000',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => NutritionScreen(
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildMetricColumn(
              icon: Icons.fitness_center_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBg: const Color(0xFFE0F2FE),
              value: '1 / 1',
              label: 'Workout',
              subtext: 'today',
              onTap: _showWorkoutStartSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.0,
      height: 48,
      color: const Color(0xFFEDF3F8),
    );
  }

  Widget _buildMetricColumn({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
    required String subtext,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: Palette.ink,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            subtext,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader({
    required String title,
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: Palette.ink,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Recommended Workout Hero Card (Adaptive & Overflow-Free)
  // ---------------------------------------------------------------------------
  Widget _buildRecommendedCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5EEF6),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Workout Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppAssets.workoutHero,
              width: 118,
              height: 122,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Workout Info & Action
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    "Today's Workout",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Workout Title
                Text(
                  'Full Body Strength',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: Palette.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),

                // Meta Info Row (Wrapped with FittedBox to prevent overflow)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Color(0xFF7B91A6),
                      ),
                      const SizedBox(width: 3.5),
                      Text(
                        '30 min',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(fontSize: 11, color: Color(0xFF7B91A6)),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.bar_chart_rounded,
                        size: 14,
                        color: Color(0xFF7B91A6),
                      ),
                      const SizedBox(width: 2.5),
                      Text(
                        'Intermediate',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),

                // Short Description
                Text(
                  'Build strength, improve endurance and feel great today.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    color: const Color(0xFF7B91A6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),

                // Start Workout Interactive SlideActionPillButton (Draggable & Hold-to-slide)
                SlideActionPillButton(
                  height: 32,
                  fontSize: 11,
                  label: 'Start Workout',
                  onTap: widget.onStartWorkout ?? _showWorkoutStartSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Weekly Challenge Card
  // ---------------------------------------------------------------------------
  Widget _buildWeeklyChallengeCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _challengeDays = (_challengeDays % 5) + 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFEBF6FD),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFDCEEFB),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Trophy Badge
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFD6EDFC),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.emoji_events_rounded,
                  size: 26,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Challenge Progress & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Move 5 Days This Week',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "You're $_challengeDays days in. Keep going!",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7B91A6),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Segmented Progress (5 capsules) + Counter
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: List.generate(5, (index) {
                            final isFilled = index < _challengeDays;
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: index == 4 ? 0 : 5),
                                height: 5.0,
                                decoration: BoxDecoration(
                                  color: isFilled
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFD0E3F2),
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$_challengeDays / 5',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
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
  // Articles & Tips Horizontal List
  // ---------------------------------------------------------------------------
  Widget _buildArticlesList() {
    final articles = [
      (
        AppAssets.articleNutrition,
        '5 Simple Nutrition\nTips for Better Energy',
        '5 min read',
      ),
      (
        AppAssets.articleConsistency,
        'The Power of\nConsistency',
        '4 min read',
      ),
      (
        AppAssets.articleRoutine,
        'How to Build a\nSustainable Routine',
        '6 min read',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: articles.map((art) {
          return GestureDetector(
            onTap: () => _showArticleSheet(art.$2, art.$3, art.$1),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 136,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE5EEF6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      art.$1,
                      width: 122,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 34,
                    child: Text(
                      art.$2,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: Palette.ink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 12,
                        color: Color(0xFF7B91A6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        art.$3,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7B91A6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Bar: Home, Resources, Favorite, Support
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5EEF6), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.auto_stories_outlined,
                label: 'Resources',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.favorite_border_rounded,
                label: 'Favorite',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.support_outlined,
                label: 'Support',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => WorkoutScreen(
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => ProfileViewScreen(
                onBack: () => Navigator.pop(context),
                onHomeTap: () => Navigator.pop(context),
              ),
            ),
          );
        } else {
          setState(() => _currentNavIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE0F2FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF7B91A6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF7B91A6),
            ),
          ),
        ],
      ),
    );
  }
}


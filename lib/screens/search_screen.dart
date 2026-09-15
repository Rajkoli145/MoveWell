import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../palette.dart';
import 'settings_screen.dart';
import 'workout_screen.dart';

/// Interactive Search Screen matching MoveWell Design System
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialQuery = '',
    this.initialCategory = 'All',
    this.onBack,
    this.onHomeTap,
  });

  final String initialQuery;
  final String initialCategory;
  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedCategory = 'All';
  int _navIndex = 1; // Resources/Search tab

  final List<String> _categories = [
    'All',
    'Workout',
    'Nutrition',
    'Articles',
    'Videos',
    'Community',
  ];

  List<String> _recentSearches = [
    'full body workout',
    'protein rich meals',
    'weight loss tips',
    'morning yoga',
  ];

  final List<Map<String, dynamic>> _popularSearches = [
    {
      'label': 'home workout',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFE0F2FE),
      'color': Color(0xFF0284C7),
    },
    {
      'label': 'weight loss',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFDCFCE7),
      'color': Color(0xFF16A34A),
    },
    {
      'label': 'muscle gain',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFF3E8FF),
      'color': Color(0xFF9333EA),
    },
    {
      'label': 'healthy recipes',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFFFEDD5),
      'color': Color(0xFFEA580C),
    },
    {
      'label': 'yoga',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFFCE7F3),
      'color': Color(0xFFDB2777),
    },
    {
      'label': 'mental health',
      'icon': Icons.trending_up_rounded,
      'bg': Color(0xFFE0F2FE),
      'color': Color(0xFF0284C7),
    },
  ];

  final Set<String> _bookmarkedIds = {'1', '2'};

  final List<Map<String, dynamic>> _recommendedItems = [
    {
      'id': '1',
      'type': 'Workout',
      'title': 'Full Body Strength Workout',
      'subtitle': 'Build strength, improve endurance and feel great.',
      'image': AppAssets.workoutHero,
      'duration': '15:20',
      'level': 'Intermediate',
      'timeMeta': '15 min',
      'tagBg': Color(0xFFE0F2FE),
      'tagColor': Color(0xFF2563EB),
      'calories': '180 kcal',
      'exercises': [
        'Jump Squats - 3 sets × 15 reps',
        'Push-ups - 3 sets × 12 reps',
        'Dumbbell Rows - 3 sets × 10 reps',
        'Plank Hold - 3 sets × 45 sec',
      ],
    },
    {
      'id': '2',
      'type': 'Nutrition',
      'title': '5 High-Protein Meals',
      'subtitle': 'Simple and healthy recipes for everyday energy.',
      'image': AppAssets.articleNutrition,
      'duration': '',
      'level': 'Article',
      'timeMeta': '5 min',
      'tagBg': Color(0xFFDCFCE7),
      'tagColor': Color(0xFF16A34A),
      'calories': '450-600 kcal/meal',
      'ingredients': [
        'Grilled Salmon with Quinoa & Asparagus',
        'Greek Yogurt Berry Protein Bowl',
        'Chicken & Sweet Potato Power Bowl',
        'Tofu & Edamame Veggie Stir-fry',
        'Cottage Cheese & Spinach Egg Scramble',
      ],
    },
    {
      'id': '3',
      'type': 'Wellness',
      'title': 'Morning Yoga for a Better You',
      'subtitle': 'Start your day with calm and energy.',
      'image': AppAssets.articleConsistency,
      'duration': '10:30',
      'level': 'Beginner',
      'timeMeta': '10 min',
      'tagBg': Color(0xFFF3E8FF),
      'tagColor': Color(0xFF9333EA),
      'calories': '95 kcal',
      'exercises': [
        'Sun Salutation A - 5 rounds',
        'Cat-Cow Stretch - 2 mins',
        'Warrior II & Extended Side Angle - 3 mins',
        'Child’s Pose & Deep Breathing - 2 mins',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    if (widget.initialQuery.isNotEmpty) {
      _searchController.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    final clean = query.trim();
    if (clean.isNotEmpty && !_recentSearches.contains(clean)) {
      setState(() {
        _recentSearches.insert(0, clean);
        if (_recentSearches.length > 8) {
          _recentSearches = _recentSearches.sublist(0, 8);
        }
      });
    }
  }

  void _selectSearchTerm(String term) {
    _searchController.text = term;
    _onSearchSubmitted(term);
    setState(() {});
  }

  void _toggleBookmark(String id) {
    setState(() {
      if (_bookmarkedIds.contains(id)) {
        _bookmarkedIds.remove(id);
      } else {
        _bookmarkedIds.add(id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _bookmarkedIds.contains(id) ? 'Saved to Favorites' : 'Removed from Favorites',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String filterLevel = 'All Levels';
        String filterDuration = 'Any Duration';
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Content',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Palette.ink,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            filterLevel = 'All Levels';
                            filterDuration = 'Any Duration';
                          });
                        },
                        child: Text(
                          'Reset',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Difficulty Level',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All Levels', 'Beginner', 'Intermediate', 'Advanced'].map((lvl) {
                      final isSel = filterLevel == lvl;
                      return ChoiceChip(
                        label: Text(lvl),
                        selected: isSel,
                        selectedColor: const Color(0xFFDBEAFE),
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel ? const Color(0xFF2563EB) : const Color(0xFF475569),
                        ),
                        onSelected: (val) => setModalState(() => filterLevel = lvl),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Duration',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Any Duration', '< 15 mins', '15 - 30 mins', '30+ mins'].map((dur) {
                      final isSel = filterDuration == dur;
                      return ChoiceChip(
                        label: Text(dur),
                        selected: isSel,
                        selectedColor: const Color(0xFFDBEAFE),
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel ? const Color(0xFF2563EB) : const Color(0xFF475569),
                        ),
                        onSelected: (val) => setModalState(() => filterDuration = dur),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Apply Filters',
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

  void _showItemDetailModal(Map<String, dynamic> item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final isNutrition = item['type'] == 'Nutrition';
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
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item['image'] as String,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['tagBg'] as Color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['type'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: item['tagColor'] as Color,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isNutrition ? Icons.article_outlined : Icons.timer_outlined,
                        size: 15,
                        color: const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['level']} • ${item['timeMeta']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['subtitle'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isNutrition ? 'Key Recipes & Meal Breakdown:' : 'Workout Routine Overview:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              if (isNutrition)
                ...((item['ingredients'] as List<String>).map(
                  (recipe) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A34A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recipe,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              else
                ...((item['exercises'] as List<String>).map(
                  (ex) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fitness_center_rounded, size: 16, color: Color(0xFF2563EB)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ex,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isNutrition ? 'Opening recipe guide...' : 'Starting ${item['title']}...',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    isNutrition ? 'View Full Meal Plan' : 'Start Session Now',
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

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredRecommended = _recommendedItems.where((item) {
      final matchesCat = _selectedCategory == 'All' ||
          (item['type'] as String).toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = query.isEmpty ||
          (item['title'] as String).toLowerCase().contains(query) ||
          (item['subtitle'] as String).toLowerCase().contains(query);
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background organic blue wave
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: IgnorePointer(
              child: CustomPaint(
                painter: const AppTopWavePainter(),
                size: const Size(double.infinity, 280),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildHeader(),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar Input
                        _buildSearchBar(),
                        const SizedBox(height: 16),

                        // Horizontal Category Filter Pills
                        _buildCategoryFilterRow(),
                        const SizedBox(height: 24),

                        // Recent Searches (show if query is empty)
                        if (query.isEmpty && _recentSearches.isNotEmpty) ...[
                          _buildRecentSearchesSection(),
                          const SizedBox(height: 24),
                        ],

                        // Popular Searches (show if query is empty)
                        if (query.isEmpty) ...[
                          _buildPopularSearchesSection(),
                          const SizedBox(height: 24),
                        ],

                        // Recommended for You / Search Results
                        _buildRecommendedSection(filteredRecommended, query),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
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
  // Header
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: widget.onBack ?? () => Navigator.maybePop(context),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 26,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Search',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Find workouts, articles, videos and more.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Bar
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) => setState(() {}),
              onSubmitted: _onSearchSubmitted,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Search for workouts, nutrition, articles...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
              ),
            ),
          InkWell(
            onTap: _showFilterModal,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 18,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Category Filter Pills
  // ---------------------------------------------------------------------------
  Widget _buildCategoryFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF93C5FD) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recent Searches
  // ---------------------------------------------------------------------------
  Widget _buildRecentSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _recentSearches.clear()),
              child: Text(
                'Clear All',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            children: List.generate(_recentSearches.length, (index) {
              final term = _recentSearches[index];
              return InkWell(
                onTap: () => _selectSearchTerm(term),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          term,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                      const Icon(Icons.north_east_rounded, size: 16, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Popular Searches
  // ---------------------------------------------------------------------------
  Widget _buildPopularSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularSearches.map((item) {
            return InkWell(
              onTap: () => _selectSearchTerm(item['label'] as String),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: item['bg'] as Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item['icon'] as IconData, size: 15, color: item['color'] as Color),
                    const SizedBox(width: 6),
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: item['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Recommended for You
  // ---------------------------------------------------------------------------
  Widget _buildRecommendedSection(List<Map<String, dynamic>> items, String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              query.isEmpty ? 'Recommended for You' : 'Search Results (${items.length})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            if (query.isEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => WorkoutScreen(
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2563EB)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded, size: 44, color: Color(0xFF94A3B8)),
                const SizedBox(height: 12),
                Text(
                  'No results found for "$query"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try searching for "workout", "nutrition", or "yoga"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: items.map((item) => _buildCard(item)).toList(),
          ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final isBookmarked = _bookmarkedIds.contains(item['id'] as String);
    final isNutrition = item['type'] == 'Nutrition';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showItemDetailModal(item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail image with duration badge
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.asset(
                        item['image'] as String,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                      if ((item['duration'] as String).isNotEmpty)
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_arrow_rounded, size: 10, color: Colors.white),
                                const SizedBox(width: 2),
                                Text(
                                  item['duration'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: item['tagBg'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['type'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: item['tagColor'] as Color,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _toggleBookmark(item['id'] as String),
                            child: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              size: 20,
                              color: isBookmarked ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtitle'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            isNutrition ? Icons.article_outlined : Icons.bar_chart_rounded,
                            size: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item['level'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item['timeMeta'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
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
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Navigation Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'Resources', 1),
          _buildNavItem(Icons.favorite_outline_rounded, Icons.favorite_rounded, 'Favorite', 2),
          _buildNavItem(Icons.support_agent_outlined, Icons.support_agent_rounded, 'Support', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData filledIcon, String label, int index) {
    final isSelected = _navIndex == index;
    return InkWell(
      onTap: () {
        if (index == 0) {
          if (widget.onHomeTap != null) {
            widget.onHomeTap!();
          } else {
            Navigator.maybePop(context);
          }
        } else if (index == 1) {
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
              builder: (context) => SettingsScreen(
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
        } else {
          setState(() => _navIndex = index);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              size: 22,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

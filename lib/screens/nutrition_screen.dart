import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../palette.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'workout_screen.dart';

/// Comprehensive Nutrition Screen matching MoveWell Design System
class NutritionScreen extends StatefulWidget {
  const NutritionScreen({
    super.key,
    this.onBack,
    this.onHomeTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  int _waterGlasses = 5;
  int _navIndex = 1; // Resources / Nutrition tab
  String _selectedMealFilter = 'All';

  final List<String> _mealFilters = ['All', 'High-Protein', 'Low-Carb', 'Vegetarian', 'Quick (<15m)'];

  final List<Map<String, dynamic>> _meals = [
    {
      'title': 'Breakfast',
      'item': 'Greek Yogurt Berry Bowl & Protein Shake',
      'calories': 420,
      'protein': '34g',
      'carbs': '42g',
      'fat': '10g',
      'icon': Icons.wb_sunny_outlined,
      'color': Color(0xFFEA580C),
      'bg': Color(0xFFFFEDD5),
    },
    {
      'title': 'Lunch',
      'item': 'Grilled Chicken Sweet Potato Power Bowl',
      'calories': 580,
      'protein': '48g',
      'carbs': '55g',
      'fat': '14g',
      'icon': Icons.lunch_dining_rounded,
      'color': Color(0xFF16A34A),
      'bg': Color(0xFFDCFCE7),
    },
    {
      'title': 'Dinner',
      'item': 'Wild Salmon with Quinoa & Steamed Greens',
      'calories': 610,
      'protein': '44g',
      'carbs': '40g',
      'fat': '22g',
      'icon': Icons.dinner_dining_rounded,
      'color': Color(0xFF2563EB),
      'bg': Color(0xFFE0F2FE),
    },
    {
      'title': 'Snacks',
      'item': 'Almonds & Boiled Eggs',
      'calories': 240,
      'protein': '14g',
      'carbs': '8g',
      'fat': '16g',
      'icon': Icons.cookie_outlined,
      'color': Color(0xFF9333EA),
      'bg': Color(0xFFF3E8FF),
    },
  ];

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': '5 High-Protein Muscle Meals',
      'subtitle': 'Easy to prepare recipes rich in essential amino acids.',
      'image': AppAssets.articleNutrition,
      'tag': 'High Protein',
      'tagBg': Color(0xFFDCFCE7),
      'tagColor': Color(0xFF16A34A),
      'time': '20 min',
      'calories': '520 kcal',
      'protein': '42g',
      'ingredients': [
        '200g Lean Chicken Breast or Tofu',
        '1/2 Cup Tri-Color Quinoa',
        '1 Cup Steamed Broccoli & Snap Peas',
        '1 Tbsp Extra Virgin Olive Oil & Lemon dressing',
      ],
    },
    {
      'title': 'Pre-Workout Energy Smoothie',
      'subtitle': 'Fast-digesting clean carbs for peak endurance.',
      'image': AppAssets.articleConsistency,
      'tag': 'Pre-Workout',
      'tagBg': Color(0xFFE0F2FE),
      'tagColor': Color(0xFF2563EB),
      'time': '5 min',
      'calories': '310 kcal',
      'protein': '25g',
      'ingredients': [
        '1 Frozen Banana',
        '1 Scoop Vanilla Whey / Plant Protein',
        '1 Cup Unsweetened Almond Milk',
        '1 Tbsp Chia Seeds & Dash of Cinnamon',
      ],
    },
    {
      'title': 'Avocado & Smoked Salmon Toast',
      'subtitle': 'Healthy omega-3 fatty acids for joint and brain health.',
      'image': AppAssets.articleRoutine,
      'tag': 'Healthy Fats',
      'tagBg': Color(0xFFFFEDD5),
      'tagColor': Color(0xFFEA580C),
      'time': '10 min',
      'calories': '380 kcal',
      'protein': '22g',
      'ingredients': [
        '2 Slices Whole Grain Sourdough',
        '1/2 Ripe Avocado Mashed',
        '80g Wild Smoked Salmon',
        'Pinch of Everything Bagel Seasoning',
      ],
    },
  ];

  void _showRecipeDetails(Map<String, dynamic> recipe) {
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
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  recipe['image'] as String,
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
                      color: recipe['tagBg'] as Color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recipe['tag'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: recipe['tagColor'] as Color,
                      ),
                    ),
                  ),
                  Text(
                    '${recipe['calories']} • ${recipe['protein']} Protein',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                recipe['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                recipe['subtitle'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ingredients & Preparation:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              ...((recipe['ingredients'] as List<String>).map(
                (ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A34A)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ing,
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
                        content: Text('Added "${recipe['title']}" to today\'s meal log!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Log to My Diet',
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

  void _showAddMealSheet(String mealName) {
    final foodCtrl = TextEditingController();
    final calCtrl = TextEditingController(text: '350');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(22, 16, 22, MediaQuery.of(context).viewInsets.bottom + 32),
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
              Text(
                'Log $mealName',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Food Name',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: foodCtrl,
                autofocus: true,
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'e.g. 2 Boiled Eggs & Toast',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Estimated Calories (kcal)',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: calCtrl,
                keyboardType: TextInputType.number,
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    final name = foodCtrl.text.trim().isEmpty ? 'Healthy Meal' : foodCtrl.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logged "$name" to $mealName!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Save to $mealName',
                    style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background wave
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Daily Nutrition & Macro Target Card
                        _buildMacroTrackerCard(),
                        const SizedBox(height: 20),

                        // Hydration Water Tracker
                        _buildWaterTrackerCard(),
                        const SizedBox(height: 24),

                        // Today's Meals Breakdown
                        _buildMealsSection(),
                        const SizedBox(height: 24),

                        // Curated Healthy Recipes
                        _buildRecipesSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: widget.onBack ?? () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.chevron_left_rounded, size: 26, color: Color(0xFF0F172A)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nutrition',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Fuel your body, reach your goals.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SearchScreen(
                    initialCategory: 'Nutrition',
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Macro Tracker Card
  // ---------------------------------------------------------------------------
  Widget _buildMacroTrackerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2430),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x18000000), blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY CALORIE TARGET',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: const Color(0xFF86EFAC),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '1,850',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' / 2,400 kcal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '550 kcal left',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF86EFAC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 1850 / 2400,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildMacroItem('Protein', '140g / 160g', 140 / 160, const Color(0xFF38BDF8)),
              const SizedBox(width: 12),
              _buildMacroItem('Carbs', '180g / 220g', 180 / 220, const Color(0xFFFBBF24)),
              const SizedBox(width: 12),
              _buildMacroItem('Fats', '52g / 65g', 52 / 65, const Color(0xFFF472B6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, double progress, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Water Tracker Card
  // ---------------------------------------------------------------------------
  Widget _buildWaterTrackerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7), size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hydration Tracker',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_waterGlasses of 8 glasses (${_waterGlasses * 250} ml)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_waterGlasses > 0) setState(() => _waterGlasses--);
                },
                icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF94A3B8)),
              ),
              IconButton(
                onPressed: () {
                  if (_waterGlasses < 12) setState(() => _waterGlasses++);
                },
                icon: const Icon(Icons.add_circle_rounded, color: Color(0xFF0284C7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Today's Meals Section
  // ---------------------------------------------------------------------------
  Widget _buildMealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Meals",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              '1,850 kcal logged',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF16A34A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: _meals.map((meal) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: meal['bg'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(meal['icon'] as IconData, size: 22, color: meal['color'] as Color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              meal['title'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              '${meal['calories']} kcal',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meal['item'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'P: ${meal['protein']} • C: ${meal['carbs']} • F: ${meal['fat']}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: Color(0xFF2563EB)),
                    onPressed: () => _showAddMealSheet(meal['title'] as String),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Healthy Recipes Section
  // ---------------------------------------------------------------------------
  Widget _buildRecipesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'High-Protein Recipes',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const SearchScreen(initialCategory: 'Nutrition'),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    'Explore All',
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _mealFilters.map((filter) {
              final isSel = _selectedMealFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSel,
                  selectedColor: const Color(0xFFDBEAFE),
                  backgroundColor: const Color(0xFFF1F5F9),
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                  onSelected: (val) => setState(() => _selectedMealFilter = filter),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: _recipes.map((rec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showRecipeDetails(rec),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            rec['image'] as String,
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rec['tagBg'] as Color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  rec['tag'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: rec['tagColor'] as Color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rec['title'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 3),
                                  Text(rec['time'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B))),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.local_fire_department_rounded, size: 12, color: Color(0xFFEA580C)),
                                  const SizedBox(width: 3),
                                  Text(rec['calories'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B))),
                                  const SizedBox(width: 8),
                                  Text('• ${rec['protein']} P', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

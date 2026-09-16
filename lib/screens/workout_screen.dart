import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';
import '../models/workout_plan.dart';
import '../services/routine_api.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'workout_session_screen.dart';

/// Interactive Workout Screen matching MoveWell Design System
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
    this.initialTab = 'Overview',
    this.onBack,
    this.onHomeTap,
  });

  final String initialTab;
  final VoidCallback? onBack;
  final VoidCallback? onHomeTap;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _presetKey = GlobalKey();
  final GlobalKey _createKey = GlobalKey();
  final GlobalKey _levelKey = GlobalKey();

  String _selectedTab = 'Overview';
  int _navIndex = 1; // Resources / Workout tab
  bool _isLoadingCustomRoutines = true;
  List<Routine> _customRoutines = [];

  final List<String> _tabs = [
    'Overview',
    'Preset Routines',
    'Create Routine',
    'By Level',
  ];

  final List<Map<String, dynamic>> _quickStartCategories = [
    {
      'title': 'Strength',
      'subtitle': 'Build muscle',
      'icon': Icons.fitness_center_rounded,
      'color': Color(0xFF2563EB),
      'bg': Color(0xFFEFF6FF),
      'exercises': [
        'Barbell Squats',
        'Bench Press',
        'Pull-ups',
        'Overhead Press',
      ],
    },
    {
      'title': 'Cardio',
      'subtitle': 'Burn calories',
      'icon': Icons.directions_run_rounded,
      'color': Color(0xFF16A34A),
      'bg': Color(0xFFF0FDF4),
      'exercises': [
        'HIIT Sprints',
        'Jump Rope',
        'Burpees',
        'Mountain Climbers',
      ],
    },
    {
      'title': 'Yoga',
      'subtitle': 'Build flexibility',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFEA580C),
      'bg': Color(0xFFFFF7ED),
      'exercises': [
        'Sun Salutations',
        'Warrior Poses',
        'Cobra Pose',
        'Pigeon Stretch',
      ],
    },
    {
      'title': 'Core',
      'subtitle': 'Stronger core',
      'icon': Icons.shield_outlined,
      'color': Color(0xFF9333EA),
      'bg': Color(0xFFFAF5FF),
      'exercises': [
        'Plank Hold',
        'Bicycle Crunches',
        'Russian Twists',
        'Leg Raises',
      ],
    },
  ];

  final List<Map<String, dynamic>> _presetRoutines = [
    {
      'id': 'routine_1',
      'title': 'Full Body Strength',
      'subtitle': 'A complete workout to build strength and endurance.',
      'image': AppAssets.workoutHero,
      'time': '30 min',
      'level': 'Intermediate',
      'calories': '250 kcal',
      'exercises': [
        'Push-ups - 3 sets × 15 reps',
        'Goblet Squats - 3 sets × 12 reps',
        'Dumbbell Rows - 3 sets × 10 reps',
        'Plank - 3 sets × 60s',
      ],
    },
    {
      'id': 'routine_2',
      'title': 'Morning Mobility',
      'subtitle': 'Start your day with energy and flexibility.',
      'image': AppAssets.articleConsistency,
      'time': '15 min',
      'level': 'Beginner',
      'calories': '120 kcal',
      'exercises': [
        'Cat-Cow Spine Flow - 2 min',
        'Deep Squat Hold - 2 min',
        'Thoracic Rotations - 3 min',
        'Downward Dog to Cobra - 3 min',
      ],
    },
    {
      'id': 'routine_3',
      'title': 'HIIT Blast',
      'subtitle': 'High intensity workout to burn fat fast.',
      'image': AppAssets.articleRoutine,
      'time': '20 min',
      'level': 'Advanced',
      'calories': '300 kcal',
      'exercises': [
        'Burpees - 45s work / 15s rest',
        'High Knees - 45s work / 15s rest',
        'Kettlebell Swings - 45s work / 15s rest',
        'Jump Lunges - 45s work / 15s rest',
      ],
    },
  ];

  final List<Map<String, dynamic>> _levelCategories = [
    {
      'level': 'Beginner',
      'subtitle': 'Build a strong foundation',
      'color': Color(0xFF16A34A),
      'bg': Color(0xFFF0FDF4),
      'bars': 1,
      'workoutsCount': '12 routines',
      'image': AppAssets.exerciseGuide,
      'time': '20 min',
      'calories': '140 kcal',
      'exercises': exerciseLibraryByLevel['Beginner'],
    },
    {
      'level': 'Intermediate',
      'subtitle': 'Take it to the next level',
      'color': Color(0xFF2563EB),
      'bg': Color(0xFFEFF6FF),
      'bars': 2,
      'workoutsCount': '24 routines',
      'image': AppAssets.exerciseGuide,
      'time': '30 min',
      'calories': '230 kcal',
      'exercises': exerciseLibraryByLevel['Intermediate'],
    },
    {
      'level': 'Advanced',
      'subtitle': 'Push your limits',
      'color': Color(0xFF9333EA),
      'bg': Color(0xFFFAF5FF),
      'bars': 3,
      'workoutsCount': '18 routines',
      'image': AppAssets.exerciseGuide,
      'time': '40 min',
      'calories': '340 kcal',
      'exercises': exerciseLibraryByLevel['Advanced'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadCustomRoutines();
  }

  Future<void> _loadCustomRoutines() async {
    try {
      final routines = await RoutineApi.instance.list();
      if (mounted) setState(() => _customRoutines = routines);
    } catch (_) {
      // The page remains usable offline; saves will report a specific error.
    } finally {
      if (mounted) setState(() => _isLoadingCustomRoutines = false);
    }
  }

  Map<String, dynamic> _routineWorkout(Routine routine) => {
    'id': routine.id,
    'title': routine.title,
    'subtitle': 'Your custom ${routine.level.toLowerCase()} routine.',
    'image': AppAssets.exerciseGuide,
    'time': '${routine.durationMinutes} min',
    'level': routine.level,
    'calories': 'Custom',
    'exercises': routine.exercises,
  };

  Future<void> _toggleFavorite(Routine routine) async {
    final nextFavorite = !routine.favorite;
    setState(() {
      _customRoutines = _customRoutines
          .map(
            (item) =>
                item.id == routine.id
                    ? item.copyWith(favorite: nextFavorite)
                    : item,
          )
          .toList();
    });
    try {
      final updated = await RoutineApi.instance.setFavorite(
        routine,
        nextFavorite,
      );
      if (!mounted) return;
      setState(() {
        _customRoutines = _customRoutines
            .map((item) => item.id == updated.id ? updated : item)
            .toList();
      });
    } catch (_) {
      // Keep optimistic update if backend is unreachable
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabTapped(String tab) {
    setState(() => _selectedTab = tab);
    if (tab == 'Preset Routines') {
      Scrollable.ensureVisible(
        _presetKey.currentContext ?? context,
        duration: const Duration(milliseconds: 350),
      );
    } else if (tab == 'Create Routine') {
      Scrollable.ensureVisible(
        _createKey.currentContext ?? context,
        duration: const Duration(milliseconds: 350),
      );
    } else if (tab == 'By Level') {
      Scrollable.ensureVisible(
        _levelKey.currentContext ?? context,
        duration: const Duration(milliseconds: 350),
      );
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showWorkoutStartSheet(Map<String, dynamic> workout) {
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
                  workout['image'] as String,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      workout['level'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                workout['subtitle'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workout['time'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: Color(0xFFEA580C),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workout['calories'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Routine Exercises:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              ...((workout['exercises'] as List<String>).map(
                (ex) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 40,
                          child: ExerciseVisual(exercise: ex, height: 40),
                        ),
                      ),
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
                    final minutes =
                        workout['durationMinutes'] as int? ??
                        int.tryParse(
                          (workout['time'] as String? ?? '20').split(' ').first,
                        ) ??
                        20;
                    Navigator.of(context).push(
                      MaterialPageRoute<bool>(
                        builder: (_) => WorkoutSessionScreen(
                          plan: WorkoutPlan(
                            title: workout['title'] as String? ?? 'Workout',
                            level: workout['level'] as String? ?? 'Beginner',
                            durationMinutes: minutes,
                            exercises:
                                (workout['exercises'] as List<dynamic>? ??
                                        const [])
                                    .whereType<String>()
                                    .toList(),
                            routineId: workout['id'] as String?,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Start Workout Now',
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

  void _showCreateRoutineModal() {
    final titleCtrl = TextEditingController(text: 'My Custom Routine');
    final customExerciseCtrl = TextEditingController();
    String selectedLevel = 'Intermediate';
    String selectedDuration = '30 mins';
    bool isSaving = false;
    final selectedExercises = <String>{};

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                16,
                22,
                MediaQuery.of(context).viewInsets.bottom + 32,
              ),
              child: SingleChildScrollView(
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
                      'Create Your Own Routine',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Customize exercises, targets, and sets to fit your goals.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Routine Name',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Target Level',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: ['Beginner', 'Intermediate', 'Advanced'].map((
                        lvl,
                      ) {
                        final isSel = selectedLevel == lvl;
                        return ChoiceChip(
                          label: Text(lvl),
                          selected: isSel,
                          selectedColor: const Color(0xFFDBEAFE),
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isSel
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSel
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF475569),
                          ),
                          onSelected: (val) => setModalState(() {
                            selectedLevel = lvl;
                            selectedExercises.clear();
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Choose Exercises',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: exerciseLibraryByLevel[selectedLevel]!
                            .map(
                              (exercise) => CheckboxListTile(
                                dense: true,
                                value: selectedExercises.contains(exercise),
                                activeColor: const Color(0xFF2563EB),
                                title: Text(
                                  exercise,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                secondary: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 44,
                                    child: ExerciseVisual(
                                      exercise: exercise,
                                      height: 44,
                                    ),
                                  ),
                                ),
                                onChanged: (selected) => setModalState(() {
                                  if (selected == true) {
                                    selectedExercises.add(exercise);
                                  } else {
                                    selectedExercises.remove(exercise);
                                  }
                                }),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: customExerciseCtrl,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Add your own exercise and target',
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          tooltip: 'Add exercise',
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                          ),
                          onPressed: () {
                            final exercise = customExerciseCtrl.text.trim();
                            if (exercise.isEmpty) return;
                            setModalState(() {
                              selectedExercises.add(exercise);
                              customExerciseCtrl.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (selectedExercises.any(
                      (exercise) => !exerciseLibraryByLevel[selectedLevel]!
                          .contains(exercise),
                    )) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedExercises
                            .where(
                              (exercise) =>
                                  !exerciseLibraryByLevel[selectedLevel]!
                                      .contains(exercise),
                            )
                            .map(
                              (exercise) => InputChip(
                                label: Text(exercise),
                                onDeleted: () => setModalState(
                                  () => selectedExercises.remove(exercise),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      'Target Duration',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: ['15 mins', '30 mins', '45 mins', '60 mins']
                          .map((dur) {
                            final isSel = selectedDuration == dur;
                            return ChoiceChip(
                              label: Text(dur),
                              selected: isSel,
                              selectedColor: const Color(0xFFDBEAFE),
                              backgroundColor: const Color(0xFFF1F5F9),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSel
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF475569),
                              ),
                              onSelected: (val) =>
                                  setModalState(() => selectedDuration = dur),
                            );
                          })
                          .toList(),
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
                        onPressed: isSaving
                            ? null
                            : () async {
                                final title = titleCtrl.text.trim();
                                if (title.isEmpty) return;
                                if (selectedExercises.isEmpty) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Choose at least one exercise.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                setModalState(() => isSaving = true);
                                try {
                                  final durationNum =
                                      int.tryParse(
                                        selectedDuration.split(' ').first,
                                      ) ??
                                      20;
                                  Routine routine;
                                  try {
                                    routine = await RoutineApi.instance.create(
                                      title: title,
                                      level: selectedLevel,
                                      durationMinutes: durationNum,
                                      exercises: selectedExercises.toList(),
                                    );
                                  } catch (_) {
                                    // Offline fallback: save locally so user is never blocked
                                    routine = Routine(
                                      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
                                      title: title,
                                      level: selectedLevel,
                                      durationMinutes: durationNum,
                                      exercises: selectedExercises.toList(),
                                      favorite: false,
                                    );
                                  }
                                  if (!mounted || !ctx.mounted) return;
                                  setState(() {
                                    _customRoutines = [
                                      routine,
                                      ..._customRoutines,
                                    ];
                                  });
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '"${routine.title}" is now in My Routines.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } catch (error) {
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not save routine: $error',
                                        ),
                                      ),
                                    );
                                  }
                                } finally {
                                  if (ctx.mounted) {
                                    setModalState(() => isSaving = false);
                                  }
                                }
                              },
                        child: Text(
                          isSaving ? 'Saving...' : 'Save Routine',
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Subtle organic background wave (floating animation)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: FloatingWaveBackground(height: 280),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Filter Pills
                        _buildTabPills(),
                        const SizedBox(height: 18),

                        // TODAY'S WORKOUT Hero Card
                        _buildHeroCard(),
                        const SizedBox(height: 24),

                        // Quick Start Section
                        _buildQuickStartSection(),
                        const SizedBox(height: 24),

                        // Preset Routines Section
                        Container(
                          key: _presetKey,
                          child: _buildPresetRoutinesSection(),
                        ),
                        const SizedBox(height: 24),

                        // Create Your Own Routine Section
                        Container(
                          key: _createKey,
                          child: _buildCreateRoutineSection(),
                        ),
                        const SizedBox(height: 24),

                        _buildMyRoutinesSection(),
                        const SizedBox(height: 24),

                        // Browse by Level Section
                        Container(
                          key: _levelKey,
                          child: _buildBrowseByLevelSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomNavBar()),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Workout',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Move stronger, every day.',
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
                  builder: (context) =>
                      SearchScreen(onBack: () => Navigator.pop(context)),
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
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Filter Pills
  // ---------------------------------------------------------------------------
  Widget _buildTabPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => _onTabTapped(tab),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFDBEAFE)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF93C5FD)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF64748B),
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
  // Hero Card
  // ---------------------------------------------------------------------------
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Hero trainer image on right
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 170,
              child: Image.asset(AppAssets.workoutHero, fit: BoxFit.cover),
            ),

            // Left Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF111827),
                      const Color(0xFF111827).withValues(alpha: 0.95),
                      const Color(0xFF111827).withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.7, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S WORKOUT",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: const Color(0xFF93C5FD),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Full Body Strength',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Build strength, improve endurance and feel great.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () =>
                              _showWorkoutStartSheet(_presetRoutines[0]),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Start Workout',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
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
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildHeroMetaPill(Icons.access_time_rounded, '30 min'),
                        const SizedBox(height: 6),
                        _buildHeroMetaPill(
                          Icons.bar_chart_rounded,
                          'Intermediate',
                        ),
                        const SizedBox(height: 6),
                        _buildHeroMetaPill(
                          Icons.local_fire_department_rounded,
                          '250 kcal',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroMetaPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Start Section
  // ---------------------------------------------------------------------------
  Widget _buildQuickStartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Start',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  _showCatalogSheet('Quick Start', _quickStartCategories),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _quickStartCategories.map((cat) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () {
                    _showWorkoutStartSheet({
                      ...cat,
                      'image': AppAssets.exerciseGuide,
                      'time': '20 min',
                      'level': 'Intermediate',
                      'calories': '180 kcal',
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cat['bg'] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 26,
                          color: cat['color'] as Color,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['title'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['subtitle'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
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
  // Preset Routines Section
  // ---------------------------------------------------------------------------
  Widget _buildPresetRoutinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Preset Routines',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  _showCatalogSheet('Preset Routines', _presetRoutines),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: _presetRoutines.map((routine) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
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
                  onTap: () => _showWorkoutStartSheet(routine),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            routine['image'] as String,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routine['title'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                routine['subtitle'] as String,
                                maxLines: 1,
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
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    routine['time'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.bar_chart_rounded,
                                    size: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    routine['level'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 12,
                                    color: Color(0xFFEA580C),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    routine['calories'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: Color(0xFF94A3B8),
                        ),
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
  // Create Your Own Routine Section
  // ---------------------------------------------------------------------------
  Widget _buildCreateRoutineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Own Routine',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
              onTap: _showCreateRoutineModal,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
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
                        Icons.add_rounded,
                        size: 24,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make Your Own Routine',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Choose exercises, set duration and create a workout that fits your goals.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyRoutinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Routines',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        if (_isLoadingCustomRoutines)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_customRoutines.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Your saved routines will appear here.',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF64748B),
              ),
            ),
          )
        else
          ..._customRoutines.map(
            (routine) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () => _showWorkoutStartSheet(_routineWorkout(routine)),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE0F2FE),
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  title: Text(
                    routine.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    '${routine.durationMinutes} min • ${routine.level}',
                  ),
                  trailing: IconButton(
                    tooltip: routine.favorite
                        ? 'Remove favorite'
                        : 'Add to favorites',
                    icon: Icon(
                      routine.favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: routine.favorite
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF64748B),
                    ),
                    onPressed: () => _toggleFavorite(routine),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showCatalogSheet(String title, List<Map<String, dynamic>> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        builder: (context, controller) => ListView.separated(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          itemCount: items.length + 1,
          separatorBuilder: (_, index) => const Divider(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              );
            }
            final item = items[index - 1];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 6,
              ),
              leading: _buildCatalogLeading(item),
              title: Text(
                (item['title'] ?? item['level']) as String,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                (item['subtitle'] ?? item['workoutsCount'] ?? '') as String,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(sheetContext);
                final workout = {
                  'title': item['title'] ?? item['level'],
                  'subtitle': item['subtitle'] ?? item['workoutsCount'],
                  'image': item['image'] ?? AppAssets.workoutHero,
                  'time': item['time'] ?? '20 min',
                  'level': item['level'] ?? 'All levels',
                  'calories': item['calories'] ?? 'Custom',
                  'exercises': item['exercises'] ?? const <String>[],
                };
                _showWorkoutStartSheet(workout);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCatalogLeading(Map<String, dynamic> item) {
    final image = item['image'];
    if (image is String) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(image, width: 54, height: 54, fit: BoxFit.cover),
      );
    }

    final icon = item['icon'] as IconData? ?? Icons.bar_chart_rounded;
    final color = item['color'] as Color? ?? const Color(0xFF2563EB);
    final background = item['bg'] as Color? ?? const Color(0xFFEFF6FF);
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 27),
    );
  }

  // ---------------------------------------------------------------------------
  // Browse by Level Section
  // ---------------------------------------------------------------------------
  Widget _buildBrowseByLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Browse by Level',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  _showCatalogSheet('Browse by Level', _levelCategories),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _levelCategories.map((lvl) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () {
                    _showWorkoutStartSheet({
                      'title': '${lvl['level']} Full Body',
                      'subtitle': lvl['subtitle'],
                      'image': AppAssets.exerciseGuide,
                      'time': lvl['time'],
                      'level': lvl['level'],
                      'calories': lvl['calories'],
                      'exercises': lvl['exercises'],
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lvl['bg'] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 20,
                              color: lvl['color'] as Color,
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: lvl['color'] as Color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lvl['level'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          lvl['subtitle'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
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
          _buildNavItem(
            Icons.auto_stories_outlined,
            Icons.auto_stories_rounded,
            'Resources',
            1,
          ),
          _buildNavItem(
            Icons.favorite_outline_rounded,
            Icons.favorite_rounded,
            'Favorite',
            2,
          ),
          _buildNavItem(
            Icons.support_agent_outlined,
            Icons.support_agent_rounded,
            'Support',
            3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlineIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
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
          // Already on Resources / Workout
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  FavoritesScreen(onBack: () => Navigator.pop(context)),
            ),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  SettingsScreen(onBack: () => Navigator.pop(context)),
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
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

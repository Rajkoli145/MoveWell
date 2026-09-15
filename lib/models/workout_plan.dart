/// Describes a workout before it is started. Both preset and custom routines
/// are converted into this same model for the live workout screen.
class WorkoutPlan {
  const WorkoutPlan({
    required this.title,
    required this.level,
    required this.durationMinutes,
    required this.exercises,
    this.routineId,
  });

  final String title;
  final String level;
  final int durationMinutes;
  final List<String> exercises;
  final String? routineId;

  /// Converts the map used by workout cards into a strongly typed plan.
  /// Defaults keep older/incomplete routine data safe to display.
  factory WorkoutPlan.fromMap(Map<String, dynamic> data) => WorkoutPlan(
    title: data['title'] as String? ?? 'Workout',
    level: data['level'] as String? ?? 'Beginner',
    durationMinutes: (data['durationMinutes'] as num?)?.round() ?? 20,
    exercises: (data['exercises'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
    routineId: data['id'] as String?,
  );

  /// Custom routines can be empty; in that case use exercises matching level.
  List<String> get resolvedExercises => exercises.isEmpty
      ? exerciseLibraryByLevel[level] ?? exerciseLibraryByLevel['Beginner']!
      : exercises;
}

/// The default library also powers the selectable exercises in custom routines.
const exerciseLibraryByLevel = <String, List<String>>{
  'Beginner': [
    'Bodyweight Squat — 3 sets × 10 reps',
    'Incline Push-up — 3 sets × 8 reps',
    'Glute Bridge — 3 sets × 12 reps',
    'Bird Dog — 3 sets × 8 each side',
  ],
  'Intermediate': [
    'Reverse Lunge — 3 sets × 10 each side',
    'Standard Push-up — 3 sets × 12 reps',
    'Dumbbell Shoulder Press — 3 sets × 10 reps',
    'Mountain Climber — 3 sets × 30 seconds',
  ],
  'Advanced': [
    'Jump Squat — 4 sets × 12 reps',
    'Burpee — 4 sets × 10 reps',
    'Single-leg Deadlift — 3 sets × 10 each side',
    'Plank Jack — 4 sets × 30 seconds',
  ],
};

// Compact early returns keep the exercise-to-sprite mapping readable.
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../models/workout_plan.dart';
import '../palette.dart';
import '../services/activity_api.dart';

class WorkoutSessionScreen extends StatefulWidget {
  /// Receives one fully prepared plan from Home or the workout library.
  const WorkoutSessionScreen({super.key, required this.plan});
  final WorkoutPlan plan;
  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  // Local UI state for the currently active workout; only the completed result
  // is persisted after the final exercise.
  Timer? _timer;
  int _seconds = 0;
  int _index = 0;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    // Increment once per second to provide a simple elapsed-workout timer.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    // Timers survive screen changes unless explicitly cancelled.
    _timer?.cancel();
    super.dispose();
  }

  String get _exercise => widget.plan.resolvedExercises[_index];
  // ~/ divides using whole numbers; padLeft keeps the timer in 00:00 format.
  String get _clock =>
      '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';
  Future<void> _next() async {
    // Most taps advance the local exercise index without making a network call.
    if (_index < widget.plan.resolvedExercises.length - 1) {
      setState(() => _index++);
      return;
    }
    // The final tap records a single completed workout and disables the button
    // until the API confirms the save.
    setState(() => _saving = true);
    _timer?.cancel();
    try {
      final summary = await ActivityApi.instance.recordWorkout(
        title: widget.plan.title,
        routineId: widget.plan.routineId,
        durationMinutes: widget.plan.durationMinutes,
        exercises: widget.plan.resolvedExercises,
      );
      if (!mounted) return;
      // Show the celebration screen, then return true to refresh Home progress.
      await Navigator.of(context).push(
        MaterialPageRoute<bool>(
          builder: (_) => WorkoutCompleteScreen(
            plan: widget.plan,
            summary: summary,
            elapsedSeconds: _seconds,
          ),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save this workout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.plan.resolvedExercises.length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  Text(
                    'WORKOUT IN PROGRESS',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                widget.plan.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Exercise ${_index + 1} of $total',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_index + 1) / total,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF2563EB),
                backgroundColor: const Color(0xFFDCEAFE),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: ExerciseVisual(exercise: _exercise, height: 210),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _exercise,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Move with control. Keep breathing and focus on good form.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      _clock,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    _saving
                        ? 'Saving your progress…'
                        : _index == total - 1
                        ? 'Complete workout'
                        : 'Mark exercise complete',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseVisual extends StatelessWidget {
  /// Selects one instructor pose from the generated exercise sprite sheets.
  const ExerciseVisual({super.key, required this.exercise, this.height = 150});
  final String exercise;
  final double height;

  (String, int) get _tile {
    // The first matching phrase selects a [grid asset, tile index] pair.
    final name = exercise.toLowerCase();
    if (name.contains('barbell squat'))
      return (AppAssets.exercisesCardioYogaGrid, 0);
    if (name.contains('bench press'))
      return (AppAssets.exercisesCardioYogaGrid, 1);
    if (name.contains('pull-up') || name.contains('pull up'))
      return (AppAssets.exercisesCardioYogaGrid, 2);
    if (name.contains('overhead press'))
      return (AppAssets.exercisesCardioYogaGrid, 3);
    if (name.contains('sprint')) return (AppAssets.exercisesCardioYogaGrid, 4);
    if (name.contains('jump rope'))
      return (AppAssets.exercisesCardioYogaGrid, 5);
    if (name.contains('high knee'))
      return (AppAssets.exercisesCardioYogaGrid, 6);
    if (name.contains('kettlebell'))
      return (AppAssets.exercisesCardioYogaGrid, 7);
    if (name.contains('sun salutation'))
      return (AppAssets.exercisesCardioYogaGrid, 8);
    if (name.contains('warrior')) return (AppAssets.exercisesCardioYogaGrid, 9);
    if (name.contains('cobra') && !name.contains('downward'))
      return (AppAssets.exercisesCardioYogaGrid, 10);
    if (name.contains('pigeon')) return (AppAssets.exercisesCardioYogaGrid, 11);
    if (name.contains('plank hold') || name.contains('forearm plank'))
      return (AppAssets.exercisesCoreMobilityGrid, 0);
    if (name.contains('bicycle'))
      return (AppAssets.exercisesCoreMobilityGrid, 1);
    if (name.contains('russian'))
      return (AppAssets.exercisesCoreMobilityGrid, 2);
    if (name.contains('leg raise'))
      return (AppAssets.exercisesCoreMobilityGrid, 3);
    if (name.contains('cat-cow'))
      return (AppAssets.exercisesCoreMobilityGrid, 4);
    if (name.contains('deep squat'))
      return (AppAssets.exercisesCoreMobilityGrid, 5);
    if (name.contains('thoracic'))
      return (AppAssets.exercisesCoreMobilityGrid, 6);
    if (name.contains('downward dog'))
      return (AppAssets.exercisesCoreMobilityGrid, 7);
    if (name.contains('dumbbell row'))
      return (AppAssets.exercisesCoreMobilityGrid, 8);
    if (name.contains('goblet'))
      return (AppAssets.exercisesCoreMobilityGrid, 9);
    if (name.contains('jump lunge'))
      return (AppAssets.exercisesCoreMobilityGrid, 10);
    if (name.contains('warm up') || name.contains('stretch'))
      return (AppAssets.exercisesCoreMobilityGrid, 11);
    if (name.contains('incline')) return (AppAssets.exercisesLevelGrid, 1);
    if (name.contains('glute')) return (AppAssets.exercisesLevelGrid, 2);
    if (name.contains('bird dog')) return (AppAssets.exercisesLevelGrid, 3);
    if (name.contains('reverse lunge') || name.contains('lunge'))
      return (AppAssets.exercisesLevelGrid, 4);
    if (name.contains('push-up') || name.contains('push up'))
      return (AppAssets.exercisesLevelGrid, 5);
    if (name.contains('shoulder press') || name.contains('push press'))
      return (AppAssets.exercisesLevelGrid, 6);
    if (name.contains('mountain')) return (AppAssets.exercisesLevelGrid, 7);
    if (name.contains('jump squat')) return (AppAssets.exercisesLevelGrid, 8);
    if (name.contains('burpee')) return (AppAssets.exercisesLevelGrid, 9);
    if (name.contains('deadlift')) return (AppAssets.exercisesLevelGrid, 10);
    if (name.contains('plank jack')) return (AppAssets.exercisesLevelGrid, 11);
    return (AppAssets.exercisesLevelGrid, 0);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: _SpriteTile(asset: _tile.$1, index: _tile.$2),
  );
}

class _SpriteTile extends StatelessWidget {
  const _SpriteTile({required this.asset, required this.index});
  final String asset;
  final int index;
  // Decode each large image once. Reusing it avoids work as exercises change.
  static final Map<String, Future<ui.Image>> _cache = {};

  Future<ui.Image> _load() => _cache.putIfAbsent(asset, () async {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    return (await codec.getNextFrame()).image;
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
    future: _load(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const ColoredBox(color: Color(0xFFE8F4FD));
      return CustomPaint(painter: _SpritePainter(snapshot.data!, index));
    },
  );
}

class _SpritePainter extends CustomPainter {
  const _SpritePainter(this.image, this.index);
  final ui.Image image;
  final int index;
  @override
  void paint(Canvas canvas, Size size) {
    // Each source sheet contains four columns and three rows. Crop one tile
    // and scale it with BoxFit.cover so it fills the exercise card cleanly.
    final tileWidth = image.width / 4;
    final tileHeight = image.height / 3;
    final tile = Rect.fromLTWH(
      (index % 4) * tileWidth,
      (index ~/ 4) * tileHeight,
      tileWidth,
      tileHeight,
    );
    final fitted = applyBoxFit(BoxFit.cover, tile.size, size);
    final crop = Alignment.center.inscribe(fitted.source, tile);
    canvas.drawImageRect(
      image,
      crop,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _SpritePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.index != index;
}

class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({
    super.key,
    required this.plan,
    required this.summary,
    required this.elapsedSeconds,
  });
  final WorkoutPlan plan;
  final ActivitySummary summary;
  final int elapsedSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 116,
                height: 116,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 68,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'You did it! 🎉',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 31,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${plan.title} is complete. Every session is a vote for the stronger you.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 1.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('${plan.resolvedExercises.length}', 'exercises'),
                  _stat('$_elapsedMinutes min', 'active time'),
                  _stat('${plan.durationMinutes * 8}', 'kcal est.'),
                ],
              ),
              const SizedBox(height: 30),
              ...summary.challenges
                  .where((c) => c.id != 'hydration-streak')
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        leading: const Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFF2563EB),
                        ),
                        title: Text(
                          c.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text('${c.progress}/${c.goal} complete'),
                        trailing: c.isComplete
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF16A34A),
                              )
                            : null,
                      ),
                    ),
                  ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2430),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Celebrate and continue',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _elapsedMinutes => (elapsedSeconds / 60).ceil().clamp(1, 999);
  Widget _stat(String value, String label) => Column(
    children: [
      Text(
        value,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Palette.ink,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          color: const Color(0xFF64748B),
        ),
      ),
    ],
  );
}

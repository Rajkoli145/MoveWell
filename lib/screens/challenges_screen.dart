import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';
import '../services/activity_api.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});
  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late Future<ActivitySummary> _summary = ActivityApi.instance.dashboard();
  bool _updating = false;
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  Future<void> _toggleCheckIn(WeeklyChallenge challenge) async {
    if (_updating) return;
    final completedToday = challenge.days.contains(_today());
    setState(() => _updating = true);
    try {
      final summary = await ActivityApi.instance.checkInChallenge(
        challengeId: challenge.id,
        completed: !completedToday,
      );
      if (mounted) {
        setState(() {
          _summary = Future.value(summary);
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update today\'s check-in: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  Future<void> _setWater(int glasses) async {
    if (_updating) return;
    setState(() => _updating = true);
    try {
      final summary = await ActivityApi.instance.setWater(glasses.clamp(0, 30));
      if (mounted) {
        setState(() {
          _summary = Future.value(summary);
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update hydration: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  IconData _icon(String name) => switch (name) {
    'water' => Icons.water_drop_rounded,
    'sun' => Icons.wb_sunny_rounded,
    _ => Icons.directions_run_rounded,
  };
  Color _color(String name) => switch (name) {
    'water' => const Color(0xFF0EA5E9),
    'sun' => const Color(0xFFF59E0B),
    _ => const Color(0xFF2563EB),
  };
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F9FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF5F9FC),
      elevation: 0,
      title: Text(
        'Weekly Challenges',
        style: GoogleFonts.plusJakartaSans(
          color: Palette.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: const IconThemeData(color: Palette.ink),
    ),
    body: FutureBuilder<ActivitySummary>(
      future: _summary,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Could not load challenges.',
              style: GoogleFonts.plusJakartaSans(),
            ),
          );
        }
        final challenges = snapshot.data!.challenges;
        return RefreshIndicator(
          onRefresh: () async {
            final refreshed = ActivityApi.instance.dashboard();
            setState(() {
              _summary = refreshed;
            });
            await refreshed;
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Small wins, strong week.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 18),
              ...challenges.map((challenge) {
                final color = _color(challenge.icon);
                final completedToday = challenge.days.contains(_today());
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(_icon(challenge.icon), color: color),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Palette.ink,
                                  ),
                                ),
                                Text(
                                  challenge.description,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (challenge.isComplete)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF16A34A),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      LinearProgressIndicator(
                        value: (challenge.progress / challenge.goal).clamp(
                          0,
                          1,
                        ),
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(10),
                        color: color,
                        backgroundColor: color.withValues(alpha: .13),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        '${challenge.progress} of ${challenge.goal} days',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      if (challenge.id == 'hydration-streak') ...[
                        const SizedBox(height: 14),
                        Text(
                          'Today\'s water',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton.outlined(
                              onPressed:
                                  _updating || snapshot.data!.waterGlasses == 0
                                  ? null
                                  : () => _setWater(
                                      snapshot.data!.waterGlasses - 1,
                                    ),
                              icon: const Icon(Icons.remove_rounded),
                              color: color,
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data!.waterGlasses} / 8 glasses',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                ),
                              ),
                            ),
                            IconButton.filled(
                              onPressed: _updating
                                  ? null
                                  : () => _setWater(
                                      snapshot.data!.waterGlasses + 1,
                                    ),
                              icon: const Icon(Icons.add_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: color,
                              ),
                            ),
                          ],
                        ),
                        if (snapshot.data!.waterGlasses < 8) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _updating ? null : () => _setWater(8),
                              icon: const Icon(
                                Icons.water_drop_outlined,
                                size: 18,
                              ),
                              label: const Text('I reached 8 glasses today'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: color,
                                side: BorderSide(
                                  color: color.withValues(alpha: .55),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ] else ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _updating
                                ? null
                                : () => _toggleCheckIn(challenge),
                            icon: Icon(
                              completedToday
                                  ? Icons.undo_rounded
                                  : Icons.check_circle_outline_rounded,
                              size: 18,
                            ),
                            label: Text(
                              completedToday
                                  ? 'Undo today\'s check-in'
                                  : 'Mark today complete',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: color,
                              side: BorderSide(
                                color: color.withValues(alpha: .55),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    ),
  );
}

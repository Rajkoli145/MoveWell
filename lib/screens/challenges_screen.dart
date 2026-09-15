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
          onRefresh: () async =>
              setState(() => _summary = ActivityApi.instance.dashboard()),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../palette.dart';
import '../services/routine_api.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _loading = true;
  List<Routine> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final routines = await RoutineApi.instance.list();
      if (mounted) {
        setState(
          () => _favorites = routines
              .where((routine) => routine.favorite)
              .toList(),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load favorites: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _removeFavorite(Routine routine) async {
    try {
      await RoutineApi.instance.setFavorite(routine, false);
      if (mounted) {
        setState(() => _favorites.removeWhere((item) => item.id == routine.id));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7FAFD),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Palette.ink),
        onPressed: widget.onBack ?? () => Navigator.maybePop(context),
      ),
      title: Text(
        'Favorite Routines',
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: Palette.ink,
        ),
      ),
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _favorites.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 56,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite routines yet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart on one of your custom routines to save it here.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _favorites.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final routine = _favorites[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.fitness_center_rounded),
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
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFEF4444),
                  ),
                  onPressed: () => _removeFavorite(routine),
                ),
              );
            },
          ),
  );
}

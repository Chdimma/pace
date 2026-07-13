import 'package:flutter/material.dart';
import 'models/exercise.dart';
import 'exercise_screen.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surfaceCard = Color(0xFF1E1E1E);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);

class ExerciseLibraryPage extends StatelessWidget {
  final String category;

  const ExerciseLibraryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [];

    if (category == "Popular Exercises") {
      exercises = Exercise.popularExercises();
    } else {
      exercises = Exercise.recommendedExercises();
    }

    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0B0B0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(category, style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: exercises.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center_outlined, size: 72, color: Color(0xFF333333)),
                    const SizedBox(height: 16),
                    Text("No exercises available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textMuted)),
                    const SizedBox(height: 8),
                    Text("Check back later for new exercises.", style: TextStyle(fontSize: 14, color: _textMuted)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseScreen(exercise: exercise)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _divider, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.fitness_center, color: _accentSoft),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exercise.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: _textPrimary)),
                              Text("${exercise.duration} • ${exercise.level}", style: TextStyle(color: _textMuted, fontSize: 13)),
                            ],
                          ),
                        ),
                        Icon(Icons.play_circle_outline, color: _accentSoft, size: 28),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
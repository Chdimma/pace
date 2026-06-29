import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Exercise {
  final String title;
  final String duration;
  final String level;

  Exercise({required this.title, required this.duration, required this.level});
}

class ExerciseLibraryPage extends StatelessWidget {
  final String category;

  const ExerciseLibraryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [];

    if (category == "Popular Exercises") {
      exercises = [
        Exercise(title: "Full Body Yoga", duration: "20 min", level: "Beginner"),
        Exercise(title: "Core Strength", duration: "15 min", level: "Intermediate"),
        Exercise(title: "Morning Stretch", duration: "10 min", level: "Beginner"),
        Exercise(title: "HIIT Cardio", duration: "25 min", level: "Advanced"),
        Exercise(title: "Pilates Flow", duration: "30 min", level: "Intermediate"),
        Exercise(title: "Power Walking", duration: "45 min", level: "Beginner"),
        Exercise(title: "Dance Fitness", duration: "30 min", level: "Beginner"),
        Exercise(title: "Strength Training", duration: "40 min", level: "Advanced"),
        Exercise(title: "Mobility Flow", duration: "15 min", level: "Beginner"),
        Exercise(title: "Evening Wind Down", duration: "12 min", level: "Beginner"),
      ];
    } else {
      // Default or "Recommended for you"
      exercises = [
        Exercise(title: "Deep Neck Flexion", duration: "10 min", level: "Intermediate"),
        Exercise(title: "Wall Angels", duration: "8 min", level: "Beginner"),
        Exercise(title: "Cat-Cow Stretch", duration: "5 min", level: "Beginner"),
        Exercise(title: "Chest Opener Stretch", duration: "5 min", level: "Beginner"),
        Exercise(title: "Thoracic Extension", duration: "5 min", level: "Intermediate"),
        Exercise(title: "Scapular Squeezes", duration: "3 min", level: "Beginner"),
        Exercise(title: "Plank for Stability", duration: "3 min", level: "Advanced"),
        Exercise(title: "Bird-Dog Exercise", duration: "10 min", level: "Intermediate"),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1CDE3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fitness_center, color: Color(0xFF764697)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${exercise.duration} • ${exercise.level}",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_outline, color: Color(0xFF764697), size: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

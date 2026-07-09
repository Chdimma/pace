import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'exercise_library_page.dart';
import 'exercise_screen.dart';
import 'models/exercise.dart';
import 'models/user_data.dart';

class WorkoutFitnessPage extends StatefulWidget {
  const WorkoutFitnessPage({super.key});

  @override
  State<WorkoutFitnessPage> createState() => _WorkoutFitnessPageState();
}

class PopularExercise {
  final String title;
  final String duration;
  final Color color;

  PopularExercise({required this.title, required this.duration, required this.color});
}

class _WorkoutFitnessPageState extends State<WorkoutFitnessPage> {
  final List<PopularExercise> _allPopularExercises = [
    PopularExercise(title: "Full Body Yoga", duration: "20 min", color: const Color(0xFF764697)),
    PopularExercise(title: "Core Strength", duration: "15 min", color: const Color(0xFF270530)),
    PopularExercise(title: "Morning Stretch", duration: "10 min", color: const Color(0xFF8D45B2)),
    PopularExercise(title: "HIIT Cardio", duration: "25 min", color: const Color(0xFF4F0382)),
    PopularExercise(title: "Pilates Flow", duration: "30 min", color: const Color(0xFF764697)),
    PopularExercise(title: "Dance Fitness", duration: "30 min", color: const Color(0xFF270530)),
    PopularExercise(title: "Power Walking", duration: "45 min", color: const Color(0xFF8D45B2)),
  ];

  late List<PopularExercise> _currentPopular;

  @override
  void initState() {
    super.initState();
    _refreshPopular();
  }

  void _refreshPopular() {
    setState(() {
      // Filter out what the user is currently using
      final available = _allPopularExercises.where((ex) => ex.title != currentUser.activeExerciseTitle).toList();
      // Shuffle and pick 3
      available.shuffle();
      _currentPopular = available.take(3).toList();
    });
  }

  /// Finds an Exercise object by matching the title from the mock data sets.
  Exercise? _findExerciseByTitle(String title) {
    // Search in popular exercises first
    for (final ex in Exercise.popularExercises()) {
      if (ex.title == title) return ex;
    }
    // Then search in recommended exercises
    for (final ex in Exercise.recommendedExercises()) {
      if (ex.title == title) return ex;
    }
    return null;
  }

  void _navigateToExercise(String title, String duration, String level) {
    // Look up the full Exercise object; if not found, create a minimal one
    final exercise = _findExerciseByTitle(title) ??
        Exercise(title: title, duration: duration, level: level);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Text(
                "Hi, ${currentUser.name}!",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Keep your body fit",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Recommended Section
              _buildSectionHeader("Recommended for you"),
              const SizedBox(height: 16),
              ..._buildSmartRecommendations(),
              
              const SizedBox(height: 32),

              // Popular Exercises
              Row(
                children: [
                  Expanded(child: _buildSectionHeader("Popular Exercises")),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF764697), size: 20),
                    onPressed: _refreshPopular,
                    tooltip: "Simulate Data Refresh",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentPopular.length,
                  itemBuilder: (context, index) {
                    final ex = _currentPopular[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _buildPopularItem(
                        title: ex.title,
                        duration: ex.duration,
                        color: ex.color,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Consistent Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIcon(Icons.home_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const HomePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.star_outline, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const MyActivitiesPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.access_time, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const MySchedulePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.directions_run, isActive: true), // Active
            _buildNavIcon(Icons.settings_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const SettingsPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSmartRecommendations() {
    // Posture analysis logic
    final bool isSlouchingTooMuch = currentUser.slouchingSeconds > (currentUser.goodPostureSeconds * 0.3);
    final int score = currentUser.postureScore;

    // Case 1: High Slouching Trend (Based on Graph/History logic)
    if (isSlouchingTooMuch) {
      return [
        _buildExerciseCard(
          title: "Thoracic Extension",
          duration: "5 min",
          intensity: "Medium",
          imageUrl: "assets/thoracic.png",
          color: const Color(0xFFFFEBEE),
          tag: "Slouching Detected",
        ),
        const SizedBox(height: 16),
        _buildExerciseCard(
          title: "Scapular Squeezes",
          duration: "3 min",
          intensity: "Low",
          imageUrl: "assets/scapular.png",
          color: const Color(0xFFFCE4EC),
          tag: "Upper Back Fix",
        ),
      ];
    }

    // Case 2: Low Current Score (Posture Ring)
    if (score < 70) {
      return [
        _buildExerciseCard(
          title: "Deep Neck Flexion",
          duration: "10 min",
          intensity: "High",
          imageUrl: "assets/neck_correction.png",
          color: const Color(0xFFE1BEE7),
          tag: "Ring Score: Low",
        ),
        const SizedBox(height: 16),
        _buildExerciseCard(
          title: "Wall Angels",
          duration: "8 min",
          intensity: "Medium",
          imageUrl: "assets/wall_angels.png",
          color: const Color(0xFFF3E5F5),
          tag: "Alignment Needed",
        ),
      ];
    }

    // Case 3: Good Posture (Maintenance)
    return [
      _buildExerciseCard(
        title: "Plank for Stability",
        duration: "3 min",
        intensity: "High",
        imageUrl: "assets/plank.png",
        color: const Color(0xFFE8EAF6),
        tag: "Maintain Excellence",
      ),
      const SizedBox(height: 16),
      _buildExerciseCard(
        title: "Bird-Dog Exercise",
        duration: "10 min",
        intensity: "Medium",
        imageUrl: "assets/bird_dog.png",
        color: const Color(0xFFE3F2FD),
        tag: "Core & Balance",
      ),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseLibraryPage(category: title),
              ),
            );
          },
          child: Text(
            "See all",
            style: GoogleFonts.poppins(
              color: const Color(0xFF764697),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String duration,
    required String intensity,
    required String imageUrl,
    required Color color,
    required String tag,
  }) {
    return GestureDetector(
      onTap: () => _navigateToExercise(title, duration, intensity),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(duration, style: GoogleFonts.poppins(color: Colors.black54)),
                      const SizedBox(width: 16),
                      const Icon(Icons.bolt, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(intensity, style: GoogleFonts.poppins(color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill, size: 48, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem({required String title, required String duration, required Color color}) {
    return GestureDetector(
      onTap: () => _navigateToExercise(title, duration, "Medium"),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              duration,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return IconButton(
      icon: Icon(icon, color: isActive ? const Color(0xFF764697) : Colors.black, size: 28),
      onPressed: onTap ?? () {},
    );
  }
}
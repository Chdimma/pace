import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'exercise_library_page.dart';
import 'exercise_screen.dart';
import 'models/exercise.dart';
import 'models/user_data.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

class PopularExercise {
  final String title;
  final String duration;
  final Color color;

  PopularExercise({required this.title, required this.duration, required this.color});
}

class WorkoutFitnessPage extends StatefulWidget {
  const WorkoutFitnessPage({super.key});

  @override
  State<WorkoutFitnessPage> createState() => _WorkoutFitnessPageState();
}

class _WorkoutFitnessPageState extends State<WorkoutFitnessPage> {
  final List<PopularExercise> _allPopularExercises = [
    PopularExercise(title: "Full Body Yoga", duration: "20 min", color: const Color(0xFF5A2D82)),
    PopularExercise(title: "Core Strength", duration: "15 min", color: const Color(0xFF3D1A5C)),
    PopularExercise(title: "Morning Stretch", duration: "10 min", color: const Color(0xFF764697)),
    PopularExercise(title: "HIIT Cardio", duration: "25 min", color: const Color(0xFF1E1E1E)),
    PopularExercise(title: "Pilates Flow", duration: "30 min", color: const Color(0xFF5A2D82)),
    PopularExercise(title: "Dance Fitness", duration: "30 min", color: const Color(0xFF3D1A5C)),
    PopularExercise(title: "Power Walking", duration: "45 min", color: const Color(0xFF764697)),
  ];

  late List<PopularExercise> _currentPopular;

  @override
  void initState() {
    super.initState();
    _refreshPopular();
  }

  void _refreshPopular() {
    setState(() {
      final available = _allPopularExercises.where((ex) => ex.title != currentUser.activeExerciseTitle).toList();
      available.shuffle();
      _currentPopular = available.take(3).toList();
    });
  }

  Exercise? _findExerciseByTitle(String title) {
    for (final ex in Exercise.popularExercises()) {
      if (ex.title == title) return ex;
    }
    for (final ex in Exercise.recommendedExercises()) {
      if (ex.title == title) return ex;
    }
    return null;
  }

  void _navigateToExercise(String title, String duration, String level) {
    final exercise = _findExerciseByTitle(title) ?? Exercise(title: title, duration: duration, level: level);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseScreen(exercise: exercise)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi, ${currentUser.username}!", style: TextStyle(fontSize: 16, color: _textMuted)),
              const SizedBox(height: 4),
              Text("Keep your body fit", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textPrimary)),
              const SizedBox(height: 28),
              _buildSectionHeader("Recommended for you"),
              const SizedBox(height: 16),
              ..._buildSmartRecommendations(),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _buildSectionHeader("Popular Exercises")),
                  IconButton(icon: Icon(Icons.refresh, color: _accentSoft, size: 20), onPressed: _refreshPopular, tooltip: "Refresh"),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentPopular.length,
                  itemBuilder: (context, index) {
                    final ex = _currentPopular[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _buildPopularItem(title: ex.title, duration: ex.duration, color: ex.color),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  List<Widget> _buildSmartRecommendations() {
    final bool isSlouchingTooMuch = currentUser.slouchingSeconds > (currentUser.goodPostureSeconds * 0.3);
    final int score = currentUser.postureScore;

    if (isSlouchingTooMuch) {
      return [
        _buildExerciseCard(title: "Thoracic Extension", duration: "5 min", intensity: "Medium", color: const Color(0xFF2A1A3A), tag: "Slouching Detected"),
        const SizedBox(height: 12),
        _buildExerciseCard(title: "Scapular Squeezes", duration: "3 min", intensity: "Low", color: const Color(0xFF1E2A1A), tag: "Upper Back Fix"),
      ];
    }

    if (score < 70) {
      return [
        _buildExerciseCard(title: "Deep Neck Flexion", duration: "10 min", intensity: "High", color: const Color(0xFF2A1A3A), tag: "Score Alert"),
        const SizedBox(height: 12),
        _buildExerciseCard(title: "Wall Angels", duration: "8 min", intensity: "Medium", color: const Color(0xFF1E2A1A), tag: "Alignment Needed"),
      ];
    }

    return [
      _buildExerciseCard(title: "Plank for Stability", duration: "3 min", intensity: "High", color: const Color(0xFF1A2A1E), tag: "Maintain Excellence"),
      const SizedBox(height: 12),
      _buildExerciseCard(title: "Bird-Dog Exercise", duration: "10 min", intensity: "Medium", color: const Color(0xFF1A1A2A), tag: "Core & Balance"),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary)),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseLibraryPage(category: title))),
          child: Text("See all", style: TextStyle(color: _accentSoft, fontWeight: FontWeight.w500, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildExerciseCard({required String title, required String duration, required String intensity, required Color color, required String tag}) {
    return GestureDetector(
      onTap: () => _navigateToExercise(title, duration, intensity),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                    child: Text(tag, style: TextStyle(fontSize: 11, color: _textSecondary, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: _textMuted),
                      const SizedBox(width: 4),
                      Text(duration, style: TextStyle(color: _textMuted, fontSize: 13)),
                      const SizedBox(width: 16),
                      Icon(Icons.bolt, size: 14, color: _textMuted),
                      const SizedBox(width: 4),
                      Text(intensity, style: TextStyle(color: _textMuted, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, size: 28, color: Colors.white),
            ),
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
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withValues(alpha: 0.6)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 8),
            Text(duration, style: TextStyle(color: _textSecondary, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Start", style: TextStyle(color: _accentSoft, fontSize: 13)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: _accentSoft, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return IconButton(icon: Icon(icon, color: isActive ? _accentPrimary : _inactiveIcon, size: 26), onPressed: onTap ?? () {});
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(color: _bgPrimary, border: Border(top: BorderSide(color: _divider, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.home_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const HomePage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.star_outline, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MyActivitiesPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.access_time, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MySchedulePage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.directions_run, isActive: true),
          _buildNavIcon(Icons.settings_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const SettingsPage(), transitionDuration: Duration.zero))),
        ],
      ),
    );
  }
}
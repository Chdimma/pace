import 'package:flutter/material.dart';
import 'models/exercise.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _statusGreen = Color(0xFF4CAF50);
const Color _statusRed = Color(0xFFE53935);
const Color _divider = Color(0xFF2A2A2A);

class ExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseScreen({super.key, required this.exercise});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool _isWorkoutActive = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0B0B0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(exercise.title, style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _divider, width: 0.5),
                ),
                child: Icon(Icons.fitness_center, size: 60, color: _accentSoft),
              ),
            ),
            const SizedBox(height: 24),
            Text(exercise.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF777777)),
                const SizedBox(width: 6),
                Text(exercise.duration, style: const TextStyle(fontSize: 14, color: Color(0xFF777777))),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF764697).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(exercise.level, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9C6ADE))),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text("Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary)),
            const SizedBox(height: 12),
            Text(
              exercise.instructions.isNotEmpty
                  ? exercise.instructions
                  : "Follow along with the exercise. Listen to your body and take breaks as needed.",
              style: const TextStyle(fontSize: 14, color: Color(0xFFB0B0B0), height: 1.7),
            ),
            const SizedBox(height: 40),
            if (_isWorkoutActive) _buildWorkoutActiveBanner(),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _isWorkoutActive = !_isWorkoutActive),
                icon: Icon(_isWorkoutActive ? Icons.stop_circle_outlined : Icons.play_circle_fill, color: Colors.white),
                label: Text(
                  _isWorkoutActive ? "End Workout" : "Start Workout",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isWorkoutActive ? _statusRed : _accentPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Exercise Library", style: TextStyle(color: Color(0xFF9C6ADE), fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutActiveBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _statusGreen, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Workout in Progress", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: _statusGreen)),
                const SizedBox(height: 4),
                const Text("Follow the instructions. Stay hydrated!", style: TextStyle(fontSize: 13, color: Color(0xFF777777))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'settings_page.dart';
import 'notification_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'models/user_data.dart';
import 'services/notification_service.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surface = Color(0xFF161616);
const Color _surfaceCard = Color(0xFF222222);
const Color _accentPrimary = Color(0xFF764697);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _statusGreen = Color(0xFF4CAF50);
const Color _statusRed = Color(0xFFE53935);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

const TextStyle _capsLabel = TextStyle(
  fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.4, color: _textMuted,
);

const TextStyle _metricValue = TextStyle(
  fontSize: 22, fontWeight: FontWeight.w700, color: _textPrimary,
);

const TextStyle _bodyText = TextStyle(
  fontSize: 14, fontWeight: FontWeight.w400, color: _textSecondary, height: 1.6,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  final AppNotificationService _notifications = AppNotificationService.instance;

  @override
  void initState() {
    super.initState();
    currentUser.updateStreak();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text("Hi, ${currentUser.name}", style: TextStyle(fontSize: 15, color: _textMuted)),
              ),
              const SizedBox(height: 16),
              _StatusPill(isConnected: currentUser.isBotConnected),
              const SizedBox(height: 24),
              _PostureScoreCard(score: currentUser.postureScore, streak: currentUser.streak),
              const SizedBox(height: 16),
              _buildNextStretchTile(),
              const SizedBox(height: 20),
              _InsightCard(insight: currentUser.getDailyInsight()),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: _accentPrimary),
              ),
              const SizedBox(width: 8),
              Text("PACE", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _accentPrimary, letterSpacing: 2)),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                color: _textSecondary,
                onPressed: () => Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (_, _, _) => const NotificationPage(),
                  transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,
                )),
              ),
              Positioned(
                right: 6, top: 6,
                child: ValueListenableBuilder<int>(
                  valueListenable: _notifications.unreadCountNotifier,
                  builder: (context, unreadCount, _) {
                    if (unreadCount <= 0) return const SizedBox.shrink();
                    return Container(width: 8, height: 8, decoration: const BoxDecoration(color: _statusRed, shape: BoxShape.circle));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextStretchTile() {
    final isReady = currentUser.getNextStretchTimer() == "Ready!";
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("NEXT STRETCH", style: _capsLabel),
          const SizedBox(height: 12),
          Text(
            currentUser.getNextStretchTimer(),
            style: _metricValue.copyWith(color: isReady ? _statusGreen : _textPrimary),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isConnected;
  const _StatusPill({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: _divider, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: isConnected ? _statusGreen : _statusRed, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(isConnected ? "Online" : "Offline", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _textSecondary)),
        ],
      ),
    );
  }
}

class _PostureScoreCard extends StatelessWidget {
  final int score;
  final int streak;
  const _PostureScoreCard({required this.score, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: _divider, width: 0.5)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(
                  width: 130, height: 130,
                  child: CircularProgressIndicator(
                    value: score / 100, strokeWidth: 12,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor: const AlwaysStoppedAnimation<Color>(_accentPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                Text("$score%", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textPrimary)),
                const SizedBox(height: 4),
                const Text("POSTURE SCORE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: _textMuted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 100, color: _divider),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("STREAK", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: _textMuted)),
                const SizedBox(height: 8),
                Text("🔥", style: TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text("$streak ${streak == 1 ? 'day' : 'days'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String insight;
  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 3, height: 100, decoration: BoxDecoration(color: _accentPrimary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("TODAY'S INSIGHT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: _textMuted)),
                const SizedBox(height: 8),
                Text(insight, style: _bodyText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const _AppBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(color: _bgPrimary, border: Border(top: BorderSide(color: _divider, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home, currentIndex == 0, () {}),
          _navItem(Icons.star_outline, currentIndex == 1, () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MyActivitiesPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
          _navItem(Icons.access_time, currentIndex == 2, () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MySchedulePage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
          _navItem(Icons.directions_run, currentIndex == 3, () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const WorkoutFitnessPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
          _navItem(Icons.settings_outlined, currentIndex == 4, () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const SettingsPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 48, height: 48, child: Icon(icon, size: 24, color: isActive ? _accentPrimary : _inactiveIcon)),
    );
  }
}
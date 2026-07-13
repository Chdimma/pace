import 'package:flutter/material.dart';
import 'dart:async';
import 'settings_page.dart';
import 'notification_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'models/user_data.dart';
import 'services/notification_service.dart';

// ─── Color Palette (mature dark theme) ──────────────────────────────────────
const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surface = Color(0xFF161616);
const Color _surfaceCard = Color(0xFF222222);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _statusGreen = Color(0xFF4CAF50);
const Color _statusRed = Color(0xFFE53935);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

// ─── Typography Helpers ──────────────────────────────────────────────────────
const TextStyle _capsLabel = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.4,
  color: _textMuted,
);

const TextStyle _metricValue = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  color: _textPrimary,
);

const TextStyle _bodyText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: _textSecondary,
  height: 1.6,
);

// ─── Home Page ───────────────────────────────────────────────────────────────
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
      if (mounted) {
        setState(() {});
      }
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
              const SizedBox(height: 24),
              _StatusPill(isConnected: currentUser.isBotConnected),
              const SizedBox(height: 28),
              _PostureScoreCard(score: currentUser.postureScore),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: "STREAK",
                      value: "🔥 ${currentUser.streak} days",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricTile(
                      label: "NEXT STRETCH",
                      value: currentUser.getNextStretchTimer(),
                      valueColor: currentUser.getNextStretchTimer() == "Ready!"
                          ? _statusGreen
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _InsightCard(insight: currentUser.getDailyInsight()),
              const SizedBox(height: 20),
              _ActivityChart(data: currentUser.getGoodHistoryFor("Weekly")),
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
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currentUser.username,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: _textPrimary,
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                color: _textSecondary,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const NotificationPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: ValueListenableBuilder<int>(
                  valueListenable: _notifications.unreadCountNotifier,
                  builder: (context, unreadCount, _) {
                    if (unreadCount <= 0) return const SizedBox.shrink();
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _statusRed,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status Pill ─────────────────────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  final bool isConnected;
  const _StatusPill({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected ? _statusGreen : _statusRed,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? "Online" : "Offline",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Posture Score Card ──────────────────────────────────────────────────────
class _PostureScoreCard extends StatelessWidget {
  final int score;
  const _PostureScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _divider, width: 0.5),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 16,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: const AlwaysStoppedAnimation<Color>(_accentPrimary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "$score%",
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "POSTURE SCORE",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Metric Tile ─────────────────────────────────────────────────────────────
class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: _capsLabel),
          const SizedBox(height: 8),
          Text(
            value,
            style: _metricValue.copyWith(
              color: valueColor ?? _textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Insight Card ────────────────────────────────────────────────────────────
class _InsightCard extends StatelessWidget {
  final String insight;
  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 100,
            decoration: BoxDecoration(
              color: _accentPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODAY'S INSIGHT",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: _textMuted,
                  ),
                ),
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

// ─── Activity Sparkline ──────────────────────────────────────────────────────
class _ActivityChart extends StatelessWidget {
  final List<double> data;
  const _ActivityChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "THIS WEEK",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: _textMuted,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(data: data, barColor: _accentSoft),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Good Posture Minutes",
              style: TextStyle(fontSize: 11, color: _textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final Color barColor;

  _BarChartPainter({required this.data, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = barColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;
    const barWidth = 8.0;
    final totalWidth = data.length * barWidth + (data.length - 1) * 4.0;
    final startX = (size.width - totalWidth) / 2;
    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxVal) * size.height;
      final x = startX + i * (barWidth + 4.0);
      final y = size.height - barHeight;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

// ─── Bottom Navigation ───────────────────────────────────────────────────────
class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const _AppBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: _bgPrimary,
        border: Border(top: BorderSide(color: _divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home, currentIndex == 0, () {}),
          _navItem(Icons.star_outline, currentIndex == 1, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, _, _) => const MyActivitiesPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _navItem(Icons.access_time, currentIndex == 2, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, _, _) => const MySchedulePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _navItem(Icons.directions_run, currentIndex == 3, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, _, _) => const WorkoutFitnessPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _navItem(Icons.settings_outlined, currentIndex == 4, () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, _, _) => const SettingsPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          size: 24,
          color: isActive ? _accentPrimary : _inactiveIcon,
        ),
      ),
    );
  }
}
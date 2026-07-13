import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'notification_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'models/user_data.dart';
import 'services/notification_service.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surfaceCard = Color(0xFF1E1E1E);
const Color _surfaceInput = Color(0xFF222222);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _statusGreen = Color(0xFF4CAF50);
const Color _statusRed = Color(0xFFE53935);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

class MyActivitiesPage extends StatefulWidget {
  const MyActivitiesPage({super.key});

  @override
  State<MyActivitiesPage> createState() => _MyActivitiesPageState();
}

class _MyActivitiesPageState extends State<MyActivitiesPage> {
  String selectedTimeframe = "Daily";
  bool isSyncing = true;
  final AppNotificationService _notifications = AppNotificationService.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isSyncing = false;
          currentUser.lastSynced = DateTime.now();
          _notifications.addNotification('Your activity sync is complete.');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentSlouching = currentUser.getSlouchingFor(selectedTimeframe);
    final int currentGood = currentUser.getGoodPostureFor(selectedTimeframe);
    final List<double> currentGoodHistory = currentUser.getGoodHistoryFor(selectedTimeframe);
    final List<double> currentSlouchHistory = currentUser.getSlouchHistoryFor(selectedTimeframe);
    final bool isUnlocked = currentUser.isTimeframeUnlocked(selectedTimeframe);

    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_border, size: 28, color: _accentSoft),
                      const SizedBox(width: 10),
                      Text("My Activities", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: _textPrimary)),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_none, size: 26, color: _textSecondary),
                        onPressed: () => Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const NotificationPage(),
                          transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,
                        )),
                      ),
                      Positioned(
                        right: 8, top: 8,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isSyncing)
                    const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF764697))))
                  else
                    Icon(Icons.check_circle_outline, size: 14, color: _statusGreen),
                  const SizedBox(width: 8),
                  Text(
                    isSyncing ? "Syncing with PACE device..." : currentUser.getSyncStatus(),
                    style: TextStyle(fontSize: 12, color: _textMuted, fontStyle: isSyncing ? FontStyle.italic : FontStyle.normal),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: _surfaceInput, borderRadius: BorderRadius.circular(12), border: Border.all(color: _divider, width: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: TextStyle(color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: "Search activities",
                    hintStyle: TextStyle(color: _textMuted),
                    icon: Icon(Icons.search, color: _textMuted, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeframeChip("Daily"),
                  _buildTimeframeChip("Weekly"),
                  _buildTimeframeChip("Monthly"),
                  _buildTimeframeChip("Yearly"),
                ],
              ),
              const SizedBox(height: 24),
              if (isUnlocked) ...[
                _buildMetricCard(title: "Slouching", value: currentUser.formatDuration(currentSlouching), unit: currentUser.getDurationUnit(currentSlouching), color: _statusRed, percent: (currentSlouching % 60) / 60),
                const SizedBox(height: 16),
                _buildMetricCard(title: "Good Posture", value: currentUser.formatDuration(currentGood), unit: currentUser.getDurationUnit(currentGood), color: _accentSoft, percent: (currentGood % 60) / 60),
                const SizedBox(height: 24),
                Text("Posture Graph", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity, height: 200,
                  decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
                  padding: const EdgeInsets.all(20),
                  child: CustomPaint(
                    painter: SimpleLineChartPainter(goodData: currentGoodHistory, slouchData: currentSlouchHistory),
                  ),
                ),
              ] else
                _buildLockedState(selectedTimeframe),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("Good Posture", _accentSoft),
                  const SizedBox(width: 24),
                  _buildLegendItem("Slouching", _statusRed),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTimeframeChip(String label) {
    bool isActive = selectedTimeframe == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTimeframe = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _accentPrimary : _surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? _accentPrimary : _divider, width: 0.5),
        ),
        child: Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: isActive ? Colors.white : _textSecondary, fontSize: 13)),
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String unit, required Color color, required double percent}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
              const SizedBox(height: 4),
              Text("$value $unit", style: TextStyle(fontSize: 13, color: _textMuted)),
            ],
          ),
          SizedBox(
            width: 64, height: 64,
            child: CircularProgressIndicator(
              value: percent == 0 ? 0.05 : percent,
              strokeWidth: 6,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: _textMuted)),
      ],
    );
  }

  Widget _buildLockedState(String timeframe) {
    int daysLeft = currentUser.daysUntilUnlock(timeframe);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
      child: Column(
        children: [
          Icon(Icons.lock_outline, size: 56, color: _accentPrimary),
          const SizedBox(height: 16),
          Text("$timeframe Insights Locked", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 12),
          Text("Keep using PACE for $daysLeft more ${daysLeft == 1 ? 'day' : 'days'} to unlock your $timeframe report.",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: _textMuted, height: 1.5)),
        ],
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
          _buildNavIcon(Icons.star, isActive: true),
          _buildNavIcon(Icons.access_time, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MySchedulePage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.directions_run, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const WorkoutFitnessPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.settings_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const SettingsPage(), transitionDuration: Duration.zero))),
        ],
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  final List<double> goodData;
  final List<double> slouchData;

  SimpleLineChartPainter({required this.goodData, required this.slouchData});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = const Color(0xFF2A2A2A)..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    _drawLine(canvas, size, goodData, const Color(0xFF9C6ADE));
    _drawLine(canvas, size, slouchData, const Color(0xFFE53935));
  }

  void _drawLine(Canvas canvas, Size size, List<double> data, Color color) {
    if (data.isEmpty) return;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final path = Path();
    double dx = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      double y = size.height - (data[i] / 100 * size.height);
      double x = i * dx;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
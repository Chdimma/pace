import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'notification_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'models/user_data.dart'; // Import the model
import 'services/notification_service.dart';

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
    // Simulate background syncing when page opens
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isSyncing = false;
          currentUser.lastSynced = DateTime.now(); // Update the sync timestamp
          _notifications.addNotification('Your activity sync is complete.');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch data based on selected timeframe
    final int currentSlouching = currentUser.getSlouchingFor(selectedTimeframe);
    final int currentGood = currentUser.getGoodPostureFor(selectedTimeframe);
    final List<double> currentGoodHistory = currentUser.getGoodHistoryFor(selectedTimeframe);
    final List<double> currentSlouchHistory = currentUser.getSlouchHistoryFor(selectedTimeframe);
    final bool isUnlocked = currentUser.isTimeframeUnlocked(selectedTimeframe);

    return Scaffold(
      backgroundColor: const Color(0xFFBFA1C6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_border, size: 32, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "My Activities",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, size: 28, color: Colors.black),
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
                        right: 8,
                        top: 8,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _notifications.unreadCountNotifier,
                          builder: (context, unreadCount, _) {
                            if (unreadCount <= 0) {
                              return const SizedBox.shrink();
                            }

                            return Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
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
              const SizedBox(height: 8),

              // Sync Status Indicator
              Row(
                children: [
                  if (isSyncing)
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF764697)),
                      ),
                    )
                  else
                    const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    isSyncing ? "Syncing with PACE device..." : currentUser.getSyncStatus(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: isSyncing ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.poppins(color: Colors.black38),
                    icon: const Icon(Icons.search, color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Horizontal Timeframe Selector (Chips)
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
                // 4. Posture Metric Cards
                _buildMetricCard(
                  title: "Slouching",
                  value: currentUser.formatDuration(currentSlouching),
                  unit: currentUser.getDurationUnit(currentSlouching),
                  color: Colors.redAccent,
                  percent: (currentSlouching % 60) / 60,
                ),
                const SizedBox(height: 16),
                _buildMetricCard(
                  title: "Good posture",
                  value: currentUser.formatDuration(currentGood),
                  unit: currentUser.getDurationUnit(currentGood),
                  color: const Color(0xFF0D47A1), // Deep Blue
                  percent: (currentGood % 60) / 60,
                ),
                const SizedBox(height: 24),

                // 5. Posture Graph Zone
                Text(
                  "Posture graph",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: CustomPaint(
                    painter: SimpleLineChartPainter(
                      goodData: currentGoodHistory,
                      slouchData: currentSlouchHistory,
                    ),
                  ),
                ),
              ] else
                _buildLockedState(selectedTimeframe),

              const SizedBox(height: 12),
              // Graph Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("Good Posture", const Color(0xFF0D47A1)),
                  const SizedBox(width: 24),
                  _buildLegendItem("Slouching", Colors.redAccent),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Consistent Bottom Navigation Bar from home_page.dart
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
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
            _buildNavIcon(Icons.star), // Solid star for active page
            _buildNavIcon(Icons.access_time, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const MySchedulePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.directions_run, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const WorkoutFitnessPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
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

  Widget _buildTimeframeChip(String label) {
    bool isActive = selectedTimeframe == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTimeframe = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF764697) : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent == 0 ? 0.05 : percent, // Fallback for visibility
                  strokeWidth: 8,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: value.length > 7 ? 12 : (value.contains(' ') ? 14 : 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    unit,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 28),
      onPressed: onTap ?? () {},
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildLockedState(String timeframe) {
    int daysLeft = currentUser.daysUntilUnlock(timeframe);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Color(0xFF764697)),
          const SizedBox(height: 20),
          Text(
            "$timeframe Insights Locked",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We're still gathering your posture data. Keep using PACE for $daysLeft more ${daysLeft == 1 ? 'day' : 'days'} to unlock your $timeframe report!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
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
    // 1. Draw Grid Lines
    final gridPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw Good Posture Line (Deep Blue)
    _drawLine(canvas, size, goodData, const Color(0xFF0D47A1));

    // 3. Draw Slouching Line (Red)
    _drawLine(canvas, size, slouchData, Colors.redAccent);
  }

  void _drawLine(Canvas canvas, Size size, List<double> data, Color color) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double dx = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      // Normalize data (assuming max value is 100 for percentage)
      double y = size.height - (data[i] / 100 * size.height);
      double x = i * dx;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

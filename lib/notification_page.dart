import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'services/notification_service.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surfaceCard = Color(0xFF1E1E1E);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final AppNotificationService _notifications = AppNotificationService.instance;

  @override
  void initState() {
    super.initState();
    _notifications.markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notifications.notifications;

    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 40.0, bottom: 24.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: _textSecondary, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.notifications_none, size: 28, color: _accentSoft),
                  const SizedBox(width: 10),
                  Text("Notifications", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: _textPrimary)),
                ],
              ),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 56, color: _textMuted),
                          const SizedBox(height: 16),
                          Text("No notifications yet", style: TextStyle(fontSize: 16, color: _textMuted)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) => _buildNotificationCard(notifications[index]),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNotificationCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: _divider, width: 0.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: Color(0xFF9C6ADE), shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: _textSecondary, height: 1.4))),
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
          _buildNavIcon(Icons.star_outline, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MyActivitiesPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.access_time, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MySchedulePage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.directions_run, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const WorkoutFitnessPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.settings_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const SettingsPage(), transitionDuration: Duration.zero))),
        ],
      ),
    );
  }
}
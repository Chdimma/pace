import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'logout_page.dart';
import 'deleteaccount_page.dart';
import 'about_page.dart';
import 'account_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'check_records_page.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _statusRed = Color(0xFFE53935);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 24.0),
              child: Row(
                children: [
                  Icon(Icons.settings, size: 28, color: _accentSoft),
                  const SizedBox(width: 12),
                  Text("Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _textPrimary)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryHeader("GENERAL"),
                    _buildSettingsTile(Icons.person_outline, "Account", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountPage()))),
                    _buildDivider(),
                    _buildSettingsTile(Icons.notifications_none, "Notification", onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const NotificationPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
                    _buildDivider(),
                    _buildSettingsTile(Icons.supervisor_account, "PACE Bot"),
                    _buildDivider(),
                    _buildSettingsTile(Icons.stars, "Solana", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckRecordsPage()))),
                    _buildDivider(),
                    _buildSettingsTile(Icons.info_outline, "About", onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const AboutPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
                    _buildDivider(),
                    _buildSettingsTile(Icons.logout, "Log Out", onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const LogoutPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
                    _buildDivider(),
                    _buildSettingsTile(Icons.delete_outline, "Delete Account", titleColor: _statusRed, iconColor: _statusRed, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const DeleteAccountPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildCategoryHeader("FEEDBACK"),
                    _buildSettingsTile(Icons.share, "Tell a Friend", showArrow: false),
                    _buildDivider(),
                    _buildSettingsTile(Icons.help_outline, "Help & Feedback", showArrow: false),
                    _buildDivider(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 1.2)),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {bool showArrow = true, VoidCallback? onTap, Color? titleColor, Color? iconColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
      leading: Icon(icon, color: iconColor ?? _textSecondary, size: 24),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: titleColor ?? _textPrimary)),
      trailing: showArrow ? Icon(Icons.chevron_right, color: _inactiveIcon, size: 22) : null,
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDivider() {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0), child: Divider(color: _divider, height: 0.5, thickness: 0.5));
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
          _buildNavIcon(Icons.settings, isActive: true),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'logout_page.dart';
import 'deleteaccount_page.dart';
import 'about_page.dart';
import 'account_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';
import 'theme_font_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D45B2), // Matches bottom of gradient to show curves
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD8BFE5),
              Color(0xFF8D45B2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Zone
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 24.0),
                child: Row(
                  children: [
                    const Icon(Icons.settings, size: 32, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Body Zone
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: GENERAL
                      _buildCategoryHeader("GENERAL"),
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: "Account",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountPage(),
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.notifications_none,
                        title: "Notification",
                        showArrow: true,
                        onTap: () {
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
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.supervisor_account,
                        title: "PACE Bot",
                        showArrow: true,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.stars,
                        title: "Theme and Font",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThemeFontPage(),
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: "About",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const AboutPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.logout,
                        title: "Log Out",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const LogoutPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.delete_outline,
                        title: "Delete Account",
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const DeleteAccountPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      ),
                      _buildDivider(),

                      const SizedBox(height: 24),

                      // Section 2: FEEDBACK
                      _buildCategoryHeader("FEEDBACK"),
                      _buildSettingsTile(
                        icon: Icons.share,
                        title: "Tell a Friend",
                        showArrow: false,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: "Help & Feedback",
                        showArrow: false,
                      ),
                      _buildDivider(),
                      
                      const SizedBox(height: 80), // Extra space at bottom
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar (Copied from HomePage)
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
                  pageBuilder: (context, animation1, animation2) =>
                      const HomePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.star_outline, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const MyActivitiesPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.access_time, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const MySchedulePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.directions_run, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const WorkoutFitnessPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.settings), // Solid icon for active page
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: showArrow
          ? const Icon(Icons.arrow_forward, color: Colors.black54)
          : null,
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Divider(
        color: Colors.black12,
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 28),
      onPressed: onTap ?? () {},
    );
  }
}

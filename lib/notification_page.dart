import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'my_schedule_page.dart';
import 'workout_fitness_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D45B2), // Matches bottom of gradient
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
                padding: const EdgeInsets.only(left: 12.0, top: 40.0, bottom: 35.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Icon(Icons.notifications_none, size: 36, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      "Notifications",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Body Zone (Notification List)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  children: [
                    _buildNotificationCard("Hello there...."),
                    _buildNotificationCard(""), // Empty placeholder 2
                    _buildNotificationCard(""), // Empty placeholder 3
                    _buildNotificationCard(""), // Empty placeholder 4
                    _buildNotificationCard(""), // Empty placeholder 5
                    _buildNotificationCard(""), // Empty placeholder 6
                    const SizedBox(height: 80), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar (Exact same as home_page.dart)
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
            _buildNavIcon(Icons.settings_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const SettingsPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String text) {
    return Container(
      width: double.infinity,
      height: 60, // Consistent height for capsule shape
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Opaque off-white/light gray
        borderRadius: BorderRadius.circular(30), // Pill-shaped/stadium borders
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black54,
        ),
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

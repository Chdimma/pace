import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'login_page.dart'; // Import login_page instead of main.dart
import 'models/user_data.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D45B2),
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
            children: [
              // Header Zone
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 40.0, bottom: 20.0),
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 36, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Confirmation Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Are you sure you want to log out?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // 1. Mark as logged out
                            isLoggedIn = false;

                            // 2. Navigate back to Login
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D45B2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Yes, Logout",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8D45B2), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8D45B2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
      // Consistent Bottom Navigation Bar
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
            _buildNavIcon(context, Icons.home_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const HomePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(context, Icons.star_outline),
            _buildNavIcon(context, Icons.access_time),
            _buildNavIcon(context, Icons.directions_run),
            _buildNavIcon(context, Icons.settings_outlined, onTap: () {
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

  Widget _buildNavIcon(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 28),
      onPressed: onTap ?? () {},
    );
  }
}

import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'models/user_data.dart';

// ─── Color Palette (mature dark theme) ──────────────────────────────────────
const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFB0B0B0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Account",
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2A2A2A),
                      border: Border.all(color: _accentPrimary, width: 2),
                    ),
                    child: Icon(Icons.person, size: 80, color: _accentSoft),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: _accentPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _textPrimary),
            ),
            Text(
              currentUser.phoneNumber,
              style: TextStyle(fontSize: 14, color: _textMuted),
            ),
            const SizedBox(height: 40),
            _buildInfoTile(
              icon: Icons.person_outline,
              label: "Full Name",
              value: currentUser.name,
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.phone_android_outlined,
              label: "Phone Number",
              value: currentUser.phoneNumber,
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.email_outlined,
              label: "Email Address",
              value: currentUser.email,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _accentSoft, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: _textPrimary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: _divider, thickness: 0.5, height: 0.5);
  }
}
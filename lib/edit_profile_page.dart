import 'package:flutter/material.dart';
import 'models/user_data.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surfaceInput = Color(0xFF222222);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: const Color(0xFFB0B0B0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("DONE", style: TextStyle(color: _accentSoft, fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile picture update coming soon'), backgroundColor: _accentPrimary),
                  );
                },
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
                        decoration: const BoxDecoration(color: _accentPrimary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildReadOnlyField(
              label: "Phone Number", value: currentUser.phoneNumber, icon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 24),
            _buildReadOnlyField(
              label: "Email Address", value: currentUser.email, icon: Icons.email_outlined,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _surfaceInput,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _divider, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: _accentSoft, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(value, style: TextStyle(fontSize: 15, color: _textPrimary, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
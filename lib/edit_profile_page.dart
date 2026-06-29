import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_data.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: currentUser.name);
  final TextEditingController _phoneController = TextEditingController(text: currentUser.phoneNumber);
  final TextEditingController _emailController = TextEditingController(text: currentUser.email);
  final TextEditingController _locationController = TextEditingController(text: currentUser.location);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Logic to save changes
              setState(() {
                currentUser.name = _nameController.text;
                currentUser.phoneNumber = _phoneController.text;
                currentUser.email = _emailController.text;
                currentUser.location = _locationController.text;
              });
              Navigator.pop(context);
            },
            child: Text(
              "SAVE",
              style: GoogleFonts.poppins(
                color: const Color(0xFF8D45B2),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE1CDE3),
                      border: Border.all(color: const Color(0xFF8D45B2), width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Color(0xFF8D45B2),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8D45B2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildEditField(
              label: "Full Name",
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 24),
            _buildEditField(
              label: "Phone Number",
              controller: _phoneController,
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            _buildEditField(
              label: "Email Address",
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _buildEditField(
              label: "Location",
              controller: _locationController,
              icon: Icons.location_on_outlined,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5EEF7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: const Color(0xFF8D45B2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}

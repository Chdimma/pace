import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'package:google_fonts/google_fonts.dart';
import 'models/user_data.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Stack(
        children: [
          // Top-left purple linear gradient
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF764697),
                    Color(0x00764697),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow icon
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  const SizedBox(height: 200), // Spacing to start midway down
                  // "Create account" title
                  Text(
                    'Create account',
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Signin text link
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "sign in",
                          style: const TextStyle(
                            color: Color(0xFF4F0382),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.pop(context); // Takes you back to the login page!
                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Name Input
                  _buildRoundedTextField(hint: "Name", controller: _nameController),
                  const SizedBox(height: 15),
                  // Email or Phone Input
                  _buildRoundedTextField(hint: "Email or phone", controller: _emailController),
                  const SizedBox(height: 15),
                  // Password Input
                  _buildRoundedTextField(
                    hint: "Password",
                    obscureText: true,
                    controller: _passwordController,
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  // Username Input
                  _buildRoundedTextField(hint: "Username", controller: _usernameController),
                  const SizedBox(height: 60),
                  // Sign up Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String username = _usernameController.text.trim();

                        // Developer Bypass for Signup
                        if (kDebugMode && name.isEmpty && email.isEmpty) {
                          name = "Sample User";
                          email = "sample@pace.app";
                          password = "password123";
                          username = "sample_dev";
                        } else {
                          // Strict Validation for Release or if user started typing
                          if (name.isEmpty || email.isEmpty || password.isEmpty || username.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in all fields"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          // ... rest of validation (email format, etc.)
                        }

                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a valid email address"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (password.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password must be at least 6 characters"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        // 1. Save data to our model
                        currentUser.name = name;
                        currentUser.email = email;
                        currentUser.username = username;
                        currentUser.password = password;
                        currentUser.streak = 1;
                        currentUser.lastLoginDate = DateTime.now();
                        currentUser.joinDate = DateTime.now();
                        
                        // 2. Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account created successfully! Please sign in."),
                            backgroundColor: Color(0xFF764697),
                          ),
                        );

                        // 3. Navigate back to Login Page
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF764697),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sign up",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding for scroll
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedTextField({
    required String hint,
    bool obscureText = false,
    Widget? prefixIcon,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1CDE3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 20, horizontal: 20),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_page.dart';
import 'home_page.dart';
import 'signup_page.dart';
import 'models/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Stack(
        children: [
          // Top-right purple linear gradient
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
                  const SizedBox(height: 230),
                  // "Login" title
                  Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Signup text
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "signup",
                          style: const TextStyle(
                            color: Color(0xFF4F0382),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Phone Number Input
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1CDE3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone number",
                        hintStyle: GoogleFonts.poppins(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        prefixIcon: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 20),
                              Text(
                                "+234",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const VerticalDivider(
                                color: Colors.black26,
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Password Input
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1CDE3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.poppins(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black54,
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "FORGOT",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF4F0382),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Login Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        final phone = _phoneController.text.trim();
                        final password = _passwordController.text.trim();

                        // Bypass validation ONLY during development (kDebugMode)
                        if (kDebugMode && phone.isEmpty && password.isEmpty) {
                          isLoggedIn = true;
                          currentUser.lastLoginDate = DateTime.now();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                          return;
                        }

                        // Strict Validation (Always enforced in Release mode)
                        if (phone.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter both phone and password or leave both empty to skip"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        // Check against currentUser
                        bool isCorrectUser = (phone == currentUser.email || 
                                             phone == currentUser.phoneNumber.replaceAll(" ", "")) &&
                                            password == currentUser.password;

                        if (isCorrectUser) {
                          isLoggedIn = true;
                          currentUser.lastLoginDate = DateTime.now();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid credentials. Use the details from signup or leave empty to skip."),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
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
                              "Login",
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

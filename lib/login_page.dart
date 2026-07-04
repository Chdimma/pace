import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_page.dart';
import 'home_page.dart';
import 'services/auth_service.dart';
import 'signup_page.dart';
import 'models/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _usePhone = false;

  @override
  void dispose() {
    _identifierController.dispose();
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
                  Row(
                    children: [
                      _buildModeChip(label: 'Email', selected: !_usePhone),
                      const SizedBox(width: 10),
                      _buildModeChip(label: 'Phone', selected: _usePhone),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1CDE3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _identifierController,
                      keyboardType: _usePhone ? TextInputType.phone : TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: _usePhone ? 'Phone number' : 'Email address',
                        hintStyle: GoogleFonts.poppins(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        prefixIcon: Icon(
                          _usePhone ? Icons.phone_outlined : Icons.email_outlined,
                          color: Colors.black54,
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
                      onTap: _isSubmitting
                          ? null
                          : () async {
                              final identifier = _identifierController.text.trim();
                              final password = _passwordController.text.trim();

                              // Blank credentials bypass: navigate directly to the app
                              if (identifier.isEmpty && password.isEmpty) {
                                currentUser.lastLoginDate = DateTime.now();
                                isLoggedIn = true;
                                if (!mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage()),
                                );
                                return;
                              }

                              if (_usePhone) {
                                final phoneRegex = RegExp(r'^\+?[0-9\s-]{7,15}$');
                                if (!phoneRegex.hasMatch(identifier)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid phone number'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
                              } else {
                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(identifier)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid email address'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
                              }

                              setState(() => _isSubmitting = true);
                              try {
                                final result = await AuthService.login(
                                  email: _usePhone ? null : identifier,
                                  phoneNumber: _usePhone ? identifier : null,
                                  password: password,
                                );
                                if (result['success'] == true) {
                                  final user = result['user'];
                                  currentUser.name = user['name'] ?? currentUser.name;
                                  currentUser.email = user['email'] ?? currentUser.email;
                                  currentUser.username = user['username'] ?? currentUser.username;
                                  currentUser.phoneNumber = user['phoneNumber'] ?? currentUser.phoneNumber;
                                  isLoggedIn = true;
                                  currentUser.lastLoginDate = DateTime.now();
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                }
                              } catch (error) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString().replaceFirst('Exception: ', '')),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isSubmitting = false);
                                }
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
                              _isSubmitting ? 'Signing in...' : 'Login',
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

  Widget _buildModeChip({required String label, required bool selected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _usePhone = label == 'Phone';
          _identifierController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF764697) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF764697), width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : const Color(0xFF764697),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

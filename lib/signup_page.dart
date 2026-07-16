import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_data.dart';
import 'services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  bool _nameFieldFocused = false;
  bool _emailFieldFocused = false;
  bool _phoneFieldFocused = false;
  bool _passwordFieldFocused = false;
  bool _usernameFieldFocused = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();

    if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await AuthService.signup(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        username: username,
      );

      if (result['success'] == true) {
        currentUser.name = name;
        currentUser.email = email;
        currentUser.phoneNumber = phoneNumber;
        currentUser.username = username;
        currentUser.password = password;
        currentUser.streak = 1;
        currentUser.lastLoginDate = DateTime.now();
        currentUser.joinDate = DateTime.now();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Please sign in.'), backgroundColor: Color(0xFF764697)),
        );
        Navigator.pop(context);
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((result['message'] ?? 'Signup failed').toString()), backgroundColor: Colors.redAccent),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleWalletConnect() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet connection coming soon'), backgroundColor: Color(0xFF764697)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF764697))),
                  const SizedBox(width: 8),
                  Text('Pace', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF764697))),
                ],
              ),
              const SizedBox(height: 80),
              Text('Get started', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xFF888888))),
              const SizedBox(height: 4),
              Text('Create your account', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 48),
              // Full Name
              FocusScope(
                onFocusChange: (focused) => setState(() => _nameFieldFocused = focused),
                child: TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Full name',
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 14),
                    prefixIcon: Icon(Icons.person_outline, color: _nameFieldFocused ? const Color(0xFF764697) : const Color(0xFF666666), size: 20),
                    filled: true, fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF764697), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email
              FocusScope(
                onFocusChange: (focused) => setState(() => _emailFieldFocused = focused),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 14),
                    prefixIcon: Icon(Icons.email_outlined, color: _emailFieldFocused ? const Color(0xFF764697) : const Color(0xFF666666), size: 20),
                    filled: true, fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF764697), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone
              FocusScope(
                onFocusChange: (focused) => setState(() => _phoneFieldFocused = focused),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 14),
                    prefixIcon: Icon(Icons.phone_outlined, color: _phoneFieldFocused ? const Color(0xFF764697) : const Color(0xFF666666), size: 20),
                    filled: true, fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF764697), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password
              FocusScope(
                onFocusChange: (focused) => setState(() => _passwordFieldFocused = focused),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 14),
                    prefixIcon: Icon(Icons.lock_outline, color: _passwordFieldFocused ? const Color(0xFF764697) : const Color(0xFF666666), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF666666), size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true, fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF764697), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Username
              FocusScope(
                onFocusChange: (focused) => setState(() => _usernameFieldFocused = focused),
                child: TextField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSignUp(),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 14),
                    prefixIcon: Icon(Icons.alternate_email_outlined, color: _usernameFieldFocused ? const Color(0xFF764697) : const Color(0xFF666666), size: 20),
                    filled: true, fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF333333), width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF764697), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Create Account button
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF764697),
                    disabledBackgroundColor: const Color(0xFF764697).withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text('Create Account', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
              // Divider with "or"
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFF333333), thickness: 0.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or', style: GoogleFonts.poppins(color: const Color(0xFF666666), fontSize: 13)),
                  ),
                  const Expanded(child: Divider(color: Color(0xFF333333), thickness: 0.5)),
                ],
              ),
              const SizedBox(height: 20),
              // Connect Wallet button
              SizedBox(
                width: double.infinity, height: 56,
                child: OutlinedButton.icon(
                  onPressed: _handleWalletConnect,
                  icon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF764697), size: 22),
                  label: Text('Connect Wallet', style: GoogleFonts.poppins(color: const Color(0xFF764697), fontSize: 15, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF764697), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF888888)),
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Sign in",
                        style: const TextStyle(color: Color(0xFF764697), fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
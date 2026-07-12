import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isSubmitting = false;
  bool _phoneFieldFocused = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
              // Brand wordmark
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF764697),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pace',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF764697),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              // Subtitle
              Text(
                'Trouble logging in?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 4),
              // Headline
              Text(
                'Reset your password',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'Enter your phone number below and we\'ll send you an SMS with a reset link.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF888888),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              // Phone number input with country code prefix
              FocusScope(
                onFocusChange: (focused) {
                  setState(() => _phoneFieldFocused = focused);
                },
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF666666),
                      fontSize: 14,
                    ),
                    prefixIcon: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.phone_outlined,
                            color: _phoneFieldFocused
                                ? const Color(0xFF764697)
                                : const Color(0xFF666666),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "+234",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: _phoneFieldFocused
                                  ? const Color(0xFF764697)
                                  : const Color(0xFF888888),
                              fontSize: 14,
                            ),
                          ),
                          VerticalDivider(
                            color: const Color(0xFF333333),
                            thickness: 1,
                            indent: 12,
                            endIndent: 12,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF764697),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Send SMS button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          // Handle Send SMS logic
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF764697),
                    disabledBackgroundColor:
                        const Color(0xFF764697).withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Send SMS',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              // Back to sign in link
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Back to sign in',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF764697),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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
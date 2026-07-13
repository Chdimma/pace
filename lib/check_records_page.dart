import 'package:flutter/material.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textMuted = Color(0xFF777777);

class CheckRecordsPage extends StatelessWidget {
  const CheckRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0B0B0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Records',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment_outlined, size: 80, color: Color(0xFF333333)),
              const SizedBox(height: 16),
              Text(
                'Check Records',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Your health records will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: _textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
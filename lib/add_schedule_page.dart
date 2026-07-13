import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── Color Palette (mature dark theme) ──────────────────────────────────────
const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surface = Color(0xFF161616);
const Color _surfaceCard = Color(0xFF1E1E1E);
const Color _surfaceInput = Color(0xFF222222);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _divider = Color(0xFF2A2A2A);

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _activityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentPrimary,
              onPrimary: Colors.white,
              surface: _surfaceCard,
              onSurface: _textPrimary,
            ),
            dialogBackgroundColor: _surface,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Schedule",
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activity",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _activityController,
              style: TextStyle(color: _textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: _surfaceInput,
                hintText: "What are you planning?",
                hintStyle: TextStyle(color: _textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _surfaceInput,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _divider, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM d, yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 15, color: _textPrimary),
                    ),
                    Icon(Icons.calendar_today, color: _accentSoft, size: 20),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_activityController.text.isNotEmpty) {
                    Navigator.pop(context, {
                      'activity': _activityController.text,
                      'date': _selectedDate,
                    });
                  }
                },
                child: Text(
                  "Save Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
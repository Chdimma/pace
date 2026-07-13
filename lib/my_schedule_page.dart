import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'workout_fitness_page.dart';
import 'add_schedule_page.dart';
import 'services/notification_service.dart';

const Color _bgPrimary = Color(0xFF0D0D0D);
const Color _surfaceCard = Color(0xFF1E1E1E);
const Color _surfaceElevated = Color(0xFF252525);
const Color _accentPrimary = Color(0xFF764697);
const Color _accentSoft = Color(0xFF9C6ADE);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFFB0B0B0);
const Color _textMuted = Color(0xFF777777);
const Color _statusGreen = Color(0xFF4CAF50);
const Color _divider = Color(0xFF2A2A2A);
const Color _inactiveIcon = Color(0xFF555555);

class ScheduleItem {
  String text;
  Color bgColor;
  Color textColor;
  bool isCompleted;

  ScheduleItem({
    required this.text,
    this.bgColor = const Color(0xFF1E1E1E),
    this.textColor = const Color(0xFFF0F0F0),
    this.isCompleted = false,
  });
}

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  late List<DateTime> calendarDays;
  final AppNotificationService _notifications = AppNotificationService.instance;
  Map<String, List<ScheduleItem>> scheduleData = {};
  final DateTime today = DateTime.now();
  late DateTime selectedDate;
  int? selectedTaskIndex;
  bool _showDatePicker = false;

  String _dateToKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  List<ScheduleItem> get _currentItems => scheduleData[_dateToKey(selectedDate)] ?? [];

  @override
  void initState() {
    super.initState();
    selectedDate = today;
    calendarDays = List.generate(7, (index) => today.subtract(Duration(days: 3 - index)));
  }

  void _addNewTask() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSchedulePage()));
    if (result != null && result is Map) {
      setState(() {
        String key = _dateToKey(result['date']);
        if (!scheduleData.containsKey(key)) scheduleData[key] = [];
        scheduleData[key]!.add(ScheduleItem(text: result['activity'] as String));
        _notifications.addNotification('Schedule reminder: ${result['activity']}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: _accentPrimary.withValues(alpha: 0.15), shape: BoxShape.circle),
                            child: const Icon(Icons.access_time, color: _accentSoft, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Text("My Schedule", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: _textPrimary)),
                        ],
                      ),
                      if (_currentItems.isNotEmpty)
                        IconButton(
                          icon: Icon(selectedTaskIndex != null ? Icons.delete_outline : Icons.delete_sweep_outlined, color: _textMuted, size: 24),
                          onPressed: () {
                            setState(() {
                              if (selectedTaskIndex != null) {
                                scheduleData[_dateToKey(selectedDate)]!.removeAt(selectedTaskIndex!);
                                selectedTaskIndex = null;
                              } else {
                                scheduleData[_dateToKey(selectedDate)] = [];
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() => _showDatePicker = !_showDatePicker),
                    child: Text(DateFormat('MMMM d, yyyy').format(selectedDate), style: TextStyle(fontSize: 16, color: _textMuted)),
                  ),
                  Text(
                    selectedDate.day == today.day && selectedDate.month == today.month && selectedDate.year == today.year
                        ? "Today" : DateFormat('EEEE').format(selectedDate),
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: _textPrimary),
                  ),
                  if (_showDatePicker)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: _surfaceElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: _divider, width: 0.5)),
                      child: SizedBox(
                        height: 220, width: double.infinity,
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: today.subtract(const Duration(days: 365)),
                          lastDate: today,
                          onDateChanged: (date) => setState(() { selectedDate = date; selectedTaskIndex = null; _showDatePicker = false; }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  DateTime day = calendarDays[index];
                  bool isSelected = day.day == selectedDate.day && day.month == selectedDate.month && day.year == selectedDate.year;
                  return GestureDetector(
                    onTap: () => setState(() { selectedDate = day; selectedTaskIndex = null; }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('E').format(day), style: TextStyle(color: isSelected ? _accentSoft : _textMuted, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
                          const SizedBox(height: 4),
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: isSelected ? _accentPrimary : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: Text(day.day.toString(), style: TextStyle(color: isSelected ? Colors.white : _textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _currentItems.isEmpty
                  ? Center(child: Text('No schedule for this day', style: TextStyle(fontSize: 15, color: _textMuted)))
                  : Stack(
                      children: [
                        Positioned(left: 36, top: 0, bottom: 0, child: Container(width: 1.5, color: _divider)),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _currentItems.length,
                          itemBuilder: (context, index) => _buildScheduleItem(index),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: GestureDetector(
                  onTap: _addNewTask,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(color: _surfaceCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: _divider, width: 0.5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.add, color: _accentSoft, size: 20), const SizedBox(width: 8), Text("Add Task", style: TextStyle(color: _textSecondary, fontSize: 14))],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildScheduleItem(int index) {
    final item = _currentItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, height: 24, margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: item.isCompleted ? _statusGreen : _surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: item.isCompleted ? _statusGreen : _divider, width: 2),
            ),
            child: item.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTaskIndex = (selectedTaskIndex == index) ? null : index),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: selectedTaskIndex == index ? Border.all(color: _accentPrimary, width: 1) : Border.all(color: _divider, width: 0.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.text,
                        style: TextStyle(
                          fontSize: 15, color: item.isCompleted ? _textMuted : _textPrimary,
                          fontWeight: FontWeight.w500, height: 1.5,
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null, decorationColor: _textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => setState(() => item.isCompleted = !item.isCompleted),
                      child: Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: item.isCompleted ? _accentPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _divider, width: 1.5),
                        ),
                        child: item.isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return IconButton(icon: Icon(icon, color: isActive ? _accentPrimary : _inactiveIcon, size: 26), onPressed: onTap ?? () {});
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(color: _bgPrimary, border: Border(top: BorderSide(color: _divider, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.home_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const HomePage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.star_outline, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const MyActivitiesPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.access_time_filled, isActive: true),
          _buildNavIcon(Icons.directions_run, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const WorkoutFitnessPage(), transitionDuration: Duration.zero))),
          _buildNavIcon(Icons.settings_outlined, onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, _, _) => const SettingsPage(), transitionDuration: Duration.zero))),
        ],
      ),
    );
  }
}
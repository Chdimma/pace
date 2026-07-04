import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Using intl for easy date formatting
import 'home_page.dart';
import 'settings_page.dart';
import 'my_activities_page.dart';
import 'workout_fitness_page.dart';
import 'add_schedule_page.dart';
import 'services/notification_service.dart';

class ScheduleItem {
  String text;
  Color bgColor;
  Color textColor;
  bool isCompleted;

  ScheduleItem({
    required this.text,
    required this.bgColor,
    this.textColor = Colors.black,
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
    // Generate 7 days centered around today
    calendarDays = List.generate(7, (index) {
      return today.subtract(Duration(days: 3 - index));
    });

  }

  void _addNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSchedulePage()),
    );

    if (result != null && result is Map) {
      setState(() {
        String key = _dateToKey(result['date']);
        if (!scheduleData.containsKey(key)) {
          scheduleData[key] = [];
        }
        final activity = result['activity'] as String;
        scheduleData[key]!.add(ScheduleItem(
          text: activity,
          bgColor: Colors.white,
          textColor: Colors.black87,
        ));
        _notifications.addNotification('Schedule reminder: $activity');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA775B3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Header & Date Zone
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
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF270530),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.access_time, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "My schedule",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      if (_currentItems.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            selectedTaskIndex != null ? Icons.delete_outline : Icons.delete_sweep_outlined,
                            color: const Color(0xFF270530),
                            size: 28,
                          ),
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
                          tooltip: selectedTaskIndex != null ? "Delete selected task" : "Clear daily schedule",
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showDatePicker = !_showDatePicker;
                      });
                    },
                    child: Text(
                      DateFormat('MMMM d, yyyy').format(selectedDate),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFFE1CDE3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    selectedDate.day == today.day && 
                    selectedDate.month == today.month && 
                    selectedDate.year == today.year
                        ? "Today"
                        : DateFormat('EEEE').format(selectedDate),
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF270530),
                    ),
                  ),
                  if (_showDatePicker)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: today.subtract(const Duration(days: 365)),
                          lastDate: today,
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                              selectedTaskIndex = null;
                              _showDatePicker = false;
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Horizontal Date Selector Strip
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  DateTime day = calendarDays[index];
                  bool isSelected = day.day == selectedDate.day && 
                                   day.month == selectedDate.month && 
                                   day.year == selectedDate.year;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = day;
                        selectedTaskIndex = null; // Clear selection when changing date
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(day), // Mon, Tue, etc.
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : const Color(0xFFE1CDE3),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            day.day.toString(),
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : const Color(0xFFE1CDE3),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 4. Vertical Timeline & Schedule Cards
            Expanded(
              child: _currentItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'No schedule for this day',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFFE1CDE3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        // Vertical Tracking Line
                        Positioned(
                          left: 36,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: Colors.white,
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _currentItems.length,
                          itemBuilder: (context, index) {
                            return _buildScheduleItem(index);
                          },
                        ),
                      ],
                    ),
            ),
            
            // 5. Floating Action Button Accent
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: GestureDetector(
                  onTap: _addNewTask,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Color(0xFF270530), size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Consistent Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIcon(Icons.home_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const HomePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.star_outline, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const MyActivitiesPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.access_time_filled), // Active
            _buildNavIcon(Icons.directions_run, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const WorkoutFitnessPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
            _buildNavIcon(Icons.settings_outlined, onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const SettingsPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(int index) {
    final item = _currentItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline node
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 24),
          // Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedTaskIndex == index) {
                    selectedTaskIndex = null;
                  } else {
                    selectedTaskIndex = index;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: item.isCompleted ? const Color(0xFFE1CDE3) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: selectedTaskIndex == index
                      ? Border.all(color: const Color(0xFF270530), width: 2)
                      : null,
                ),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.text,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: item.textColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Completion Checkbox
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        item.isCompleted = !item.isCompleted;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: item.isCompleted ? const Color(0xFF270530) : Colors.white70,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: item.isCompleted 
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
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

  Widget _buildNavIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 28),
      onPressed: onTap ?? () {},
    );
  }
}

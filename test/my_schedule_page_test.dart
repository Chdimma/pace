import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/my_schedule_page.dart';

void main() {
  testWidgets('schedule page shows an empty state when no tasks are set for the selected day', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MySchedulePage()));

    expect(find.text('No schedule for this day'), findsOneWidget);
    expect(find.text('Workout by 7am'), findsNothing);
  });
}

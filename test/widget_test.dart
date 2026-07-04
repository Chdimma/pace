import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/exercise_library_page.dart';
import 'package:my_flutter_app/my_schedule_page.dart';

void main() {
  testWidgets('tapping an exercise shows its detail sheet and selected state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ExerciseLibraryPage(category: 'Popular Exercises')),
    );

    expect(find.text('Full Body Yoga'), findsOneWidget);

    await tester.tap(find.text('Full Body Yoga'));
    await tester.pumpAndSettle();

    expect(find.text('Start Exercise'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('tapping a session shows the assigned exercise', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MySchedulePage()));

    await tester.tap(find.text('Workout by 7am'));
    await tester.pumpAndSettle();

    expect(find.text('Full Body Yoga'), findsOneWidget);
    expect(find.text('Start Exercise'), findsOneWidget);
  });
}

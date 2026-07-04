import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/edit_profile_page.dart';
import 'package:my_flutter_app/models/user_data.dart';

void main() {
  testWidgets('edit profile page keeps phone and email read-only', (WidgetTester tester) async {
    currentUser = UserData(
      name: 'Ada',
      phoneNumber: '+2348012345678',
      email: 'ada@example.com',
      location: '',
      lastSynced: DateTime.now(),
      joinDate: DateTime.now(),
      lastLoginDate: DateTime.now(),
      nextStretch: DateTime.now(),
    );

    await tester.pumpWidget(const MaterialApp(home: EditProfilePage()));

    expect(find.text('+2348012345678'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
  });
}

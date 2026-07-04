import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/account_page.dart';
import 'package:my_flutter_app/models/user_data.dart';

void main() {
  testWidgets('account page shows the current phone number and omits the location field', (WidgetTester tester) async {
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

    await tester.pumpWidget(const MaterialApp(home: AccountPage()));

    expect(find.text('+2348012345678'), findsWidgets);
    expect(find.text('Location'), findsNothing);
  });
}

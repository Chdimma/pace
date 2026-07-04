import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/home_page.dart';
import 'package:my_flutter_app/login_page.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/user_data.dart';

void main() {
  testWidgets('MyApp starts on the login page when the user is logged out', (WidgetTester tester) async {
    isLoggedIn = false;

    await tester.pumpWidget(const MyApp());

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
}

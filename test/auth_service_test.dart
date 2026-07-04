import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/auth_service.dart';

void main() {
  group('AuthService login payload', () {
    test('uses email when an email identifier is provided', () {
      final payload = AuthService.buildLoginPayload(
        email: 'user@example.com',
        password: 'secret',
      );

      expect(payload['email'], 'user@example.com');
      expect(payload.containsKey('phoneNumber'), isFalse);
      expect(payload['password'], 'secret');
    });

    test('uses phoneNumber when a phone identifier is provided', () {
      final payload = AuthService.buildLoginPayload(
        phoneNumber: '+2348123456789',
        password: 'secret',
      );

      expect(payload['phoneNumber'], '+2348123456789');
      expect(payload.containsKey('email'), isFalse);
      expect(payload['password'], 'secret');
    });
  });
}

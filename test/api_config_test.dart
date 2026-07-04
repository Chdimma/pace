import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('uses Android emulator host for mobile builds', () {
      final url = ApiConfig.resolveBaseUrl(
        targetPlatform: TargetPlatform.android,
        isWeb: false,
      );

      expect(url, 'http://10.0.2.2:5000/api');
    });

    test('uses localhost for web builds', () {
      final url = ApiConfig.resolveBaseUrl(
        targetPlatform: TargetPlatform.android,
        isWeb: true,
      );

      expect(url, 'http://localhost:5000/api');
    });
  });
}

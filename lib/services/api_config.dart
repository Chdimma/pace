import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String defaultBaseUrl = 'http://localhost:5000/api';
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:5000/api';

  static String resolveBaseUrl({
    required TargetPlatform targetPlatform,
    required bool isWeb,
    String? fromEnv,
  }) {
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv.endsWith('/api') ? fromEnv : '$fromEnv/api';
    }

    if (isWeb) {
      return defaultBaseUrl;
    }

    if (targetPlatform == TargetPlatform.android) {
      return androidEmulatorBaseUrl;
    }

    return defaultBaseUrl;
  }

  static String get authBaseUrl {
    return resolveBaseUrl(
      targetPlatform: defaultTargetPlatform,
      isWeb: kIsWeb,
      fromEnv: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
    );
  }
}

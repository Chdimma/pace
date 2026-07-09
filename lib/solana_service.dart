import 'package:dio/dio.dart';

class SolanaService {
  // Use your correct backend local IP address
  static const String baseUrl = "http://10.0.2.2:5000"; 
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // 1. Authenticate Identity (Creates or logs in the user)
  Future<Map<String, dynamic>?> authenticateUserIdentity(String deviceOrUserId) async {
    try {
      // We hit the endpoint that handles auto-creating a wallet if one doesn't exist
      final response = await _dio.post('/api/posture-event', data: {
        'userId': deviceOrUserId,
        'eventType': 'account_sync',
        'postureScore': 100,
        'durationSecs': 0
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'publicKey': response.data['storedPublicKey'],
          'txHash': response.data['txHash']
        };
      }
    } catch (e) {
      print("❌ Web3 Auth Sync Error: $e");
    }
    return null;
  }

  // 2. Fetch the Full Append-Only Health Record Timeline
  Future<List<dynamic>> getVerifiableHealthTimeline(String walletAddress) async {
    try {
      final response = await _dio.get('/api/health-records/$walletAddress');
      if (response.statusCode == 200) {
        // Returns the clean, formatted array of logs ready for the UI
        return response.data['timeline']; 
      }
    } catch (e) {
      print("❌ Failed fetching blockchain records: $e");
    }
    return [];
  }
}
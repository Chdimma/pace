import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SolanaService {
  static const String baseUrl = 'https://pace-backend-delta.vercel.app/api/solana';
  static const String devnetRpc = 'https://api.devnet.solana.com';
  static const String mainnetRpc = 'https://api.mainnet-beta.solana.com';
  static const int timeoutSeconds = 15;
  static const String _walletKey = 'solana_wallet_address';
  
  static const _secureStorage = FlutterSecureStorage();
  
  SolanaService._();

  /// Check Solana network health
  static Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to check Solana health: ${response.statusCode}');
    } catch (error) {
      throw Exception('Solana health check failed: $error');
    }
  }

  /// Get SOL balance for a wallet address
  static Future<double> getBalance(String walletAddress) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/balance/$walletAddress'),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        // Convert lamports to SOL (1 SOL = 1 billion lamports)
        final balance = (data['balance'] as int) / 1000000000;
        return balance;
      }
      throw Exception('Failed to get balance: ${response.statusCode}');
    } catch (error) {
      throw Exception('Failed to fetch balance: $error');
    }
  }

  /// Save wallet address to secure storage
  static Future<void> saveWalletAddress(String address) async {
    try {
      await _secureStorage.write(key: _walletKey, value: address);
    } catch (error) {
      throw Exception('Failed to save wallet address: $error');
    }
  }

  /// Get saved wallet address
  static Future<String?> getSavedWalletAddress() async {
    try {
      return await _secureStorage.read(key: _walletKey);
    } catch (error) {
      throw Exception('Failed to retrieve wallet address: $error');
    }
  }

  /// Clear saved wallet
  static Future<void> clearWallet() async {
    try {
      await _secureStorage.delete(key: _walletKey);
    } catch (error) {
      throw Exception('Failed to clear wallet: $error');
    }
  }

  /// Validate if a string is a valid Solana address
  static bool isValidSolanaAddress(String address) {
    if (address.isEmpty) return false;
    if (address.length != 44) return false;

    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Z]+$');
    return base58Regex.hasMatch(address);
  }

  /// Build a tamper-evident activity record for wallet-backed identity.
  static Map<String, dynamic> buildActivityRecord(
    String walletAddress,
    String activityType, {
    required String description,
    int? durationSeconds,
    DateTime? timestamp,
  }) {
    final ts = timestamp ?? DateTime.now().toUtc();
    final id = '${activityType.toLowerCase()}-${ts.millisecondsSinceEpoch}';
    final payload = '$walletAddress|$activityType|$description|${durationSeconds ?? 0}|${ts.toIso8601String()}';
    final hash = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');

    return {
      'id': id,
      'walletAddress': walletAddress,
      'activityType': activityType,
      'description': description,
      'durationSeconds': durationSeconds ?? 0,
      'timestamp': ts.toIso8601String(),
      'hash': hash,
    };
  }

  /// Build a shareable URL for a tamper-evident record.
  static String buildShareableLink({
    required String walletAddress,
    required Map<String, dynamic> record,
  }) {
    final params = <String, String>{
      'wallet': walletAddress,
      'id': record['id'].toString(),
      'hash': record['hash'].toString(),
    };
    return 'https://pace.app/records?${Uri(queryParameters: params).query}';
  }
}

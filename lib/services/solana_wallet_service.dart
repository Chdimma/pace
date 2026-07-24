import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class SolanaWalletService {
  static SolanaWalletService? _instance;
  String? _publicKey;
  bool _isConnected = false;

  SolanaWalletService._();

  static SolanaWalletService get instance {
    _instance ??= SolanaWalletService._();
    return _instance!;
  }

  bool get isConnected => _isConnected;
  String? get publicKey => _publicKey;

  /// Check if Phantom wallet extension is installed in the browser
  bool _isPhantomInstalled() {
    if (!kIsWeb) return false;
    try {
      final solana = js.context['solana'];
      if (solana == null) return false;
      final isPhantom = js.context['solana']['isPhantom'] == true;
      return isPhantom;
    } catch (_) {
      return false;
    }
  }

  /// Connect to Phantom wallet
  Future<String?> connect() async {
    if (!kIsWeb) {
      throw Exception('Wallet connection is only available on web.');
    }

    if (!_isPhantomInstalled()) {
      throw Exception(
        'Phantom wallet is not installed. '
        'Please install the Phantom browser extension from https://phantom.app',
      );
    }

    try {
      // Request connection to Phantom wallet
      final response = await _jsPromise(
        js.context['solana'].callMethod('connect'),
      );

      if (response == null) {
        throw Exception('User rejected the connection request.');
      }

      _publicKey = response['publicKey']['toString']().toString();
      _isConnected = true;
      return _publicKey;
    } catch (e) {
      _isConnected = false;
      _publicKey = null;
      rethrow;
    }
  }

  /// Disconnect from Phantom wallet
  Future<void> disconnect() async {
    if (!kIsWeb || !_isConnected) return;
    try {
      await _jsPromise(
        js.context['solana'].callMethod('disconnect'),
      );
    } catch (_) {
      // Ignore disconnect errors
    }
    _isConnected = false;
    _publicKey = null;
  }

  /// Helper to convert JavaScript Promise to Dart Future
  static Future<dynamic> _jsPromise(dynamic promise) {
    final completer = Completer<dynamic>();

    promise.callMethod('then', [
      js.JsFunction.withThis((result) {
        completer.complete(result);
      }),
      js.JsFunction.withThis((error) {
        completer.completeError(
          Exception(error?.toString() ?? 'Promise rejected'),
        );
      }),
    ]);

    return completer.future;
  }
}
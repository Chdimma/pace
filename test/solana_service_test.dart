import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/solana_service.dart';

void main() {
  test('buildActivityRecord creates a tamper-evident hash and share link', () {
    final record = SolanaService.buildActivityRecord(
      'wallet-address-example',
      'Workout',
      description: 'Morning session',
      durationSeconds: 1800,
    );

    expect(record['walletAddress'], 'wallet-address-example');
    expect(record['activityType'], 'Workout');
    expect(record['hash'], isA<String>());
    expect(record['hash'].length, greaterThan(20));

    final link = SolanaService.buildShareableLink(
      walletAddress: 'wallet-address-example',
      record: record,
    );

    expect(link, startsWith('https://pace.app/records?'));
    expect(link, contains('wallet=wallet-address-example'));
    expect(link, contains('id=${record['id']}'));
    expect(link, contains('hash=${record['hash']}'));
  });
}

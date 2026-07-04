import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/notification_service.dart';

void main() {
  test('adds notifications and increments unread count', () {
    final service = AppNotificationService.instance;
    service.clearNotifications();

    service.addNotification('Reminder added: Stretch break');

    expect(service.notifications, contains('Reminder added: Stretch break'));
    expect(service.unreadCountNotifier.value, 1);
  });
}

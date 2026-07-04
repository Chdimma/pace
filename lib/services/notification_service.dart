import 'package:flutter/foundation.dart';

class AppNotificationService {
  AppNotificationService._();

  static final AppNotificationService instance = AppNotificationService._();

  final List<String> notifications = <String>[];
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  bool get hasUnread => unreadCountNotifier.value > 0;

  void addNotification(String message) {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return;
    }

    notifications.insert(0, trimmedMessage);
    unreadCountNotifier.value = unreadCountNotifier.value + 1;
  }

  void markAllAsRead() {
    unreadCountNotifier.value = 0;
  }

  void clearNotifications() {
    notifications.clear();
    unreadCountNotifier.value = 0;
  }
}

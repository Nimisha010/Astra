import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  /// ================= SINGLETON INSTANCE =================
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  /// ================= NOTIFICATION LIST =================
  /// Static so it stays alive during app session
  static final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  /// ================= ADD NOTIFICATION =================
  void addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    Map<String, dynamic>? data,
  }) {
    _notifications.insert(0, {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": title,
      "message": message,
      "icon": icon,
      "color": color,
      "timestamp": DateTime.now(),
      "read": false,
      "data": data ?? {},
    });

    notifyListeners();
  }

  /// ================= MARK ALL READ =================
  void markAllRead() {
    for (var n in _notifications) {
      n["read"] = true;
    }
    notifyListeners();
  }

  /// ================= MARK SINGLE READ =================
  void markRead(int id) {
    try {
      final item = _notifications.firstWhere((n) => n["id"] == id);
      item["read"] = true;
      notifyListeners();
    } catch (_) {
      // Avoid crash if notification not found
    }
  }

  /// ================= REMOVE NOTIFICATION =================
  void remove(int id) {
    _notifications.removeWhere((n) => n["id"] == id);
    notifyListeners();
  }

  /// ================= CLEAR ALL =================
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// ================= UNREAD COUNT =================
  int get unreadCount {
    return _notifications.where((n) => n["read"] == false).length;
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isPushEnabled = true;
  bool _isSoundEnabled = true;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get isPushEnabled => _isPushEnabled;
  bool get isSoundEnabled => _isSoundEnabled;

  NotificationProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _notificationService.getUserNotifications(user.uid).listen((notifications) {
          _notifications = notifications;
          notifyListeners();
        });
      } else {
        _notifications = [];
        notifyListeners();
      }
    });
  }

  void togglePushNotifications(bool value) {
    _isPushEnabled = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _isSoundEnabled = value;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _notificationService.markAsRead(user.uid, id);
    }
  }

  Future<void> markAllAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _notificationService.markAllAsRead(user.uid);
    }
  }

  Future<void> deleteNotification(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _notificationService.deleteNotification(user.uid, id);
    }
  }
}

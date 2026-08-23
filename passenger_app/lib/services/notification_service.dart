import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> init() async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get initial token
      String? token = await _fcm.getToken();
      if (token != null) {
        _saveDeviceToken(token);
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        _saveDeviceToken(newToken);
      });
    }
  }

  Future<void> _saveDeviceToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _db.collection('users').doc(user.uid).set({
          'device_token': token,
        }, SetOptions(merge: true)).timeout(const Duration(seconds: 10));
      } on FirebaseException catch (e) {
        debugPrint('Firestore Error (_saveDeviceToken): ${e.code}');
      } on TimeoutException {
        debugPrint('Timeout Error (_saveDeviceToken)');
      } catch (e) {
        debugPrint('Unknown Error (_saveDeviceToken): $e');
      }
    }
  }

  Stream<List<NotificationModel>> getUserNotifications(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return NotificationModel.fromMap(doc.id, doc.data());
            } catch (e) {
              debugPrint('Data Parsing Error (getUserNotifications): $e');
              return null;
            }
          }).where((item) => item != null).cast<NotificationModel>().toList();
        })
        .handleError((error) {
          if (error is FirebaseException) {
            debugPrint('Firestore Stream Error (getUserNotifications): ${error.code}');
          } else {
            debugPrint('Unknown Stream Error (getUserNotifications): $error');
          }
        });
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'is_read': true})
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (markAsRead): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (markAsRead)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (markAsRead): $e');
      rethrow;
    }
  }

  Future<void> markAllAsRead(String uid) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .where('is_read', isEqualTo: false)
          .get()
          .timeout(const Duration(seconds: 10));

      final batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit().timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (markAllAsRead): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (markAllAsRead)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (markAllAsRead): $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .delete()
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (deleteNotification): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (deleteNotification)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (deleteNotification): $e');
      rethrow;
    }
  }
}

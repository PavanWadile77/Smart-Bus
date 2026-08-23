import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // Live Bus Started, Bus Delayed, ETA Updated, etc.
  final String busId;
  final String routeId;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.busId,
    required this.routeId,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? '',
      busId: data['bus_id'] ?? '',
      routeId: data['route_id'] ?? '',
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
      isRead: data['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'bus_id': busId,
      'route_id': routeId,
      'created_at': createdAt,
      'is_read': isRead,
    };
  }
}

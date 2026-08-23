import 'package:cloud_firestore/cloud_firestore.dart';

class WaypointModel {
  final String id;
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime timestamp;

  WaypointModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.timestamp,
  });

  factory WaypointModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WaypointModel(
      id: doc.id,
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      speed: (data['speed'] ?? 0.0).toDouble(),
      timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

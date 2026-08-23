import 'package:cloud_firestore/cloud_firestore.dart';

class SOSModel {
  final String id;
  final String driverId;
  final String busId;
  final double latitude;
  final double longitude;
  final String status; 
  final DateTime timestamp;

  SOSModel({
    required this.id,
    required this.driverId,
    required this.busId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.timestamp,
  });

  factory SOSModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SOSModel(
      id: doc.id,
      driverId: data['driver_id'] ?? '',
      busId: data['bus_id'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'active',
      timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'bus_id': busId,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

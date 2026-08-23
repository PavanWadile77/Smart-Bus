import 'package:cloud_firestore/cloud_firestore.dart';

class TripHistoryModel {
  final String id;
  final String driverId;
  final String busId;
  final String routeId;
  final DateTime startTime;
  final DateTime endTime;
  final double distanceKm;
  final int totalStops;

  TripHistoryModel({
    required this.id,
    required this.driverId,
    required this.busId,
    required this.routeId,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.totalStops,
  });

  factory TripHistoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TripHistoryModel(
      id: doc.id,
      driverId: data['driver_id'] ?? '',
      busId: data['bus_id'] ?? '',
      routeId: data['route_id'] ?? '',
      startTime: data['start_time'] != null ? (data['start_time'] as Timestamp).toDate() : DateTime.now(),
      endTime: data['end_time'] != null ? (data['end_time'] as Timestamp).toDate() : DateTime.now(),
      distanceKm: (data['distance_km'] ?? 0.0).toDouble(),
      totalStops: data['total_stops'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'bus_id': busId,
      'route_id': routeId,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': Timestamp.fromDate(endTime),
      'distance_km': distanceKm,
      'total_stops': totalStops,
    };
  }
}

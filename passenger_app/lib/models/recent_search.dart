import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearch {
  final String busId;
  final String routeId;
  final DateTime timestamp;

  RecentSearch({
    required this.busId,
    required this.routeId,
    required this.timestamp,
  });

  factory RecentSearch.fromMap(Map<String, dynamic> data) {
    return RecentSearch(
      busId: data['bus_id'] ?? '',
      routeId: data['route_id'] ?? '',
      timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bus_id': busId,
      'route_id': routeId,
      'timestamp': timestamp,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteBus {
  final String busId;
  final String source;
  final String destination;
  final DateTime addedAt;

  FavoriteBus({
    required this.busId,
    required this.source,
    required this.destination,
    required this.addedAt,
  });

  factory FavoriteBus.fromMap(Map<String, dynamic> data) {
    return FavoriteBus(
      busId: data['bus_id'] ?? '',
      source: data['source'] ?? '',
      destination: data['destination'] ?? '',
      addedAt: data['added_at'] != null ? (data['added_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bus_id': busId,
      'source': source,
      'destination': destination,
      'added_at': addedAt,
    };
  }
}

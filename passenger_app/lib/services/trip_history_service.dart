import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/trip_history_model.dart';

class TripHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTripHistory({
    required String driverId,
    required String busId,
    required String routeId,
    required DateTime startTime,
    required DateTime endTime,
    required double distanceKm,
    required int totalStops,
  }) async {
    try {
      final docRef = _firestore.collection('trips').doc();
      final trip = TripHistoryModel(
        id: docRef.id,
        driverId: driverId,
        busId: busId,
        routeId: routeId,
        startTime: startTime,
        endTime: endTime,
        distanceKm: distanceKm,
        totalStops: totalStops,
      );
      
      await docRef.set(trip.toMap());
    } catch (e) {
      debugPrint('Error saving trip history: $e');
      rethrow;
    }
  }
}

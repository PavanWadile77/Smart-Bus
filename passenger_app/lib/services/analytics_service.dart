import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final now = DateTime.now();

      final driversSnap = await _firestore.collection('drivers').where('is_online', isEqualTo: true).get();
      int activeDrivers = driversSnap.size;

      final delayedSnap = await _firestore.collection('live_buses').where('is_delayed', isEqualTo: true).get();
      int delayedBuses = delayedSnap.size;

      final startOfDay = DateTime(now.year, now.month, now.day);
      final sosSnap = await _firestore.collection('sos_alerts')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();
      int todaysSOS = sosSnap.size;

      final tripsSnap = await _firestore.collection('trips')
          .where('start_time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();
      int completedTrips = tripsSnap.size;

      return {
        'active_drivers': activeDrivers,
        'delayed_buses': delayedBuses,
        'todays_sos': todaysSOS,
        'completed_trips': completedTrips,
      };
    } catch (e) {
      debugPrint('Error fetching analytics: $e');
      return {
        'active_drivers': 0,
        'delayed_buses': 0,
        'todays_sos': 0,
        'completed_trips': 0,
      };
    }
  }
}

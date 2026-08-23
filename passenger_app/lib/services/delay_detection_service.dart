import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/timetable_model.dart';

class DelayDetectionService {
  /// Checks if current estimated arrival time is delayed relative to timetable.
  /// If delayed by more than [thresholdMinutes], updates Firestore delay status.
  static Future<void> checkDelayStatus({
    required String busId,
    required TimetableModel timetable,
    required int currentStopIndex,
    required int estimatedMinutesToNextStop,
  }) async {
    try {
      if (currentStopIndex >= timetable.stopTimes.length) return;
      
      String nextStopTimeStr = timetable.stopTimes[currentStopIndex];
      List<String> parts = nextStopTimeStr.split(':');
      if (parts.length != 2) return;
      
      int scheduledHour = int.parse(parts[0]);
      int scheduledMinute = int.parse(parts[1]);
      
      DateTime now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year, now.month, now.day, scheduledHour, scheduledMinute,
      );
      
      DateTime estimatedArrivalTime = now.add(Duration(minutes: estimatedMinutesToNextStop));
      int delayMinutes = estimatedArrivalTime.difference(scheduledTime).inMinutes;
      
      bool isDelayed = delayMinutes > 5;
      
      await FirebaseFirestore.instance.collection('live_buses').doc(busId).set({
        'is_delayed': isDelayed,
        'delay_minutes': delayMinutes > 0 ? delayMinutes : 0,
      }, SetOptions(merge: true));
      
    } catch (e) {
      debugPrint('Error in DelayDetectionService: $e');
    }
  }
}

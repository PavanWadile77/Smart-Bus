import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> clockIn(String driverId) async {
    try {
      final now = DateTime.now();
      final String dateStr = now.toIso8601String().split('T')[0];
      final docRef = _firestore
          .collection('driver_attendance')
          .doc(driverId)
          .collection('records')
          .doc(dateStr);

      final doc = await docRef.get();
      if (!doc.exists) {
        final attendance = AttendanceModel(
          id: dateStr,
          driverId: driverId,
          date: now,
          clockInTime: now,
          totalHours: 0.0,
        );
        await docRef.set(attendance.toMap());
      }
    } catch (e) {
      debugPrint('Error clocking in: $e');
      rethrow;
    }
  }

  Future<void> clockOut(String driverId) async {
    try {
      final now = DateTime.now();
      final String dateStr = now.toIso8601String().split('T')[0];
      final docRef = _firestore
          .collection('driver_attendance')
          .doc(driverId)
          .collection('records')
          .doc(dateStr);

      final doc = await docRef.get();
      if (doc.exists) {
        final data = AttendanceModel.fromFirestore(doc);
        final clockOutTime = now;
        final duration = clockOutTime.difference(data.clockInTime);
        final double totalHours = duration.inMinutes / 60.0;

        await docRef.update({
          'clock_out': Timestamp.fromDate(clockOutTime),
          'total_hours': totalHours,
        });
      }
    } catch (e) {
      debugPrint('Error clocking out: $e');
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String driverId;
  final DateTime date;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final double totalHours;

  AttendanceModel({
    required this.id,
    required this.driverId,
    required this.date,
    required this.clockInTime,
    this.clockOutTime,
    required this.totalHours,
  });

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      driverId: data['driver_id'] ?? '',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      clockInTime: data['clock_in'] != null ? (data['clock_in'] as Timestamp).toDate() : DateTime.now(),
      clockOutTime: data['clock_out'] != null ? (data['clock_out'] as Timestamp).toDate() : null,
      totalHours: (data['total_hours'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driver_id': driverId,
      'date': Timestamp.fromDate(date),
      'clock_in': Timestamp.fromDate(clockInTime),
      'clock_out': clockOutTime != null ? Timestamp.fromDate(clockOutTime!) : null,
      'total_hours': totalHours,
    };
  }
}

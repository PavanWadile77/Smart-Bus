import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/sos_model.dart';

class SOSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> triggerSOS({
    required String driverId,
    required String busId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final docRef = _firestore.collection('sos_alerts').doc();
      final sos = SOSModel(
        id: docRef.id,
        driverId: driverId,
        busId: busId,
        latitude: latitude,
        longitude: longitude,
        status: 'active',
        timestamp: DateTime.now(),
      );
      await docRef.set(sos.toMap());
    } catch (e) {
      debugPrint('Error triggering SOS: $e');
      rethrow;
    }
  }

  Future<void> resolveSOS(String sosId) async {
    try {
      await _firestore.collection('sos_alerts').doc(sosId).update({
        'status': 'resolved',
      });
    } catch (e) {
      debugPrint('Error resolving SOS: $e');
      rethrow;
    }
  }
}

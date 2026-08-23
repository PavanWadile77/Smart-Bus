import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/driver_model.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class DriverService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<DriverModel?> getDriverStream(String uid) {
    return _db.collection('drivers').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        try {
          return DriverModel.fromMap(doc.id, doc.data()!);
        } catch (e) {
          debugPrint('Data Parsing Error (getDriverStream): $e');
          return null;
        }
      }
      return null;
    }).handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getDriverStream): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getDriverStream): $error');
      }
    });
  }

  Future<void> updateDriverTrip(String uid, String busId, String routeId) async {
    try {
      await _db.collection('drivers').doc(uid).update({
        'assigned_bus': busId,
        'assigned_route': routeId,
      }).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (updateDriverTrip): ${e.code} - ${e.message}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (updateDriverTrip): Connection took too long.');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (updateDriverTrip): $e');
      rethrow;
    }
  }

  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    try {
      await _db.collection('drivers').doc(uid).update({
        'is_online': isOnline,
      }).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (updateOnlineStatus): ${e.code} - ${e.message}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (updateOnlineStatus): Connection took too long.');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (updateOnlineStatus): $e');
      rethrow;
    }
  }
}

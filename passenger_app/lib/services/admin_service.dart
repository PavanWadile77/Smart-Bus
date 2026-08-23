import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/driver_model.dart';
import '../models/timetable_model.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- Bus Management ---
  Stream<QuerySnapshot> getBuses() {
    return _db.collection('buses').snapshots().handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getBuses): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getBuses): $error');
      }
    });
  }

  Future<void> addBus(Map<String, dynamic> data) async {
    try {
      await _db.collection('buses').add(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (addBus): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (addBus)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (addBus): $e');
      rethrow;
    }
  }

  Future<void> updateBus(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('buses').doc(id).update(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (updateBus): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (updateBus)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (updateBus): $e');
      rethrow;
    }
  }

  Future<void> deleteBus(String id) async {
    try {
      await _db.collection('buses').doc(id).delete().timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (deleteBus): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (deleteBus)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (deleteBus): $e');
      rethrow;
    }
  }

  // --- Driver Management ---
  Stream<List<DriverModel>> getDrivers() {
    return _db.collection('drivers').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return DriverModel.fromMap(doc.id, doc.data());
          } catch (e) {
            debugPrint('Data Parsing Error (getDrivers): $e');
            return null;
          }
        }).where((item) => item != null).cast<DriverModel>().toList();
      }
    ).handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getDrivers): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getDrivers): $error');
      }
    });
  }

  Future<void> addDriver(Map<String, dynamic> data) async {
    try {
      await _db.collection('drivers').add(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (addDriver): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (addDriver)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (addDriver): $e');
      rethrow;
    }
  }

  Future<void> updateDriver(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('drivers').doc(id).update(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (updateDriver): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (updateDriver)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (updateDriver): $e');
      rethrow;
    }
  }

  Future<void> deleteDriver(String id) async {
    try {
      await _db.collection('drivers').doc(id).delete().timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (deleteDriver): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (deleteDriver)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (deleteDriver): $e');
      rethrow;
    }
  }

  // --- Route & Timetable Management ---
  Stream<List<TimetableModel>> getTimetables() {
    return _db.collection('timetable').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return TimetableModel.fromMap(doc.id, doc.data());
          } catch (e) {
            debugPrint('Data Parsing Error (getTimetables): $e');
            return null;
          }
        }).where((item) => item != null).cast<TimetableModel>().toList();
      }
    ).handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getTimetables): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getTimetables): $error');
      }
    });
  }

  Future<void> addTimetable(Map<String, dynamic> data) async {
    try {
      await _db.collection('timetable').add(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (addTimetable): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (addTimetable)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (addTimetable): $e');
      rethrow;
    }
  }

  Future<void> updateTimetable(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('timetable').doc(id).update(data).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (updateTimetable): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (updateTimetable)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (updateTimetable): $e');
      rethrow;
    }
  }

  Future<void> deleteTimetable(String id) async {
    try {
      await _db.collection('timetable').doc(id).delete().timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (deleteTimetable): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (deleteTimetable)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (deleteTimetable): $e');
      rethrow;
    }
  }

  // --- Live Fleet ---
  Stream<QuerySnapshot> getLiveBuses() {
    return _db.collection('live_buses').snapshots().handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getLiveBuses): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getLiveBuses): $error');
      }
    });
  }

  // --- Push Notifications ---
  Future<void> sendNotification(Map<String, dynamic> payload) async {
    try {
      payload['timestamp'] = FieldValue.serverTimestamp();
      await _db.collection('admin_notifications').add(payload).timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (sendNotification): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (sendNotification)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (sendNotification): $e');
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_model.dart';
import '../models/route_model.dart';

import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RouteModel>> getRoutes() {
    return _firestore.collection('routes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return RouteModel.fromMap(doc.id, doc.data());
        } catch (e) {
          debugPrint('Data Parsing Error (getRoutes): $e');
          return null;
        }
      }).where((item) => item != null).cast<RouteModel>().toList();
    }).handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getRoutes): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getRoutes): $error');
      }
    });
  }

  Stream<List<BusModel>> getBuses() {
    return _firestore.collection('buses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return BusModel.fromMap(doc.data());
        } catch (e) {
          debugPrint('Data Parsing Error (getBuses): $e');
          return null;
        }
      }).where((item) => item != null).cast<BusModel>().toList();
    }).handleError((error) {
      if (error is FirebaseException) {
        debugPrint('Firestore Stream Error (getBuses): ${error.code}');
      } else {
        debugPrint('Unknown Stream Error (getBuses): $error');
      }
    });
  }
}

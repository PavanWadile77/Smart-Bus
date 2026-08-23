import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/timetable_model.dart';

class TimetableProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<TimetableModel> timetable = [];
  bool isLoading = true;
  String errorMessage = "";
  StreamSubscription<QuerySnapshot>? _subscription;

  TimetableProvider() {
    _startListening();
  }

  void _startListening() {
    _subscription = _firestore.collection('timetable').snapshots().handleError((error) {
      if (error is FirebaseException) {
        errorMessage = "Network or Permission Error: ${error.code}";
      } else {
        errorMessage = "An unexpected error occurred.";
      }
      isLoading = false;
      notifyListeners();
    }).listen(
      (snapshot) {
        timetable = snapshot.docs.map((doc) {
          try {
            return TimetableModel.fromMap(doc.id, doc.data());
          } catch (e) {
            debugPrint('Data Parsing Error (_startListening): $e');
            return null;
          }
        }).where((item) => item != null).cast<TimetableModel>().toList();
        isLoading = false;
        errorMessage = "";
        notifyListeners();
      },
      onError: (error) {
        errorMessage = "Failed to load timetable: $error";
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

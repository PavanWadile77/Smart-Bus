import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusListProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Map<String, dynamic>> liveBuses = [];
  bool isLoading = true;
  String errorMessage = "";
  StreamSubscription<QuerySnapshot>? _busSubscription;
  Timer? _stalenessTimer;

  BusListProvider() {
    _startListening();
    // Periodically re-evaluate staleness so UI updates even if Firebase data doesn't change
    _stalenessTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      notifyListeners();
    });
  }

  void _startListening() {
    _busSubscription = _firestore.collection('buses').snapshots().listen(
      (snapshot) {
        liveBuses = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
        errorMessage = "";
        notifyListeners();
      },
      onError: (error) {
        errorMessage = "Database Offline";
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    _stalenessTimer?.cancel();
    super.dispose();
  }
}

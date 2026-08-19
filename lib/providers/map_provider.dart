import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';

class MapProvider extends ChangeNotifier {
  final String busId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MapController mapController = MapController();

  Map<String, dynamic>? busData;
  bool isStale = false;
  StreamSubscription<DocumentSnapshot>? _busSubscription;
  Timer? _stalenessTimer;

  MapProvider(this.busId) {
    _startListening();
    _stalenessTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkStaleness());
  }

  void _startListening() {
    _busSubscription = _firestore.collection('buses').doc(busId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          busData = snapshot.data() as Map<String, dynamic>;
          _checkStaleness();
        }
      },
    );
  }

  void _checkStaleness() {
    if (busData == null) return;
    
    // Firestore serverTimestamp might be null briefly, fallback to local now if so
    Timestamp? ts = busData!['timestamp'];
    if (ts == null) return;

    final lastUpdated = ts.toDate().toUtc();
    final now = DateTime.now().toUtc();
    isStale = now.difference(lastUpdated).inMinutes >= 2;
    notifyListeners();
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    _stalenessTimer?.cancel();
    super.dispose();
  }
}

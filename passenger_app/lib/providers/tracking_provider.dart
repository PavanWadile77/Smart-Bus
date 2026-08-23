import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> runningBuses = [];
  Map<String, dynamic>? selectedBus;
  Map<String, dynamic>? selectedRoute;
  List<Map<String, dynamic>> routeStops = [];

  StreamSubscription? _busesSubscription;
  StreamSubscription? _routeSubscription;
  StreamSubscription? _stopsSubscription;

  bool isStale = false;
  Timer? _stalenessTimer;

  TrackingProvider() {
    _initLiveBuses();
    _stalenessTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => _checkStaleness());
  }

  void _initLiveBuses() {
    _busesSubscription = _firestore.collection('buses').snapshots().handleError((error) {
      debugPrint('Firestore Stream Error (_initLiveBuses): $error');
    }).listen((snapshot) {
      runningBuses = snapshot.docs.map((d) {
        try {
          return {'id': d.id, ...d.data()};
        } catch (e) {
          debugPrint('Data Parsing Error (_initLiveBuses): $e');
          return {'id': d.id};
        }
      }).toList();

      // Update selected bus if we are tracking one
      if (selectedBus != null) {
        final updated = runningBuses
            .where((b) => (b['id'] ?? '').toString() == (selectedBus!['id'] ?? '').toString())
            .toList();
        if (updated.isNotEmpty) {
          selectedBus = updated.first;
          _checkStaleness();
        }
      }

      notifyListeners();
    });
  }

  void trackBus(String busId) {
    // Clear old state to prevent stale data and force loading state
    selectedRoute = null;
    routeStops = [];
    _routeSubscription?.cancel();
    _stopsSubscription?.cancel();

    selectedBus = runningBuses.firstWhere(
        (b) => (b['id'] ?? '').toString() == busId.toString(),
        orElse: () => {});
    if (selectedBus == null || selectedBus!.isEmpty) {
      notifyListeners();
      return;
    }

    final String? routeId = selectedBus!['route_id']?.toString();
    if (routeId != null) {
      _routeSubscription = _firestore
          .collection('routes')
          .doc(routeId)
          .snapshots()
          .handleError((error) {
        debugPrint('Firestore Stream Error (trackBus route): $error');
      }).listen((rDoc) {
        if (rDoc.exists && rDoc.data() != null) {
          try {
            selectedRoute = {'id': rDoc.id, ...rDoc.data()!};
            notifyListeners();
          } catch (e) {
            debugPrint('Data Parsing Error (trackBus route): $e');
          }
        }
      });

      _stopsSubscription = _firestore
          .collection('stops')
          .where('route_id', isEqualTo: routeId)
          .snapshots()
          .handleError((error) {
        debugPrint('Firestore Stream Error (trackBus stops): $error');
      }).listen((sDocs) {
        routeStops = sDocs.docs.map((d) {
          try {
            return {'id': d.id, ...d.data()};
          } catch (e) {
            debugPrint('Data Parsing Error (trackBus stops): $e');
            return {'id': d.id};
          }
        }).toList();
        
        try {
          routeStops.sort((a, b) => (a['sequence'] ?? 0).compareTo(b['sequence'] ?? 0));
        } catch (e) {
          debugPrint('Sorting Error (trackBus stops): $e');
        }
        notifyListeners();
      });
    }

    _checkStaleness();
    notifyListeners();
  }

  void _checkStaleness() {
    if (selectedBus == null) return;
    try {
      Timestamp? ts = selectedBus!['timestamp'];
      if (ts == null) return;

      final lastUpdated = ts.toDate().toUtc();
      final now = DateTime.now().toUtc();
      isStale = now.difference(lastUpdated).inSeconds > 45;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking staleness: $e');
    }
  }

  @override
  void dispose() {
    _busesSubscription?.cancel();
    _routeSubscription?.cancel();
    _stopsSubscription?.cancel();
    _stalenessTimer?.cancel();
    super.dispose();
  }
}

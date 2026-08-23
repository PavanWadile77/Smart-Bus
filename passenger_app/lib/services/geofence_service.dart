import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_stop.dart';

class GeoFenceService {
  static const double stopThresholdMeters = 50.0;

  /// Checks if the bus has reached the [nextStop].
  /// If it has, it updates the current_stop_index in Firestore.
  static Future<bool> checkArrival({
    required String busId,
    required double currentLat,
    required double currentLng,
    required BusStop nextStop,
    required int nextStopIndex,
  }) async {
    double distance = Geolocator.distanceBetween(
      currentLat,
      currentLng,
      nextStop.latitude,
      nextStop.longitude,
    );

    if (distance <= stopThresholdMeters) {
      await FirebaseFirestore.instance.collection('live_buses').doc(busId).set({
        'current_stop_index': nextStopIndex,
      }, SetOptions(merge: true));
      return true;
    }
    return false;
  }
}

import 'package:geolocator/geolocator.dart';

class ETAEngineService {
  /// Calculates ETA in minutes based on distance and average speed.
  static int calculateETA({
    required double currentLat,
    required double currentLng,
    required double destinationLat,
    required double destinationLng,
    required double currentSpeedKmH,
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLat,
      currentLng,
      destinationLat,
      destinationLng,
    );
    
    double distanceKm = distanceInMeters / 1000.0;
    double effectiveSpeed = currentSpeedKmH < 10.0 ? 30.0 : currentSpeedKmH;
    
    double hours = distanceKm / effectiveSpeed;
    return (hours * 60).ceil();
  }
}

import 'package:latlong2/latlong.dart';
import '../models/bus_stop.dart';

class RouteCalculator {
  // Mock Route (e.g., Pune Route)
  static const List<BusStop> routeStops = [
    BusStop(name: "Katraj", latitude: 18.4533, longitude: 73.8582, sequence: 1),
    BusStop(name: "Padmavati", latitude: 18.4735, longitude: 73.8576, sequence: 2),
    BusStop(name: "Swargate", latitude: 18.5018, longitude: 73.8584, sequence: 3),
    BusStop(name: "Sarasbaug", latitude: 18.5034, longitude: 73.8538, sequence: 4),
    BusStop(name: "Pune Station", latitude: 18.5284, longitude: 73.8739, sequence: 5),
    BusStop(name: "Shivajinagar", latitude: 18.5314, longitude: 73.8446, sequence: 6),
    BusStop(name: "Sangamwadi", latitude: 18.5414, longitude: 73.8646, sequence: 7),
  ];

  static const Distance _distance = Distance();

  static Map<String, dynamic> calculateCurrentStatus(double busLat, double busLng) {
    if (busLat == 0.0 && busLng == 0.0) {
      return {
        'current_stop': routeStops.first,
        'next_stop': routeStops[1],
        'distance_left_km': 0.0,
        'passed_stops': <BusStop>[],
        'upcoming_stops': routeStops,
      };
    }

    // Find the nearest stop
    BusStop nearestStop = routeStops.first;
    double minDistance = double.infinity;

    for (var stop in routeStops) {
      final double dist = _distance(
        LatLng(busLat, busLng),
        LatLng(stop.latitude, stop.longitude),
      );
      if (dist < minDistance) {
        minDistance = dist;
        nearestStop = stop;
      }
    }

    // Calculate progress
    final int currentIndex = routeStops.indexOf(nearestStop);
    
    // Assume bus is moving forward. Next stop is the one after the nearest stop.
    // If the bus is very close to the nearest stop (e.g. < 500m), it's "At" the stop.
    // We will just use nearestStop as current, and nearestStop + 1 as next.
    BusStop nextStop = currentIndex < routeStops.length - 1 
        ? routeStops[currentIndex + 1] 
        : nearestStop;

    // Calculate distance to next stop
    final double distToNext = _distance(
        LatLng(busLat, busLng),
        LatLng(nextStop.latitude, nextStop.longitude),
    ) / 1000.0; // km

    final passedStops = routeStops.sublist(0, currentIndex);
    final upcomingStops = routeStops.sublist(currentIndex);

    return {
      'current_stop': nearestStop,
      'next_stop': nextStop,
      'distance_left_km': distToNext,
      'passed_stops': passedStops,
      'upcoming_stops': upcomingStops,
    };
  }
}

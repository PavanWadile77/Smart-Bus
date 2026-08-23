class RouteModel {
  final String routeId;
  final String routeName;
  final String startStop;
  final String endStop;
  final String busType;
  final String busId;
  final int distance;

  RouteModel({
    required this.routeId,
    required this.routeName,
    required this.startStop,
    required this.endStop,
    required this.busType,
    required this.busId,
    required this.distance,
  });

  factory RouteModel.fromMap(String id, Map<String, dynamic> map) {
    return RouteModel(
      routeId: id,
      routeName: map['route_name'] ?? '',
      startStop: map['start_stop'] ?? '',
      endStop: map['end_stop'] ?? '',
      busType: map['bus_type'] ?? '',
      busId: map['bus_id'] ?? '',
      distance: map['distance_km'] ?? 0,
    );
  }
}

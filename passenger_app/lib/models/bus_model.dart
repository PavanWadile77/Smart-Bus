class BusModel {
  final String busId;
  final String routeId;
  final String currentStop;
  final String nextStop;
  final double latitude;
  final double longitude;
  final double speed;
  final String status;
  final int eta;

  BusModel({
    required this.busId,
    required this.routeId,
    required this.currentStop,
    required this.nextStop,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.status,
    required this.eta,
  });

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      busId: map['bus_id'] ?? '',
      routeId: map['route_id'] ?? '',
      currentStop: map['current_stop'] ?? '',
      nextStop: map['next_stop'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      speed: (map['speed'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      eta: map['eta_next_stop'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bus_id': busId,
      'route_id': routeId,
      'current_stop': currentStop,
      'next_stop': nextStop,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'status': status,
      'eta_next_stop': eta,
    };
  }
}

class ScheduleModel {
  final String busId;
  final String routeId;
  final String departure;
  final String arrival;
  final String busType;

  ScheduleModel({
    required this.busId,
    required this.routeId,
    required this.departure,
    required this.arrival,
    required this.busType,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      busId: map['bus_id'] ?? '',
      routeId: map['route_id'] ?? '',
      departure: map['departure'] ?? '',
      arrival: map['arrival'] ?? '',
      busType: map['bus_type'] ?? '',
    );
  }
}

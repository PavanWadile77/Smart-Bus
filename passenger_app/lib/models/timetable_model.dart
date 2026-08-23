class TimetableModel {
  final String id;
  final String busId;
  final String routeId;
  final String busNumber;
  final String busName;
  final String source;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final List<String> stops;
  final List<String> stopTimes;
  final String via;
  final String busType;

  TimetableModel({
    required this.id,
    required this.busId,
    required this.routeId,
    required this.busNumber,
    required this.busName,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.stopTimes,
    required this.via,
    required this.busType,
  });

  factory TimetableModel.fromMap(String id, Map<String, dynamic> map) {
    return TimetableModel(
      id: id,
      busId: map['bus_id']?.toString() ?? '',
      routeId: map['route_id']?.toString() ?? '',
      busNumber: map['bus_number']?.toString() ?? '',
      busName: map['bus_name']?.toString() ?? '',
      source: map['source']?.toString() ?? '',
      destination: map['destination']?.toString() ?? '',
      departureTime: map['departure_time']?.toString() ?? '',
      arrivalTime: map['arrival_time']?.toString() ?? '',
      stops: (map['stops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      stopTimes: (map['stop_times'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      via: map['via']?.toString() ?? '',
      busType: map['bus_type']?.toString() ?? '',
    );
  }
}

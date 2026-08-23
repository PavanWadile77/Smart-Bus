class StopModel {
  final String name;
  final String routeId;
  final int sequence;

  StopModel({
    required this.name,
    required this.routeId,
    required this.sequence,
  });

  factory StopModel.fromMap(Map<String, dynamic> map) {
    return StopModel(
      name: map['name'] ?? '',
      routeId: map['route_id'] ?? '',
      sequence: map['sequence'] ?? 0,
    );
  }
}

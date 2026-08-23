class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String assignedBus;
  final String assignedRoute;
  final bool isOnline;
  final bool isEnabled;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.assignedBus,
    required this.assignedRoute,
    this.isOnline = false,
    this.isEnabled = true,
  });

  factory DriverModel.fromMap(String id, Map<String, dynamic> data) {
    return DriverModel(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      assignedBus: data['assigned_bus'] ?? '',
      assignedRoute: data['assigned_route'] ?? '',
      isOnline: data['is_online'] ?? false,
      isEnabled: data['is_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'assigned_bus': assignedBus,
      'assigned_route': assignedRoute,
      'is_online': isOnline,
      'is_enabled': isEnabled,
    };
  }
}

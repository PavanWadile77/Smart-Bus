void main() {
  Map<String, dynamic> bus = {
    'bus_id': 101,
    'eta_next_stop': 15,
    'current_stop': 'Pune',
    'next_stop': 'Mumbai'
  };

  try {
    final String busId = (bus['bus_id'] ?? bus['id'] ?? 'Unknown').toString();
    final String currentStop = (bus['current_stop'] ?? '--').toString();
    final String nextStop = (bus['next_stop'] ?? '--').toString();
    final String eta = (bus['eta_next_stop'] ?? '--').toString();
    
    print('busId: $busId');
    print('eta: $eta');
    print('SUCCESS');
  } catch (e, stacktrace) {
    print('Error: $e');
    print(stacktrace);
  }
}

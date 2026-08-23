import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class FleetMonitorScreen extends StatelessWidget {
  const FleetMonitorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Fleet Monitor')),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.liveBuses.isEmpty) return const Center(child: Text("No live buses at the moment."));
          return ListView.builder(
            itemCount: provider.liveBuses.length,
            itemBuilder: (context, index) {
              final liveBus = provider.liveBuses[index];
              final data = liveBus.data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.directions_bus, color: Colors.green),
                title: Text("Bus: ${liveBus.id}"),
                subtitle: Text("Speed: ${data['speed']?.toStringAsFixed(1) ?? '0'} km/h"),
              );
            },
          );
        },
      ),
    );
  }
}

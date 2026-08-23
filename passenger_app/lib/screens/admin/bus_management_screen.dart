import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class BusManagementScreen extends StatelessWidget {
  const BusManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Management')),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.buses.isEmpty) return const Center(child: Text("No buses found."));
          return ListView.builder(
            itemCount: provider.buses.length,
            itemBuilder: (context, index) {
              final bus = provider.buses[index];
              final data = bus.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['bus_number'] ?? 'Unknown Bus'),
                subtitle: Text("Type: ${data['bus_type'] ?? 'Standard'}"),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => provider.deleteBus(bus.id)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<AdminProvider>(context, listen: false).addBus({
            'bus_number': 'NEW-BUS-${DateTime.now().second}',
            'bus_type': 'Standard',
          });
        },
      ),
    );
  }
}

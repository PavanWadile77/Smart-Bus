import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class DriverManagementScreen extends StatelessWidget {
  const DriverManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Management')),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.drivers.isEmpty) return const Center(child: Text("No drivers found."));
          return ListView.builder(
            itemCount: provider.drivers.length,
            itemBuilder: (context, index) {
              final driver = provider.drivers[index];
              return ListTile(
                title: Text(driver.name),
                subtitle: Text("Phone: ${driver.phone}\nStatus: ${driver.isOnline ? 'Online' : 'Offline'}"),
                isThreeLine: true,
                trailing: Switch(
                  value: driver.isOnline,
                  onChanged: (val) {
                    provider.updateDriver(driver.id, {'is_online': val});
                  },
                ),
                onLongPress: () => provider.deleteDriver(driver.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<AdminProvider>(context, listen: false).addDriver({
            'name': 'New Driver ${DateTime.now().second}',
            'phone': '1234567890',
            'assigned_bus': '',
            'assigned_route': '',
            'is_online': false,
          });
        },
      ),
    );
  }
}

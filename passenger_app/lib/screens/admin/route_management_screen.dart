import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class RouteManagementScreen extends StatelessWidget {
  const RouteManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Management')),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.timetables.isEmpty) return const Center(child: Text("No routes found."));
          return ListView.builder(
            itemCount: provider.timetables.length,
            itemBuilder: (context, index) {
              final route = provider.timetables[index];
              return ListTile(
                title: Text("Route: ${route.id}"),
                subtitle: Text("Stops: ${route.stops.length}"),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => provider.deleteTimetable(route.id)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<AdminProvider>(context, listen: false).addTimetable({
            'stops': [
              {'name': 'Stop A', 'arrival_time': '10:00'},
              {'name': 'Stop B', 'arrival_time': '10:30'}
            ]
          });
        },
      ),
    );
  }
}

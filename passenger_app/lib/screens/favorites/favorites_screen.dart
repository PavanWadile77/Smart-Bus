import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Saved Routes",
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.route, color: AppColors.primary),
              title: const Text("Swargate → Dadar"),
              trailing: const Icon(Icons.favorite, color: AppColors.error),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Saved Stops",
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.directions_bus, color: AppColors.primary),
              title: const Text("Shivajinagar Station"),
              trailing: const Icon(Icons.favorite, color: AppColors.error),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Saved Buses",
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.directions_bus, color: AppColors.primary),
              title: const Text("MH12-9999"),
              subtitle: const Text("Currently LIVE"),
              trailing: const Icon(Icons.favorite, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

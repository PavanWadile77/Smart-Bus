import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/bus_provider.dart';
import '../../providers/map_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/route_calculator.dart';
import '../../widgets/animated_status_badge.dart';
import 'bus_details_screen.dart';

class BusListScreen extends StatelessWidget {
  const BusListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Buses', style: TextStyle(color: AppColors.primary)),
      ),
      body: Consumer<BusListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }
          if (provider.liveBuses.isEmpty) {
            return const Center(child: Text("No live buses available."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: provider.liveBuses.length,
            itemBuilder: (context, index) {
              final bus = provider.liveBuses[index];
              final lat = bus['latitude'] ?? 0.0;
              final lng = bus['longitude'] ?? 0.0;
              final speed = bus['speed'] ?? 0.0;
              final Timestamp? ts = bus['timestamp'];
              final isStale = DateTime.now().toUtc().difference(ts?.toDate().toUtc() ?? DateTime.now().toUtc()).inMinutes >= 2;
              
              // Calculate dynamic stops
              final status = RouteCalculator.calculateCurrentStatus(lat, lng);

              return _TransitBusCard(
                busId: bus['bus_id'] ?? 'Unknown',
                route: "Pune Central",
                currentStop: status['current_stop'].name,
                nextStop: status['next_stop'].name,
                distance: status['distance_left_km'],
                speed: speed,
                isStale: isStale,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => MapProvider(bus['bus_id']),
                        child: const BusDetailsScreen(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _TransitBusCard extends StatelessWidget {
  final String busId;
  final String route;
  final String currentStop;
  final String nextStop;
  final double distance;
  final double speed;
  final bool isStale;
  final VoidCallback onTap;

  const _TransitBusCard({
    Key? key,
    required this.busId,
    required this.route,
    required this.currentStop,
    required this.nextStop,
    required this.distance,
    required this.speed,
    required this.isStale,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_bus, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(busId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                      ],
                    ),
                    AnimatedStatusBadge(
                      text: isStale ? "DELAYED" : "LIVE",
                      color: isStale ? AppColors.warning : AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Route: $route", style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Current Stop", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text(currentStop, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Next Stop", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text(nextStop, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text("ETA: ${(distance / (speed > 0 ? speed : 20) * 60).toInt()} min", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

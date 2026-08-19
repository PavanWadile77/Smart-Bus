import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/map_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/route_calculator.dart';
import '../../widgets/bus_status_card.dart';
import '../../widgets/bus_timeline.dart';
import '../../widgets/route_progress.dart';
import '../../widgets/gradient_button.dart';
import 'bus_tracking_screen.dart';

class BusDetailsScreen extends StatelessWidget {
  const BusDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Bus Details', style: TextStyle(color: AppColors.primary)),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) {
          if (provider.busData == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }

          final lat = provider.busData!['latitude'] ?? 0.0;
          final lng = provider.busData!['longitude'] ?? 0.0;
          final speed = provider.busData!['speed'] ?? 0.0;
          final Timestamp? ts = provider.busData!['timestamp'];
          final lastUpdated = ts?.toDate().toLocal() ?? DateTime.now();

          // Calculate stops based on coordinates
          final status = RouteCalculator.calculateCurrentStatus(lat, lng);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Card (Status Grid)
                BusStatusCard(
                  busId: provider.busId,
                  currentStop: status['current_stop'],
                  nextStop: status['next_stop'],
                  distanceLeft: status['distance_left_km'],
                  speed: speed,
                  lastUpdated: lastUpdated,
                  isStale: provider.isStale,
                ),
                const SizedBox(height: 24),

                // Horizontal Route Progress
                const Text("Route Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                RouteProgressWidget(
                  passedStops: status['passed_stops'],
                  upcomingStops: status['upcoming_stops'],
                ),
                const SizedBox(height: 24),

                // Vertical Timeline
                BusTimeline(
                  passedStops: status['passed_stops'],
                  upcomingStops: status['upcoming_stops'],
                ),
                const SizedBox(height: 32),

                // Optional Map Button
                GradientButton(
                  text: "View Live Map",
                  onPressed: () {
                    // Navigate to map without recreating provider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: provider,
                          child: const BusTrackingScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

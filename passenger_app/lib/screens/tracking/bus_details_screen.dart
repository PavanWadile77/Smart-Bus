import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/map_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/route_calculator.dart';
import '../../models/bus_stop.dart';
import 'bus_tracking_screen.dart';

// Extracted UI Widgets
import '../../widgets/details/bus_header_card.dart';
import '../../widgets/details/eta_card.dart';
import '../../widgets/details/trip_information_card.dart';
import '../../widgets/details/route_card.dart';

import '../../providers/recent_search_provider.dart';
import '../../providers/favorite_provider.dart';

class BusDetailsScreen extends StatefulWidget {
  const BusDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MapProvider>(context, listen: false);
      if (provider.busId.isNotEmpty) {
        final routeId = provider.busData?['route_id']?.toString() ?? 'Unknown';
        Provider.of<RecentSearchProvider>(context, listen: false).addSearch(provider.busId, routeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 32, height: 32),
            const SizedBox(width: 12),
            const Text('Live Bus Details', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          Consumer2<MapProvider, FavoriteProvider>(
            builder: (context, mapProvider, favoriteProvider, child) {
              if (mapProvider.busId.isEmpty) return const SizedBox.shrink();
              final isFav = favoriteProvider.isFavorite(mapProvider.busId);
              return IconButton(
                icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : AppColors.primary),
                onPressed: () {
                  final source = mapProvider.busData?['source']?.toString() ?? 'Unknown';
                  final destination = mapProvider.busData?['destination']?.toString() ?? 'Unknown';
                  favoriteProvider.toggleFavorite(mapProvider.busId, source, destination);
                },
              );
            },
          ),
        ],
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
          
          final String? routeId = provider.busData!['route_id']?.toString();
          
          // Calculate stops based on coordinates
          final status = RouteCalculator.calculateCurrentStatus(lat, lng);
          
          final BusStop currentStop = status['current_stop'];
          final BusStop nextStop = status['next_stop'];
          final double distanceLeft = status['distance_left_km'];
          
          final int calculatedEta = (distanceLeft / (speed > 0 ? speed : 20) * 60).toInt();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BusHeaderCard(
                  busId: provider.busId,
                  speed: speed,
                  lastUpdated: lastUpdated,
                  isStale: provider.isStale,
                ),
                const SizedBox(height: 24),

                EtaCard(
                  eta: calculatedEta,
                  distanceLeft: distanceLeft,
                ),
                const SizedBox(height: 24),

                RouteCard(
                  passedStops: status['passed_stops'],
                  upcomingStops: status['upcoming_stops'],
                ),
                const SizedBox(height: 24),

                TripInformationCard(
                  currentStop: currentStop.name,
                  nextStop: nextStop.name,
                  speed: speed,
                  distanceLeft: distanceLeft,
                  status: provider.isStale ? "Delayed" : "Live",
                  routeId: routeId,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () {
                    // Existing navigation logic unchanged
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0), // Blue primary color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF1565C0).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Track Live Bus",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
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


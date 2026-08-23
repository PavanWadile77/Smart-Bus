import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tracking_provider.dart';
import '../../providers/timetable_provider.dart';
import '../../utils/app_colors.dart';
import 'search_screen.dart';
import '../tracking/bus_details_screen.dart';

// Extracted UI Widgets
import '../../widgets/home/dashboard_header.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/home/live_bus_card.dart';
import '../../widgets/home/popular_routes_card.dart';
import '../../widgets/home/recent_searches_card.dart';
import '../../widgets/home/feature_card.dart';
import '../../widgets/home/favorite_buses_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              onSearchTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
              }
            ),
            const SizedBox(height: 32),
            QuickActions(
              onSearch: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
              },
              onLiveTrack: () {},
              onTimetable: () {},
              onNearestStop: () {},
            ),
            const SizedBox(height: 32),
            _buildLiveBusSection(),
            const SizedBox(height: 32),
            Consumer<TimetableProvider>(
              builder: (context, provider, child) {
                return PopularRoutesCard(timetable: provider.timetable);
              },
            ),
            const SizedBox(height: 16),
            const FavoriteBusesCard(),
            const SizedBox(height: 16),
            const RecentSearchesCard(),
            const FeatureCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveBusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Buses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<TrackingProvider>(
            builder: (context, provider, child) {
              if (provider.runningBuses.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      "No live buses at the moment.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }

              return Column(
                children: provider.runningBuses.map((bus) {
                  final String busId = (bus['bus_id'] ?? bus['id'] ?? 'Unknown').toString();
                  final String currentStop = (bus['current_stop'] ?? '--').toString();
                  final String nextStop = (bus['next_stop'] ?? '--').toString();
                  final String eta = (bus['eta_next_stop'] ?? '--').toString();

                  return LiveBusCard(
                    busId: busId,
                    currentStop: currentStop,
                    nextStop: nextStop,
                    eta: eta,
                    onTrack: () {
                      provider.trackBus((bus['id'] ?? '').toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BusDetailsScreen())
                      );
                    }
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}


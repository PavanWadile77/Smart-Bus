import 'package:flutter/material.dart';
import 'live_status_card.dart';
import 'journey_card.dart';
import 'statistics_card.dart';
import '../../screens/tracking/bus_details_screen.dart';

class BottomSheetContent extends StatelessWidget {
  final Map<String, dynamic> busData;
  final ScrollController scrollController;

  const BottomSheetContent({
    Key? key, 
    required this.busData,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busId = (busData['bus_id'] ?? busData['id']).toString();
    final routeId = (busData['route_id'] ?? '--').toString();
    final eta = (busData['eta_next_stop'] ?? '--').toString();
    final speed = "${(busData['speed'] ?? '0')} km/h";
    final currentStop = (busData['current_stop'] ?? '--').toString();
    final nextStop = (busData['next_stop'] ?? '--').toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              LiveStatusCard(
                busId: busId,
                routeId: routeId,
                status: "ON TIME",
                lastUpdated: "Just now",
              ),
              const SizedBox(height: 30),
              JourneyCard(
                currentStop: currentStop,
                nextStop: nextStop,
              ),
              const SizedBox(height: 24),
              StatisticsCard(
                eta: eta,
                speed: speed,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BusDetailsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Track Full Route', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

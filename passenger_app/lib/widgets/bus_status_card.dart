import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/app_colors.dart';
import 'animated_status_badge.dart';

class BusStatusCard extends StatelessWidget {
  final String busId;
  final BusStop currentStop;
  final BusStop nextStop;
  final double distanceLeft;
  final double speed;
  final DateTime lastUpdated;
  final bool isStale;

  const BusStatusCard({
    Key? key,
    required this.busId,
    required this.currentStop,
    required this.nextStop,
    required this.distanceLeft,
    required this.speed,
    required this.lastUpdated,
    required this.isStale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section: Bus Number & Live Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busId,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last Updated: ${lastUpdated.toString().substring(11, 16)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedStatusBadge(
                  text: isStale ? "DELAYED" : "LIVE",
                  color: isStale ? AppColors.warning : AppColors.success,
                ),
              ],
            ),
          ),

          // Unavailable fields hidden: Route, Departure, Arrival, Bus Type
          // (Not available in existing variables)

          // Middle Section: Stops & Timeline
          Container(
            color: Colors.blue.shade50.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Timeline Graphic
                Column(
                  children: [
                    const Icon(Icons.my_location, size: 20, color: AppColors.primary),
                    Container(
                      height: 30,
                      width: 2,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const Icon(Icons.location_on, size: 20, color: AppColors.secondary),
                  ],
                ),
                const SizedBox(width: 16),
                // Stops Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStopInfo("Current Stop", currentStop.name),
                      const SizedBox(height: 18),
                      _buildStopInfo("Next Stop", nextStop.name, isNext: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Status Grid (ETA, Speed, Distance)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _buildStatItem(Icons.schedule, "ETA", "${(distanceLeft / (speed > 0 ? speed : 20) * 60).toInt()} min")),
                Expanded(child: _buildStatItem(Icons.speed, "Speed", "${speed.toStringAsFixed(0)} km/h")),
                Expanded(child: _buildStatItem(Icons.route, "Distance", "${distanceLeft.toStringAsFixed(1)} km")),
              ],
            ),
          ),

          // Bottom Button Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ElevatedButton(
              onPressed: () {
                // Button requested by UI design. 
                // Navigation logic is currently handled outside this widget.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Track Live Bus",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopInfo(String label, String stopName, {bool isNext = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stopName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isNext ? AppColors.secondary : AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary.withOpacity(0.7), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}


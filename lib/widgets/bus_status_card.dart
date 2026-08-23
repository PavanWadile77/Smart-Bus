import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bus", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  Text(busId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary)),
                ],
              ),
              AnimatedStatusBadge(
                text: isStale ? "DELAYED" : "LIVE",
                color: isStale ? AppColors.warning : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Current & Next Stop
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Current Stop", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(currentStop.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Next Stop", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(nextStop.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Detailed Status Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.timer_outlined, "ETA", "${(distanceLeft / (speed > 0 ? speed : 20) * 60).toInt()} min"),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.speed, "Speed", "${speed.toStringAsFixed(0)} km/h"),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.person_outline, "Driver", "Active (Ramesh)"),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.route, "Distance", "${distanceLeft.toStringAsFixed(1)} km"),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.update, "Updated", lastUpdated.toString().substring(11, 16)),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.gps_fixed, "GPS", "High Accuracy"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}

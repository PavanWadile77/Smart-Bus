import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class LiveStatusCard extends StatelessWidget {
  final String busId;
  final String routeId;
  final String status;
  final String lastUpdated;

  const LiveStatusCard({
    Key? key,
    required this.busId,
    required this.routeId,
    required this.status,
    required this.lastUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDelayed = status.toUpperCase() == "DELAYED";
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.directions_bus, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      busId,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Route: $routeId",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDelayed ? Colors.orange.shade100 : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status, style: TextStyle(color: isDelayed ? Colors.orange.shade800 : AppColors.success, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.update, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text("Last Updated: $lastUpdated", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

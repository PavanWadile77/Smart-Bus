import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';

class LiveBusCard extends StatelessWidget {
  final String busId;
  final String currentStop;
  final String nextStop;
  final String eta;
  final VoidCallback onTrack;

  const LiveBusCard({
    Key? key,
    required this.busId,
    required this.currentStop,
    required this.nextStop,
    required this.eta,
    required this.onTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.directions_bus, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(busId, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
                Row(
                  children: [
                    Consumer<FavoriteProvider>(
                      builder: (context, favoriteProvider, child) {
                        final isFav = favoriteProvider.isFavorite(busId);
                        return GestureDetector(
                          onTap: () {
                            favoriteProvider.toggleFavorite(busId, currentStop, nextStop);
                          },
                          child: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : AppColors.primary),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text("LIVE", style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.my_location, color: Colors.grey, size: 16),
                    Container(width: 2, height: 24, color: Colors.grey.shade300),
                    const Icon(Icons.location_on, color: AppColors.primary, size: 16),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentStop, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 16),
                      Text(nextStop, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("ETA", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(eta, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.success)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onTrack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Track Bus', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

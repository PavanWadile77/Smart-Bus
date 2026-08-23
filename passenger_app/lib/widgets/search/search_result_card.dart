import 'package:flutter/material.dart';
import '../../models/timetable_model.dart';
import '../../utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import 'bus_type_badge.dart';
import 'time_row.dart';
import 'route_chip.dart';

class SearchResultCard extends StatelessWidget {
  final TimetableModel bus;
  final VoidCallback onTap;

  const SearchResultCard({Key? key, required this.bus, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> displayStops = [];
    int extraStops = 0;
    
    if (bus.stops.isNotEmpty) {
      if (bus.stops.length > 3) {
        displayStops = bus.stops.take(3).toList();
        extraStops = bus.stops.length - 3;
      } else {
        displayStops = bus.stops;
      }
    } else if (bus.via.isNotEmpty) {
      final viaList = bus.via.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (viaList.length > 3) {
        displayStops = viaList.take(3).toList();
        extraStops = viaList.length - 3;
      } else {
        displayStops = viaList;
      }
    }

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bus.busName.isNotEmpty ? bus.busName : bus.busNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(bus.busNumber, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  BusTypeBadge(
                    busType: bus.busType.isNotEmpty ? bus.busType : 'Standard',
                    isLive: false,
                  ),
                  const SizedBox(width: 8),
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFav = favoriteProvider.isFavorite(bus.busId);
                      return GestureDetector(
                        onTap: () {
                          favoriteProvider.toggleFavorite(bus.busId, bus.source, bus.destination);
                        },
                        child: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : AppColors.primary),
                      );
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              TimeRow(
                source: bus.source,
                destination: bus.destination,
                departureTime: bus.departureTime.isNotEmpty ? bus.departureTime : '--:--',
                arrivalTime: bus.arrivalTime.isNotEmpty ? bus.arrivalTime : '--:--',
              ),
              if (displayStops.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text("Via", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  children: [
                    ...displayStops.map((stop) => RouteChip(text: stop)).toList(),
                    if (extraStops > 0)
                      RouteChip(text: "+$extraStops more"),
                  ],
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Route: ${bus.routeId}", style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

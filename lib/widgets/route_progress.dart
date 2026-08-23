import 'package:flutter/material.dart';
import '../../models/bus_stop.dart';
import '../../utils/app_colors.dart';

class RouteProgressWidget extends StatelessWidget {
  final List<BusStop> passedStops;
  final List<BusStop> upcomingStops;

  const RouteProgressWidget({
    Key? key,
    required this.passedStops,
    required this.upcomingStops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allStops = [...passedStops, ...upcomingStops];

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allStops.length,
        itemBuilder: (context, index) {
          final stop = allStops[index];
          final bool isPassed = index < passedStops.length;
          final bool isCurrent = index == passedStops.length;
          final bool isLast = index == allStops.length - 1;

          final Color color = isPassed ? AppColors.success : (isCurrent ? AppColors.secondary : Colors.grey.shade300);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCurrent ? Icons.directions_bus : Icons.circle,
                    color: color,
                    size: isCurrent ? 24 : 16,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stop.name,
                    style: TextStyle(
                      color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Container(
                  width: 40,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
                  color: isPassed || isCurrent ? AppColors.success : Colors.grey.shade300,
                ),
            ],
          );
        },
      ),
    );
  }
}

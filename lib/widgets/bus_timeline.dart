import 'package:flutter/material.dart';
import '../../models/bus_stop.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class BusTimeline extends StatelessWidget {
  final List<BusStop> passedStops;
  final List<BusStop> upcomingStops;

  const BusTimeline({
    Key? key,
    required this.passedStops,
    required this.upcomingStops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allStops = [...passedStops, ...upcomingStops];

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Route Timeline",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          ...allStops.asMap().entries.map((entry) {
            final int index = entry.key;
            final BusStop stop = entry.value;
            final bool isPassed = index < passedStops.length;
            final bool isCurrent = index == passedStops.length;
            final bool isLast = index == allStops.length - 1;

            return _buildTimelineItem(stop, isPassed, isCurrent, isLast, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BusStop stop, bool isPassed, bool isCurrent, bool isLast, int index) {
    final Color iconColor = isPassed ? AppColors.success : (isCurrent ? AppColors.secondary : Colors.grey.shade400);

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              // Icon
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCurrent ? iconColor.withAlpha(30) : (isPassed ? iconColor : Colors.transparent),
                  shape: BoxShape.circle,
                  border: isPassed ? null : Border.all(color: iconColor, width: 2),
                ),
                child: isPassed
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : (isCurrent
                        ? const Center(child: Icon(Icons.directions_bus, size: 14, color: AppColors.secondary))
                        : null),
              ),
              // Line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isPassed || isCurrent ? AppColors.success : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: isPassed ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPassed ? "Completed" : (isCurrent ? "Arriving shortly..." : "ETA ${index * 8} min"),
                    style: TextStyle(
                      fontSize: 13,
                      color: isCurrent ? AppColors.secondary : AppColors.textSecondary,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

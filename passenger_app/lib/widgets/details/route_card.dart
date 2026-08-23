import 'package:flutter/material.dart';
import '../../models/bus_stop.dart';
import '../bus_timeline.dart';

class RouteCard extends StatelessWidget {
  final List<BusStop> passedStops;
  final List<BusStop> upcomingStops;

  const RouteCard({
    Key? key,
    required this.passedStops,
    required this.upcomingStops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: BusTimeline(
        passedStops: passedStops,
        upcomingStops: upcomingStops,
      ),
    );
  }
}

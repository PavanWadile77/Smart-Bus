import 'package:flutter/material.dart';

class TripInformationCard extends StatelessWidget {
  final double speed;
  final String currentStop;
  final String nextStop;
  final double distanceLeft;
  final String status;
  final String? routeId;

  const TripInformationCard({
    Key? key,
    required this.speed,
    required this.currentStop,
    required this.nextStop,
    required this.distanceLeft,
    required this.status,
    this.routeId,
  }) : super(key: key);

  Widget _buildGridItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Trip Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.speed, "Speed", "${speed.toStringAsFixed(1)} km/h")),
              Expanded(child: _buildGridItem(Icons.my_location, "Current", currentStop)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.location_on, "Next", nextStop)),
              Expanded(child: _buildGridItem(Icons.route, "Distance Left", "${distanceLeft.toStringAsFixed(1)} km")),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.info_outline, "Status", status)),
              if (routeId != null)
                Expanded(child: _buildGridItem(Icons.alt_route, "Route ID", routeId!))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

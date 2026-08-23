import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../utils/app_colors.dart';

class MapActionButtons extends StatelessWidget {
  final MapController mapController;
  final LatLng mapCenter;
  final bool hasBusLocation;

  const MapActionButtons({
    Key? key,
    required this.mapController,
    required this.mapCenter,
    required this.hasBusLocation,
  }) : super(key: key);

  Widget _buildFab(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).padding.top + 96,
      child: Column(
        children: [
          _buildFab(Icons.my_location, () {}),
          const SizedBox(height: 16),
          _buildFab(Icons.directions_bus, () {
            if (hasBusLocation) {
              mapController.move(mapCenter, 16.0);
            }
          }),
          const SizedBox(height: 16),
          _buildFab(Icons.explore, () {}),
          const SizedBox(height: 16),
          _buildFab(Icons.traffic, () {}),
        ],
      ),
    );
  }
}

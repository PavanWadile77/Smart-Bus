import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/map_provider.dart';
import '../../utils/app_colors.dart';
import 'dart:math' as math;

class BusTrackingScreen extends StatelessWidget {
  const BusTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) {
          if (provider.busData == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }

          final lat = provider.busData!['latitude'] ?? 0.0;
          final lng = provider.busData!['longitude'] ?? 0.0;
          final bearing = provider.busData!['bearing'] ?? 0.0;

          return FlutterMap(
            mapController: provider.mapController,
            options: MapOptions(
              initialCenter: LatLng(lat, lng),
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smartbus',
              ),
              if (!provider.isStale)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat, lng),
                      width: 60,
                      height: 60,
                      child: Transform.rotate(
                        angle: bearing * (math.pi / 180),
                        child: const Icon(Icons.navigation, color: AppColors.secondary, size: 40),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

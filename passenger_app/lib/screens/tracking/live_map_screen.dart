import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/tracking_provider.dart';
import '../../utils/app_colors.dart';

// Extracted UI Widgets
import '../../widgets/live_map/map_header.dart';
import '../../widgets/live_map/map_action_buttons.dart';
import '../../widgets/live_map/bottom_sheet_content.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({Key? key}) : super(key: key);

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TrackingProvider>(
        builder: (context, provider, child) {
          final busData = provider.selectedBus;
          LatLng? busLocation;

          if (busData != null &&
              busData['latitude'] != null &&
              busData['longitude'] != null) {
            busLocation = LatLng(busData['latitude'].toDouble(), busData['longitude'].toDouble());
          }

          // Default location (e.g., Pune)
          LatLng mapCenter = const LatLng(18.5204, 73.8567);
          if (busLocation != null) {
            mapCenter = busLocation;
          }

          return Stack(
            children: [
              // Full Screen Map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: mapCenter,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (busLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: mapCenter,
                          width: 60,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 4,
                                )
                              ],
                            ),
                            child: const Icon(Icons.directions_bus, color: Colors.white, size: 30),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Top Floating Search Bar
              MapHeader(busData: busData),

              // Side Floating Buttons
              MapActionButtons(
                mapController: _mapController,
                mapCenter: mapCenter,
                hasBusLocation: busLocation != null,
              ),

              // Draggable Bottom Sheet
              if (busData != null)
                DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: 0.35,
                  minChildSize: 0.15,
                  maxChildSize: 0.65,
                  builder: (context, scrollController) {
                    return BottomSheetContent(
                      busData: busData,
                      scrollController: scrollController,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

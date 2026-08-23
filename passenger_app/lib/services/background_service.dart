import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'foreground_notification.dart';
import 'location_sync_service.dart';
import 'geofence_service.dart';
import '../utils/route_calculator.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();
  
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final prefs = await SharedPreferences.getInstance();
  String? driverId = prefs.getString('current_driver_id');
  String? busId = prefs.getString('current_bus_id');

  if (driverId == null || busId == null) {
    service.stopSelf();
    return;
  }
  
  ForegroundNotification.updateNotification('Smart Bus Driver', 'Live trip is running...');

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // Notification is ongoing
      }
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ForegroundNotification.updateNotification('GPS Disabled', 'Please enable GPS for live tracking.');
        return; 
      } else {
        ForegroundNotification.updateNotification('Smart Bus Driver', 'Live trip is running...');
      }

      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        )
      );

      await LocationSyncService.syncLocation(
        busId: busId,
        latitude: pos.latitude,
        longitude: pos.longitude,
        speed: pos.speed * 3.6,
        heading: pos.heading,
        driverId: driverId,
      );

      // Route Replay: Save Waypoint every 15 seconds
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      int lastWaypointTime = prefs.getInt('last_waypoint_time') ?? 0;
      if (currentTimestamp - lastWaypointTime >= 15000) {
        String? tripId = prefs.getString('current_trip_id');
        if (tripId != null) {
          FirebaseFirestore.instance
            .collection('trip_waypoints')
            .doc(tripId)
            .collection('points')
            .add({
              'latitude': pos.latitude,
              'longitude': pos.longitude,
              'speed': pos.speed * 3.6,
              'timestamp': FieldValue.serverTimestamp(),
            });
          await prefs.setInt('last_waypoint_time', currentTimestamp);
        }
      }

      // GeoFence Stop Detection
      int currentStopIndex = prefs.getInt('current_stop_index') ?? 0;
      if (currentStopIndex < RouteCalculator.routeStops.length) {
        final nextStop = RouteCalculator.routeStops[currentStopIndex];
        bool arrived = await GeoFenceService.checkArrival(
          busId: busId,
          currentLat: pos.latitude,
          currentLng: pos.longitude,
          nextStop: nextStop,
          nextStopIndex: currentStopIndex,
        );

        if (arrived) {
          // Move to next stop
          await prefs.setInt('current_stop_index', currentStopIndex + 1);
        }
      }

      // Save last sync time for UI
      await prefs.setString('last_sync_time', DateTime.now().toUtc().toIso8601String());
      await prefs.setBool('is_background_running', true);

    } catch (e) {
      debugPrint('Background location error: $e');
    }
  });
}

class BackgroundServiceHelper {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await ForegroundNotification.initialize();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false, 
        isForegroundMode: true,
        notificationChannelId: ForegroundNotification.channelId,
        initialNotificationTitle: 'Smart Bus Driver',
        initialNotificationContent: 'Initializing live trip...',
        foregroundServiceNotificationId: ForegroundNotification.notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }
}

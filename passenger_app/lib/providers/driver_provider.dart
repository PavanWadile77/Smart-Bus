import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../models/driver_model.dart';
import '../services/driver_service.dart';
import '../services/location_service.dart';
import '../services/background_service.dart';
import '../services/trip_history_service.dart';

class DriverProvider extends ChangeNotifier {
  final DriverService _driverService = DriverService();
  final LocationService _locationService = LocationService();
  final Battery _battery = Battery();
  
  DriverModel? _currentDriver;
  DriverModel? get currentDriver => _currentDriver;

  StreamSubscription? _driverSub;
  StreamSubscription? _locationSub;
  StreamSubscription? _connectivitySub;
  Timer? _gpsTimer;

  bool _isTripActive = false;
  bool get isTripActive => _isTripActive;

  int _batteryLevel = 100;
  int get batteryLevel => _batteryLevel;

  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  double _currentSpeed = 0.0;
  double get currentSpeed => _currentSpeed;

  bool _hasGpsSignal = false;
  bool get hasGpsSignal => _hasGpsSignal;

  String _lastSyncTime = 'Never';
  String get lastSyncTime => _lastSyncTime;

  bool _isBackgroundRunning = false;
  bool get isBackgroundRunning => _isBackgroundRunning;

  DriverProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _initDriver(user.uid);
      } else {
        _cleanup();
      }
    });

    _initHardwareListeners();
  }

  void _initHardwareListeners() {
    _battery.batteryLevel.then((level) {
      _batteryLevel = level;
      notifyListeners();
    });
    _battery.onBatteryStateChanged.listen((state) {
      _battery.batteryLevel.then((level) {
        _batteryLevel = level;
        notifyListeners();
      });
    });

    Connectivity().checkConnectivity().then((result) {
      _hasInternet = !result.contains(ConnectivityResult.none);
      notifyListeners();
    });
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      _hasInternet = !result.contains(ConnectivityResult.none);
      notifyListeners();
    });
  }

  void _initDriver(String uid) {
    _driverSub?.cancel();
    _driverSub = _driverService.getDriverStream(uid).listen((driver) {
      _currentDriver = driver;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _driverService.login(email, password);
  }

  Future<void> logout() async {
    await stopTrip();
    await _driverService.logout();
  }

  Future<void> selectTrip(String busId, String routeId) async {
    if (_currentDriver == null) return;
    await _driverService.updateDriverTrip(_currentDriver!.id, busId, routeId);
  }

  Future<String?> startTrip() async {
    if (_currentDriver == null) return 'Driver profile not found.';
    if (!_currentDriver!.isEnabled) return 'Your account is currently disabled. Please contact the administrator.';
    if (_currentDriver!.assignedBus.isEmpty) return 'No bus assigned. Please select a trip first.';
    if (_currentDriver!.assignedRoute.isEmpty) return 'No route assigned. Please select a trip first.';

    try {
      var busDoc = await FirebaseFirestore.instance.collection('buses').doc(_currentDriver!.assignedBus).get().timeout(const Duration(seconds: 10));
      if (!busDoc.exists) return 'Assigned bus does not exist in the database.';
    } on TimeoutException {
      return 'Timeout verifying bus.';
    } catch (e) {
      return 'Failed to verify bus: $e';
    }

    try {
      var routeDoc = await FirebaseFirestore.instance.collection('timetable').doc(_currentDriver!.assignedRoute).get().timeout(const Duration(seconds: 10));
      if (!routeDoc.exists) return 'Assigned route does not exist in the database.';
    } on TimeoutException {
      return 'Timeout verifying route.';
    } catch (e) {
      return 'Failed to verify route: $e';
    }

    bool hasPerms = await _locationService.checkPermissions();
    if (!hasPerms) {
      _hasGpsSignal = false;
      notifyListeners();
      return 'Location permissions are required to start a trip.';
    }

    _isTripActive = true;
    _hasGpsSignal = true;
    
    try {
      await _driverService.updateOnlineStatus(_currentDriver!.id, true);
    } catch (e) {
      _isTripActive = false;
      return 'Failed to update status. Network or permission issue.';
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_driver_id', _currentDriver!.id);
    await prefs.setString('current_bus_id', _currentDriver!.assignedBus);
    await prefs.setBool('is_background_running', true);
    
    // Enterprise Fleet Modules: Initialize
    await prefs.setString('current_trip_id', FirebaseFirestore.instance.collection('trips').doc().id); // Temporary ID for waypoints
    await prefs.setInt('last_waypoint_time', 0);
    await prefs.setInt('current_stop_index', 0);
    await prefs.setString('trip_start_time', DateTime.now().toIso8601String());
    
    await BackgroundServiceHelper.initializeService();
    final service = FlutterBackgroundService();
    service.startService();

    // Loop every 5 seconds just for UI updates (not for Firestore)
    _gpsTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      Position? pos = await _locationService.getCurrentPosition();
      if (pos == null) {
        _hasGpsSignal = false;
      } else {
        _hasGpsSignal = true;
        _currentSpeed = pos.speed * 3.6; // m/s to km/h
      }
      
      final prefs = await SharedPreferences.getInstance();
      _isBackgroundRunning = prefs.getBool('is_background_running') ?? false;
      String? syncTime = prefs.getString('last_sync_time');
      if (syncTime != null) {
        final parsed = DateTime.parse(syncTime).toLocal();
        _lastSyncTime = '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}';
      }
      
      notifyListeners();
    });
    
    notifyListeners();
    return null; // Return null on success
  }

  Future<void> stopTrip() async {
    if (_currentDriver != null) {
      try {
        await _driverService.updateOnlineStatus(_currentDriver!.id, false);
      } catch (e) {
        debugPrint('Error stopping trip: $e');
      }
    }
    _isTripActive = false;
    _gpsTimer?.cancel();
    _isBackgroundRunning = false;
    
    final service = FlutterBackgroundService();
    service.invoke('stopService');
    
    final prefs = await SharedPreferences.getInstance();
    
    String? startStr = prefs.getString('trip_start_time');
    int currentStop = prefs.getInt('current_stop_index') ?? 0;
    
    if (startStr != null && _currentDriver != null) {
      await TripHistoryService().saveTripHistory(
        driverId: _currentDriver!.id,
        busId: _currentDriver!.assignedBus,
        routeId: _currentDriver!.assignedRoute,
        startTime: DateTime.parse(startStr),
        endTime: DateTime.now(),
        distanceKm: currentStop * 2.5, // Approx calculation
        totalStops: currentStop,
      );
    }
    
    await prefs.setBool('is_background_running', false);
    await prefs.remove('current_trip_id');

    notifyListeners();
  }

  // _pushLocationUpdate is removed, now handled by Background Service

  void _cleanup() {
    _driverSub?.cancel();
    _locationSub?.cancel();
    _gpsTimer?.cancel();
    _currentDriver = null;
    _isTripActive = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _cleanup();
    super.dispose();
  }
}

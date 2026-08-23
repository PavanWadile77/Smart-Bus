import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => TrackingProvider(),
      child: const ETIMSimulatorApp(),
    ),
  );
}

// -----------------------------------------------------------------------------
// State Management (Provider)
// -----------------------------------------------------------------------------
class TrackingProvider extends ChangeNotifier {
  final String busId = "MH12-9999";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isTracking = false;
  Position? currentPosition;
  String statusMessage = "Tracking Stopped";
  Color statusColor = const Color(0xFFF8FAFC); // Off White
  Timer? _timer;

  Future<void> requestPermissionsAndStart() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _startTracking();
    } else {
      statusMessage = "Location Permission Denied";
      statusColor = Colors.redAccent;
      notifyListeners();
    }
  }

  void _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      statusMessage = "GPS Disabled";
      statusColor = const Color(0xFFFFB020); // Amber
      notifyListeners();
      return;
    }

    isTracking = true;
    statusMessage = "GPS Active - Initializing";
    statusColor = const Color(0xFF12B76A); // Live Green
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateLocation());
    _updateLocation();
  }

  void stopTracking() {
    _timer?.cancel();
    isTracking = false;
    statusMessage = "Tracking Stopped";
    statusColor = const Color(0xFFF8FAFC); // Off White
    currentPosition = null;
    notifyListeners();
  }

  Future<void> _updateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = position;
      
      if (position.accuracy > 50) {
        statusMessage = "GPS Weak";
        statusColor = const Color(0xFFFFB020); // Amber
      } else {
        statusMessage = "GPS Active";
        statusColor = const Color(0xFF12B76A); // Live Green
      }
      notifyListeners();

      await _sendToFirestore(position);
    } catch (e) {
      statusMessage = "GPS Error";
      statusColor = Colors.redAccent;
      notifyListeners();
    }
  }

  Future<void> _sendToFirestore(Position position) async {
    try {
      await _firestore.collection('buses').doc(busId).set({
        "bus_id": busId,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "speed": position.speed * 3.6, // Convert m/s to km/h
        "accuracy": position.accuracy,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "active"
      });
    } catch (e) {
      statusMessage = "Database Offline";
      statusColor = Colors.redAccent;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// -----------------------------------------------------------------------------
// App and UI
// -----------------------------------------------------------------------------
class ETIMSimulatorApp extends StatelessWidget {
  const ETIMSimulatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETIM Simulator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF101828), // Deep Navy
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101828),
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF12B8C8), // Electric Cyan
          secondary: Color(0xFF12B76A), // Live Green
          surface: Color(0xFF101828),
          background: Color(0xFF101828),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFF8FAFC)), // Off White
        ),
        useMaterial3: true,
      ),
      home: const ETIMScreen(),
    );
  }
}

class ETIMScreen extends StatelessWidget {
  const ETIMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrackingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ETIM SIMULATOR (FIREBASE)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF12B8C8)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bus ID Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Slightly lighter navy
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF12B8C8).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text("ACTIVE BUS ID", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text(provider.busId, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Status Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.statusColor,
                    boxShadow: [
                      BoxShadow(color: provider.statusColor.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  provider.statusMessage.toUpperCase(),
                  style: TextStyle(color: provider.statusColor, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.1),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Live Data
            if (provider.currentPosition != null) ...[
              _buildDataRow("LATITUDE", provider.currentPosition!.latitude.toStringAsFixed(6)),
              _buildDataRow("LONGITUDE", provider.currentPosition!.longitude.toStringAsFixed(6)),
              _buildDataRow("SPEED", "${(provider.currentPosition!.speed * 3.6).toStringAsFixed(1)} km/h"),
              _buildDataRow("ACCURACY", "${provider.currentPosition!.accuracy.toStringAsFixed(1)} m"),
              _buildDataRow("UPDATED", DateTime.now().toLocal().toString().substring(11, 19)),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Text("WAITING FOR GPS DATA...", style: TextStyle(color: Colors.grey, letterSpacing: 1.2)),
                ),
              ),
            ],
            
            const Spacer(),

            // Action Button
            ElevatedButton(
              onPressed: provider.isTracking ? provider.stopTracking : provider.requestPermissionsAndStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.isTracking ? Colors.redAccent : const Color(0xFF12B8C8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                provider.isTracking ? 'STOP TRACKING' : 'START TRACKING',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1.1)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/driver_provider.dart';
import '../../utils/app_colors.dart';
import 'driver_login_screen.dart';
import '../../services/attendance_service.dart';
import '../../services/sos_service.dart';
import '../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        final driver = provider.currentDriver;
        if (driver == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text('Driver Dashboard', style: TextStyle(color: AppColors.textPrimary)),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.timer, color: Colors.blue),
                tooltip: 'Clock In',
                onPressed: () async {
                  await AttendanceService().clockIn(driver.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clocked In successfully')));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.sos, color: Colors.red, size: 32),
                tooltip: 'SOS Emergency',
                onPressed: () async {
                  Position? pos = await LocationService().getCurrentPosition();
                  if (pos != null) {
                    await SOSService().triggerSOS(
                      driverId: driver.id,
                      busId: driver.assignedBus,
                      latitude: pos.latitude,
                      longitude: pos.longitude,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS Alert Sent!')));
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black),
                tooltip: 'Logout',
                onPressed: () async {
                  await AttendanceService().clockOut(driver.id);
                  await provider.logout();
                  if (context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverLoginScreen()));
                  }
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard('Assigned Bus', driver.assignedBus, Icons.directions_bus, AppColors.primary),
                const SizedBox(height: 16),
                _buildStatusCard('Assigned Route', driver.assignedRoute, Icons.route, AppColors.primary),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Speed', '${provider.currentSpeed.toStringAsFixed(1)} km/h', Icons.speed, Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Battery', '${provider.batteryLevel}%', Icons.battery_full, provider.batteryLevel > 20 ? Colors.green : Colors.red)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Internet', provider.hasInternet ? 'Online' : 'Offline', Icons.wifi, provider.hasInternet ? Colors.green : Colors.red)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('GPS Signal', provider.hasGpsSignal ? 'Good' : 'Lost', Icons.gps_fixed, provider.hasGpsSignal ? Colors.green : Colors.red)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Background', provider.isBackgroundRunning ? 'Running' : 'Stopped', Icons.memory, provider.isBackgroundRunning ? Colors.green : Colors.grey)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Last Sync', provider.lastSyncTime, Icons.sync, Colors.blue)),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.isTripActive) {
                        provider.stopTrip();
                      } else {
                        // Show a temporary loading state or disable button (simplified here)
                        String? error = await provider.startTrip();
                        if (error != null && context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              icon: const Icon(Icons.error_outline, color: Colors.red, size: 48),
                              title: const Text('Cannot Start Trip'),
                              content: Text(error),
                              actions: [
                                FilledButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.isTripActive ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      provider.isTripActive ? 'STOP TRIP' : 'START TRIP',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (provider.isTripActive)
                  const Center(
                    child: Text(
                      'Streaming live location to passengers...',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

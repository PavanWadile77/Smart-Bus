import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../utils/app_colors.dart';
import 'admin_login_screen.dart';
import 'bus_management_screen.dart';
import 'driver_management_screen.dart';
import 'route_management_screen.dart';
import 'fleet_monitor_screen.dart';
import 'notification_management_screen.dart';
import 'analytics_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await Provider.of<AdminProvider>(context, listen: false).logout();
              if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
            },
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard(context, 'Buses', Icons.directions_bus, Colors.blue, const BusManagementScreen()),
          _buildCard(context, 'Drivers', Icons.person, Colors.orange, const DriverManagementScreen()),
          _buildCard(context, 'Routes & Timetable', Icons.route, Colors.green, const RouteManagementScreen()),
          _buildCard(context, 'Live Fleet', Icons.map, Colors.red, const FleetMonitorScreen()),
          _buildCard(context, 'Notifications', Icons.notifications, Colors.purple, const NotificationManagementScreen()),
          _buildCard(context, 'Analytics', Icons.analytics, Colors.teal, const AnalyticsScreen()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

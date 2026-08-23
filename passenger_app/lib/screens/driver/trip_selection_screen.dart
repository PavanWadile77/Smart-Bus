import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/driver_provider.dart';
import '../../utils/app_colors.dart';
import 'driver_dashboard.dart';

class TripSelectionScreen extends StatefulWidget {
  const TripSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TripSelectionScreen> createState() => _TripSelectionScreenState();
}

class _TripSelectionScreenState extends State<TripSelectionScreen> {
  final _busController = TextEditingController();
  final _routeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Select Trip', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _busController,
              decoration: const InputDecoration(
                labelText: 'Bus Number (e.g. MH-12-AB-1234)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _routeController,
              decoration: const InputDecoration(
                labelText: 'Route ID (e.g. ROUTE_101)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  if (_busController.text.isEmpty || _routeController.text.isEmpty) return;
                  setState(() => _isLoading = true);
                  await Provider.of<DriverProvider>(context, listen: false)
                      .selectTrip(_busController.text, _routeController.text);
                  if (mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverDashboard()));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Proceed to Dashboard', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

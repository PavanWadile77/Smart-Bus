import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/admin_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          int totalBuses = provider.buses.length;
          int activeDrivers = provider.drivers.where((d) => d.isOnline).length;
          int liveBuses = provider.liveBuses.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total Buses', totalBuses.toString(), Colors.blue),
                    _buildStatCard('Active Drivers', activeDrivers.toString(), Colors.orange),
                    _buildStatCard('Live Buses', liveBuses.toString(), Colors.red),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Active Drivers vs Total Buses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (totalBuses > 10 ? totalBuses.toDouble() : 10),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [BarChartRodData(toY: totalBuses.toDouble(), color: Colors.blue)],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [BarChartRodData(toY: activeDrivers.toDouble(), color: Colors.orange)],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [BarChartRodData(toY: liveBuses.toDouble(), color: Colors.red)],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

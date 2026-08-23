import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Why Smart Bus?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildFeatureItem(Icons.gps_fixed, 'Live GPS', Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildFeatureItem(Icons.timer, 'Real Time ETA', Colors.orange)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildFeatureItem(Icons.security, 'Safe Travel', Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildFeatureItem(Icons.route, 'Route Search', Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}

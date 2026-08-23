import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class StatisticsCard extends StatelessWidget {
  final String eta;
  final String speed;
  
  const StatisticsCard({Key? key, required this.eta, required this.speed}) : super(key: key);

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("ETA", eta, Icons.schedule, AppColors.warning)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard("Speed", speed, Icons.speed, AppColors.primary)),
      ],
    );
  }
}

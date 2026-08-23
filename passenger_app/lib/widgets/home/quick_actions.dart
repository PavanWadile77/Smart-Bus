import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onLiveTrack;
  final VoidCallback onTimetable;
  final VoidCallback onNearestStop;

  const QuickActions({
    Key? key,
    required this.onSearch,
    required this.onLiveTrack,
    required this.onTimetable,
    required this.onNearestStop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionItem(context, Icons.search, 'Search Bus', Colors.blue, onSearch),
              _buildActionItem(context, Icons.directions_bus, 'Live Track', Colors.green, onLiveTrack),
              _buildActionItem(context, Icons.schedule, 'Timetable', Colors.orange, onTimetable),
              _buildActionItem(context, Icons.location_on, 'Near Stop', Colors.purple, onNearestStop),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, MaterialColor color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.shade100, width: 1),
            ),
            child: Icon(icon, color: color.shade700, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

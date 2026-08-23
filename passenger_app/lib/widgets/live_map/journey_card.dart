import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class JourneyCard extends StatelessWidget {
  final String currentStop;
  final String nextStop;
  
  const JourneyCard({Key? key, required this.currentStop, required this.nextStop}) : super(key: key);

  Widget _buildInfoRow(IconData icon, String title, String value, {Color iconColor = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.my_location, "Current Stop", currentStop),
          Padding(
            padding: const EdgeInsets.only(left: 11.0, top: 4, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(width: 2, height: 20, color: Colors.grey.shade300),
            ),
          ),
          _buildInfoRow(Icons.location_on, "Next Stop", nextStop, iconColor: AppColors.primary),
        ],
      ),
    );
  }
}

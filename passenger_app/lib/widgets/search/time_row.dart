import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class TimeRow extends StatelessWidget {
  final String source;
  final String destination;
  final String departureTime;
  final String arrivalTime;

  const TimeRow({
    Key? key,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(departureTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(source, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(arrivalTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(destination, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
            ],
          ),
        ),
      ],
    );
  }
}

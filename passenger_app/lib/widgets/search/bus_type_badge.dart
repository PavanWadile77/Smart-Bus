import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class BusTypeBadge extends StatelessWidget {
  final String busType;
  final bool isLive;

  const BusTypeBadge({Key? key, required this.busType, this.isLive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            busType.toUpperCase(),
            style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        if (isLive) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "LIVE",
              style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ]
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SettingsHeader extends StatelessWidget {
  final String? userName;
  final String? profileImageUrl;

  const SettingsHeader({Key? key, this.userName, this.profileImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your Smart Bus experience',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                ],
              ),
              child: ClipOval(
                child: Image.asset('assets/images/logo.png', width: 72, height: 72, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              userName ?? 'Guest User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}

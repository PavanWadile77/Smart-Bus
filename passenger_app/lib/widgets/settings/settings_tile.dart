import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Color iconColor;

  const SettingsTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.iconColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
      ),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)) : null,
      trailing: isSwitch
          ? Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeThumbColor: AppColors.primary,
            )
          : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: isSwitch ? null : onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

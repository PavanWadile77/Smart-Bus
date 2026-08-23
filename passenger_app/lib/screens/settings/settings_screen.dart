import 'package:flutter/material.dart';
import '../../widgets/settings/settings_header.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../providers/recent_search_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SettingsHeader(), // Avatar/Username hidden as not available in current scope
            const SizedBox(height: 32),
            SettingsSection(
              title: "GENERAL",
              children: [
                SettingsTile(
                  title: "Dark Mode",
                  subtitle: "Enable dark theme across the app",
                  icon: Icons.dark_mode,
                  isSwitch: true,
                  switchValue: false,
                  onSwitchChanged: (val) {},
                ),
                SettingsTile(
                  title: "Notifications",
                  subtitle: "Receive alerts for favorite buses",
                  icon: Icons.notifications,
                  isSwitch: true,
                  switchValue: true,
                  onSwitchChanged: (val) {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            SettingsSection(
              title: "APPLICATION",
              children: [
                SettingsTile(
                  title: "About App",
                  icon: Icons.info,
                  iconColor: Colors.blueGrey,
                  onTap: () {},
                ),
                SettingsTile(
                  title: "Privacy Policy",
                  icon: Icons.privacy_tip,
                  iconColor: Colors.blueGrey,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return SettingsSection(
                  title: "NOTIFICATIONS",
                  children: [
                    SwitchListTile(
                      title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      secondary: const Icon(Icons.notifications_active, color: AppColors.primary),
                      activeColor: AppColors.primary,
                      value: notificationProvider.isPushEnabled,
                      onChanged: (value) {
                        notificationProvider.togglePushNotifications(value);
                      },
                    ),
                    SwitchListTile(
                      title: const Text("Notification Sound", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      secondary: const Icon(Icons.volume_up, color: Colors.green),
                      activeColor: Colors.green,
                      value: notificationProvider.isSoundEnabled,
                      onChanged: (value) {
                        notificationProvider.toggleSound(value);
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            if (AuthService().currentUser != null)
              SettingsSection(
                title: "ACCOUNT",
                children: [
                  SettingsTile(
                    title: "Clear Recent Searches",
                    icon: Icons.history_toggle_off,
                    iconColor: Colors.orange,
                    onTap: () async {
                      await Provider.of<RecentSearchProvider>(context, listen: false).clearSearches();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recent searches cleared')),
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    title: "Logout",
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    onTap: () async {
                      await AuthService().logout();
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

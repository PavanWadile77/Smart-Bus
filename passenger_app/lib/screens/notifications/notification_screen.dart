import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/notifications/notification_card.dart';
import '../../widgets/notifications/empty_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (provider.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  provider.markAllAsRead();
                },
                child: const Text('Mark All Read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.notifications.isEmpty) {
            return const EmptyNotification();
          }

          return ListView.separated(
            itemCount: provider.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    provider.markAsRead(notification.id);
                  }
                },
                onDelete: () {
                  provider.deleteNotification(notification.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

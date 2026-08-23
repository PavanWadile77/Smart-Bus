import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../utils/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  IconData _getIconForType() {
    switch (notification.type) {
      case 'Live Bus Started': return Icons.directions_bus;
      case 'Bus Delayed': return Icons.warning_amber_rounded;
      case 'ETA Updated': return Icons.timer;
      case 'Favorite Bus Nearby': return Icons.star;
      case 'Route Cancelled': return Icons.cancel_outlined;
      default: return Icons.notifications;
    }
  }

  Color _getColorForType() {
    switch (notification.type) {
      case 'Live Bus Started': return Colors.green;
      case 'Bus Delayed': return Colors.orange;
      case 'ETA Updated': return Colors.blue;
      case 'Favorite Bus Nearby': return Colors.amber;
      case 'Route Cancelled': return Colors.red;
      default: return AppColors.primary;
    }
  }

  String _formatTime() {
    final now = DateTime.now();
    final difference = now.difference(notification.createdAt);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: notification.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getColorForType().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconForType(), color: _getColorForType()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(),
                          style: TextStyle(fontSize: 12, color: notification.isRead ? Colors.grey : AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: notification.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

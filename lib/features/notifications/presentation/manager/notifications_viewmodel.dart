import 'package:flutter/material.dart';
import 'package:wolfera/features/notifications/data/models/notification_model.dart';

class NotificationViewModel {
  final NotificationModel notification;
  ValueNotifier<bool> isRead;

  NotificationViewModel({required this.notification})
      : isRead = ValueNotifier(notification.readAt != null);
}

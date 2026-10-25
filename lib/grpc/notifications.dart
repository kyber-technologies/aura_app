import 'dart:convert';

import 'package:aura_app/grpc/auth.dart';
import 'package:aura_app/grpc/client.dart';
import 'package:aura_app/logger.dart';
import 'package:aura_app/storage.dart';
import 'package:aura_dart/user.dart';
import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const int _maxCachedNotifications = 32;

final StreamProvider<SubscribeResponse> notificationStreamProvider =
    StreamProvider.autoDispose<SubscribeResponse>((Ref ref) async* {
      final AuraClient client = await ref.watch(auraClientProvider.future);
      final AuthService auth = await ref.watch(authProvider.future);
      final Storage storage = await ref.watch(storageProvider.future);

      final ResponseStream<SubscribeResponse> stream = client.userService
          .subscribe(SubscribeRequest(), options: auth.buildOptions());

      await for (final SubscribeResponse response in stream) {
        if (response.hasError()) {
          logger.e('Failed to read subscription response: ${response.error}');
        } else if (response.notifications.isNotEmpty) {
          for (final Notification notification in response.notifications) {
            auth.user.notifications.add(notification);
            storage.notificationStorage.addNotification(notification);

            bool refreshAuth = false;

            switch (notification.whichNotification()) {
              case Notification_Notification.invite:
                refreshAuth = true;
              case Notification_Notification.message:
              case Notification_Notification.comment:
              case Notification_Notification.notSet:
            }

            if (refreshAuth) {
              await auth.refresh();
            }
          }
        }

        yield response;
      }
    });

class NotificationStorage {
  final List<StoredNotification> _notifications;

  static NotificationStorage defaultValue() =>
      NotificationStorage(<StoredNotification>[]);

  NotificationStorage(this._notifications);

  static NotificationStorage fromJson(Map<String, dynamic> json) {
    final List<dynamic> list =
        json['notifications'] as List<dynamic>? ?? <dynamic>[];

    final List<StoredNotification> notifications = list
        .map(
          (dynamic item) =>
              StoredNotification.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return NotificationStorage(notifications);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'notifications': _notifications
        .map((StoredNotification n) => n.toJson())
        .toList(),
  };

  void addNotification(Notification notification) {
    if (_notifications.length >= _maxCachedNotifications) {
      _notifications.removeAt(0);
    }

    _notifications.add(StoredNotification(notification, false));
  }
}

class StoredNotification {
  final Notification notification;
  final bool isRead;

  StoredNotification(this.notification, this.isRead);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'notification': base64Encode(notification.writeToBuffer()),
    'isRead': isRead,
  };

  StoredNotification.fromJson(Map<String, dynamic> json)
    : notification = Notification.fromBuffer(
        base64Decode(json['notification'] as String),
      ),
      isRead = json['isRead'] as bool;
}

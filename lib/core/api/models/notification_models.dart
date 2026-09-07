import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Swagger: `Notification` — bildirishnoma.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String message,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

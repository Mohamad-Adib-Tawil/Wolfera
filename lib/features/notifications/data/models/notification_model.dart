import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/extensions/datetime.dart';

part 'notification_model.freezed.dart';

part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "data") required NotificationData data,
    @JsonKey(name: "type") required String type,
    @JsonKey(
      name: "read_at",
      fromJson: dateFromJsonNullable,
      includeToJson: false,
    )
    required DateTime? readAt,
    @JsonKey(
      name: "created_at",
      fromJson: dateFromJson,
      includeToJson: false,
    )
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  static List<NotificationModel> parseData(List<dynamic> list) =>
      list.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
  const NotificationModel._();
}

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    @JsonKey(name: "action_id") required int actionId,
    @JsonKey(name: "action") required String action,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
}

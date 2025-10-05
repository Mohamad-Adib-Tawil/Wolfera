// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      type: json['type'] as String,
      readAt: dateFromJsonNullable(json['read_at']),
      createdAt: dateFromJson(json['created_at']),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'data': instance.data,
      'type': instance.type,
    };

_$NotificationDataImpl _$$NotificationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationDataImpl(
      actionId: (json['action_id'] as num).toInt(),
      action: json['action'] as String,
    );

Map<String, dynamic> _$$NotificationDataImplToJson(
        _$NotificationDataImpl instance) =>
    <String, dynamic>{
      'action_id': instance.actionId,
      'action': instance.action,
    };

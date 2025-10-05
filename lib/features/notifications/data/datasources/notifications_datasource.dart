import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/constants/route.dart';
import 'package:wolfera/common/models/pagination_model.dart';
import 'package:wolfera/features/notifications/data/models/notification_model.dart';
import '../../../../core/api/api_utils.dart';
import '../../../../core/api/client.dart';
import '../../../../core/api/client_config.dart';
import '../../../../core/api/result.dart';

@injectable
class NotificationsDatasource {
  final ClientApi _clientApi;

  NotificationsDatasource({
    required ClientApi clientApi,
  }) : _clientApi = clientApi;
}

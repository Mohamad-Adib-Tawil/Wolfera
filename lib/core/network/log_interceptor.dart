import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/network/status_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../features/app/domin/repositories/prefs_repository.dart';
import '../../services/language_service.dart';
import 'log.dart';

enum _StatusType {
  succeed,
  failed,
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (GetIt.I<PrefsRepository>().registeredUser &&
        GetIt.I<PrefsRepository>().token != null) {
      options.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${GetIt.I<PrefsRepository>().token}';
    }

    options.headers["X-Lang"] = LanguageService.languageCode;

    if (kDebugMode) {
      prettyPrinterI(
        "***|| INFO Request ${options.path.substring(options.baseUrl.toString().length)} ||***"
        "\n HTTP Method: ${options.method}"
        "\n token : ${options.headers[HttpHeaders.authorizationHeader]?.substring(0, 20)}"
        "\n param : ${options.queryParameters}"
        "\n data : ${options.data}"
        "\n url: ${options.path}"
        "\n Header: ${options.headers}"
        "\n timeout: ${options.connectTimeout?.inSeconds ?? 0}s",
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _StatusType statusType;
      if (response.statusCode == StatusCode.operationSucceeded.code) {
        statusType = _StatusType.succeed;
      } else {
        statusType = _StatusType.failed;
      }
      final requestRoute = response.requestOptions.path
          .substring(response.requestOptions.baseUrl.toString().length);

      if (statusType == _StatusType.failed) {
        prettyPrinterError(
            '***|| ${statusType.name.toUpperCase()} Response into -> $requestRoute ||***');
      } else {
        prettyPrinterV(
            '***|| ${statusType.name.toUpperCase()} Response into -> $requestRoute ||***');
      }
      prettyPrinterWtf(
        "***|| INFO Response Request $requestRoute ${statusType == _StatusType.succeed ? '✊' : ''} ||***"
        "\n Status code: ${response.statusCode}"
        "\n Status message: ${response.statusMessage}"
        "\n Data: ${response.data}",
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      prettyPrinterError(
        "***|| SOMETHING ERROR 💔💔 ||***"
        "\n error: ${err.error}"
        "\n response: ${err.response}"
        "\n message: ${err.message}"
        "\n type: ${err.type}"
        "\n stackTrace: ${err.stackTrace}",
      );
    }
    handler.next(err);
  }
}

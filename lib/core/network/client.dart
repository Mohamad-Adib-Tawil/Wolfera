import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'client_config.dart';
import 'exceptions.dart';

typedef HttpLibraryMethodInvocation<T> = Future<Response<T>> Function();

class ClientApi {
  Dio get _client => GetIt.I<Dio>();

  Future<Response<T>> request<T>(
    RequestConfig<T> settings, {
    final ProgressCallback? onReceiveProgress,
    final ProgressCallback? onSendProgress,
  }) async {
    Response<T> response;
    final queryParameters = settings.queryParameters;
    final data = settings.data;
    final endpoint = settings.endpoint;

    final baseUrl = Uri.parse(_client.options.baseUrl);

    final requestUrl = Uri(
      path: endpoint,
      queryParameters: queryParameters,
      host: baseUrl.host,
      scheme: baseUrl.scheme,
      port: baseUrl.port,
    );
    switch (settings.clientMethod) {
      case ClientMethod.get:
        function() => _client.getUri<T>(
              requestUrl,
              onReceiveProgress: onReceiveProgress,
              data: data,
            );

        response = await _mapException<T>(function);
        break;
      case ClientMethod.post:
        function() => _client.postUri<T>(
              requestUrl,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
              data: data,
            );

        response = await _mapException<T>(function);
        break;
      case ClientMethod.put:
        function() => _client.putUri<T>(
              requestUrl,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
              data: data,
            );
        response = await _mapException(function);
        break;
      case ClientMethod.delete:
        function() => _client.deleteUri<T>(requestUrl, data: data);
        response = await _mapException(function);
        break;
    }

    return response;
  }

  Future<Response<T>> _mapException<T>(HttpLibraryMethodInvocation<T> method) async {
    try {
      return await method();
    } on DioError catch (exception) {
      if (exception.response?.statusCode.toString().matchAsPrefix('5') != null) {
        throw AppNetworkException(reason: AppNetworkExceptionReason.serverError, exception: exception);
      }
      switch (exception.type) {
        case DioErrorType.cancel:
          throw AppNetworkException(
            reason: AppNetworkExceptionReason.canceled,
            exception: exception,
          );
        case DioErrorType.connectionTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
          throw AppNetworkException(reason: AppNetworkExceptionReason.timedOut, exception: exception);
        case DioErrorType.badResponse:
          // For DioErrorType.response, we are guaranteed to have a
          // response object present on the exception.
          final response = exception.response;
          if (response == null || response is! Response<T>) {
            // This should never happen, judging by the current source code
            // for Dio.
            throw AppNetworkResponseException(exception: exception);
          }

          throw AppNetworkResponseException(
            exception: exception,
            statusCode: response.statusCode,
            data: response.data,
          );
        case DioErrorType.unknown:
        default:
          if (exception.error is SocketException) {
            throw AppNetworkException(reason: AppNetworkExceptionReason.noInternet, exception: exception);
          }
          throw AppException.unknown(exception: exception);
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw AppException.unknown(
        exception: e is Exception ? e : Exception('Unknown exception occurred'),
      );
    }
  }
}

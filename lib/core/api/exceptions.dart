import 'package:wolfera/generated/locale_keys.g.dart';

class AppException<OriginalException> implements Exception {
  const AppException({required this.message, required this.exception});

  const AppException.unknown({required this.exception, required this.message});

  final OriginalException exception;
  final String message;

  AppException copyWith({
    OriginalException? exception,
    String? message,
  }) {
    return AppException(
      exception: exception ?? this.exception,
      message: message ?? this.message,
    );
  }
}

enum AppNetworkExceptionReason {
  canceled(LocaleKeys.AppNetworkExceptionReason_canceled),
  timedOut(LocaleKeys.AppNetworkExceptionReason_timedOut),
  responseError(LocaleKeys.AppNetworkExceptionReason_responseError),
  noInternet(LocaleKeys.AppNetworkExceptionReason_noInternet),
  serverError(LocaleKeys.AppNetworkExceptionReason_serverError);

  const AppNetworkExceptionReason(this.message);

  final String message;
}

class AppNetworkException<OriginalException extends Exception>
    extends AppException<OriginalException> {
  AppNetworkException({
    required this.reason,
    required super.exception,
    String? message,
  }) : super(message: message ?? reason.message);

  AppNetworkException._({
    required this.reason,
    required super.exception,
    required super.message,
  });

  final AppNetworkExceptionReason reason;

  @override
  AppNetworkException copyWith(
      {OriginalException? exception, String? message}) {
    return AppNetworkException._(
        reason: reason,
        exception: exception ?? this.exception,
        message: message ?? this.message);
  }
}

class AppNetworkResponseException<OriginalException extends Exception, DataType>
    extends AppNetworkException<OriginalException> {
  AppNetworkResponseException(
      {required super.exception, this.statusCode, this.data, super.message})
      : super(reason: AppNetworkExceptionReason.responseError);

  final DataType? data;
  final int? statusCode;

  bool get hasData => data != null;

  /// If the status code is null, returns false. Otherwise, allows the
  /// given closure [evaluator] to validate the given http integer status code.
  ///
  /// Usage:
  /// ```
  /// final isValid = responseException.validateStatusCode(
  ///   (statusCode) => statusCode >= 200 && statusCode < 300,
  /// );
  /// ```
  bool validateStatusCode(bool Function(int statusCode) evaluator) {
    final statusCode = this.statusCode;
    if (statusCode == null) return false;
    return evaluator(statusCode);
  }
}

extension AppExceptionExt on AppException {
  bool get noInternetConnection => isThis(AppNetworkExceptionReason.noInternet);

  bool isThis(AppNetworkExceptionReason reason) {
    if (this is AppNetworkException<dynamic>) {
      final e = this as AppNetworkException;
      return e.reason == reason;
    }
    return false;
  }
}

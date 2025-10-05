typedef FromJson<T> = T Function(Map<String,dynamic> json);

enum ClientMethod { get, post, put, delete }

enum AppNetworkExceptionReason {
  canceled,
  timedOut,
  responseError,
  noInternet,
  serverError
}

class RequestConfig<T> {
  late final dynamic queryParameters;
  late final dynamic data;
  late final String endpoint;
  late final ResponseMapper<T> response;
  late final ClientMethod clientMethod;

  RequestConfig({
    required this.endpoint,
    required this.response,
    required this.clientMethod,
    this.queryParameters,
    this.data,
  });
}

class ResponseMapper<T> {
  final T? value;
  final FromJson<T>? fromJson;

  ResponseMapper({this.value, this.fromJson})
      : assert(() {
          if (fromJson == null && value == null) {
            return false;
          }
          return true;
        }(), "They cannot both have a null value together");
}

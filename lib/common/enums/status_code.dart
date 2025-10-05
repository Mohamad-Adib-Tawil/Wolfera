enum StatusCode {
  operationSucceeded(200),
  operationFailed(400),
  unAuthorized(401),
  forbidden(403),
  serverError(500),
  ;

  const StatusCode(this.code);

  final int code;
}

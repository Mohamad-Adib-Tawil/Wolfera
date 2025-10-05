abstract class EndPoints {
  EndPoints._();
  static const baseUrl = "http://api.wolferacars.com/";
  static const auth = _Auth();
}

class _Auth {
  const _Auth();

  final login = '/auth/login';
  final register = '/auth/register';
  final verify = '/token/verify';
  final resend = '/token/resend';
  final resetPasswordGenerate = '/auth/reset-password/generate';
  final resetPasswordCheck = '/auth/reset-password/check';
  final resetPasswordReset = '/auth/reset-password/reset';
  final logout = '/auth/logout';
}

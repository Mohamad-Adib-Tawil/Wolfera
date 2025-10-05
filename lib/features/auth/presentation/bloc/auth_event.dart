part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  const RegisterEvent({required this.onSuccess});

  final VoidCallback onSuccess;
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.onSuccess,
  });

  final ValueChanged<User> onSuccess;
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent({required this.onSuccess});

  final VoidCallback onSuccess;
}

class VerificationEvent extends AuthEvent {
  const VerificationEvent();
}

class ResendCodeEvent extends AuthEvent {}

class ResetPasswordGenerateEvent extends AuthEvent {}

class ResetPasswordCheckEvent extends AuthEvent {
  const ResetPasswordCheckEvent(
      {required this.token, required this.email, required this.onSuccess});
  final String token;
  final String email;
  final VoidCallback onSuccess;
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent();
}

class ChangeCountryEvent extends AuthEvent {
  final Country country;

  const ChangeCountryEvent({required this.country});
}

class GoogleLoginEvent extends AuthEvent {
  const GoogleLoginEvent({
    required this.onSuccess,
  });

  final ValueChanged<User> onSuccess;
}

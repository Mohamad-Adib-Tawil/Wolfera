part of 'auth_bloc.dart';

class AuthState extends Equatable {
  AuthState({
    this.registerStatus = const BlocStatus.initial(),
    this.loginStatus = const BlocStatus.initial(),
    this.verificationStatus = const BlocStatus.initial(),
    this.resendCodeStatus = const BlocStatus.initial(),
    this.resetPasswordGenerateStatus = const BlocStatus.initial(),
    this.resetPasswordCheckStatus = const BlocStatus.initial(),
    this.resetPasswordStatus = const BlocStatus.initial(),
    this.logoutStatus = const BlocStatus.initial(),
    this.phone,
    Country? selectedCountry,
  }) : selectedCountry = selectedCountry ?? AuthBloc.initCountry;

  final BlocStatus registerStatus;
  final BlocStatus loginStatus;
  final BlocStatus verificationStatus;
  final BlocStatus resendCodeStatus;
  final BlocStatus resetPasswordGenerateStatus;
  final BlocStatus resetPasswordCheckStatus;
  final BlocStatus resetPasswordStatus;
  final BlocStatus logoutStatus;
  final String? phone;
  Country selectedCountry;

  @override
  List<Object?> get props => [
        phone,
        registerStatus,
        loginStatus,
        resetPasswordStatus,
        resetPasswordGenerateStatus,
        resetPasswordCheckStatus,
        logoutStatus,
        verificationStatus,
        resendCodeStatus,
        selectedCountry,
      ];

  AuthState copyWith({
    BlocStatus? registerStatus,
    BlocStatus? loginStatus,
    BlocStatus? verificationStatus,
    BlocStatus? logoutStatus,
    final BlocStatus? resetPasswordGenerateStatus,
    final BlocStatus? resetPasswordCheckStatus,
    final String? phone,
    final bool? hasAccountNotVerified,
    BlocStatus? resendCodeStatus,
    final BlocStatus? resetPasswordStatus,
    Nullable<Country?>? selectedCountry,
  }) {
    return AuthState(
      registerStatus: registerStatus ?? this.registerStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      phone: phone ?? this.phone,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      resendCodeStatus: resendCodeStatus ?? this.resendCodeStatus,
      resetPasswordGenerateStatus:
          resetPasswordGenerateStatus ?? this.resetPasswordGenerateStatus,
      resetPasswordCheckStatus:
          resetPasswordCheckStatus ?? this.resetPasswordCheckStatus,
      selectedCountry: selectedCountry != null
          ? selectedCountry.value
          : this.selectedCountry,
    );
  }
}

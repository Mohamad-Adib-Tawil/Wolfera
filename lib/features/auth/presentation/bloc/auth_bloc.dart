import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/utils/nullable.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:wolfera/features/auth/domain/use_cases/register_usecase.dart';
import 'package:wolfera/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/features/auth/domain/use_cases/verification_usecase.dart';
import 'package:wolfera/features/auth/data/data_sources/auth_datasource.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../../../../common/helpers/helper_functions.dart';
import '../../domain/use_cases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class PhoneNumberValidator extends Validator<dynamic> {
  final String phoneControlName;
  final String countryCodeControlName;

  const PhoneNumberValidator(this.phoneControlName, this.countryCodeControlName)
      : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = {ValidationMessage.number: true};

    if (control is! FormGroup) {
      return error;
    }

    final phoneControl = control.control(phoneControlName);
    final countryCodeControl = control.control(countryCodeControlName);

    final phone = phoneControl.value as String?;
    final countryCode = countryCodeControl.value as String?;

    if (phone != null && countryCode != null) {
      final country = CountryParser.tryParsePhoneCode(countryCode)!;
      final iso = isoCodeConversionMap[country.countryCode]!;

      final phoneNumber = PhoneNumber(nsn: phone, isoCode: iso);
      final isValid = phoneNumber.isValid();

      if (!isValid) {
        phoneControl.setErrors(error);
        phoneControl.markAsTouched();
      } else {
        phoneControl.removeError(ValidationMessage.number);
      }
    }

    return null;
  }
}

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._registerUsecase,
    this._loginUsecase,
    this._logoutUsecase,
    this._verificationUsecase,
    this._resetPasswordUsecase,
    this._appManagerCubit,
    this._prefsRepository,
    this._authDatasource,
  ) : super(AuthState()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<LoginEvent>(_onLoginEvent);
    on<GoogleLoginEvent>(_onGoogleLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<VerificationEvent>(_onVerificationEvent);
    on<ChangeCountryEvent>(_onChangeCountryEvent);
  }

  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final RegisterUsecase _registerUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final VerificationUsecase _verificationUsecase;
  final AppManagerCubit _appManagerCubit;
  final PrefsRepository _prefsRepository;
  final AuthDatasource _authDatasource;
  final String kFromPhone = 'phone';
  final String kFromPassword = 'password';
  final String kFromConfirmationPassword = 'confirmationPassword';
  final String kFromName = 'name';
  final String kFromEmail = 'email';
  final String kFromCountryCode = 'countryCode';

  static final initCountry = CountryParser.parsePhoneCode('971');
  late final singUpForm = FormGroup(
    {
      kFromName: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      kFromEmail: FormControl<String>(
        validators: [
          Validators.email,
          Validators.required,
        ],
      ),
      kFromCountryCode: FormControl<String>(validators: [Validators.required]),
      kFromPhone: FormControl<String>(
        validators: [
          Validators.required,
          // const PhoneNumberValidator(),
        ],
      ),
      kFromPassword: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      kFromPassword: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
      kFromConfirmationPassword: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
    },
    validators: [
      Validators.mustMatch(kFromPassword, kFromConfirmationPassword),
      PhoneNumberValidator(kFromPhone, kFromCountryCode),
    ],
  );
  late final loginForm = FormGroup(
    {
      kFromEmail: FormControl<String>(
        validators: [
          Validators.email,
          Validators.required,
        ],
      ),
      kFromPassword: FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
        ],
      ),
    },
  );

  late final resetPasswordForm = FormGroup(
    {
      kFromEmail: FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
    },
  );

  FutureOr<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    if (singUpForm.invalid) {
      singUpForm.markAllAsTouched();
      return;
    }

    emit(state.copyWith(registerStatus: const BlocStatus.loading()));

    final registerParams = RegisterParams(
      fullName: singUpForm.control(kFromName).value,
      email: singUpForm.control(kFromEmail).value,
      phoneNumber: signUpPhoneNumber,
      password: singUpForm.control(kFromPassword).value,
    );

    final response = await _registerUsecase(registerParams);

    response.fold(
      (exception, message) async {
        emit(state.copyWith(registerStatus: BlocStatus.fail(error: message)));
        EasyLoading.showError(
          message ?? "Something went wrong!",
          duration: const Duration(seconds: 2),
          dismissOnTap: true,
        );
      },
      (value) async {
        event.onSuccess.call();
        EasyLoading.showSuccess(
          LocaleKeys.auth_confirmEmail.tr(),
          duration: const Duration(seconds: 2),
          dismissOnTap: true,
        );
        emit(state.copyWith(
          registerStatus: const BlocStatus.success(),
          phone: singUpForm.control(kFromPhone).value,
        ));
      },
    );
  }

  String get signUpPhoneNumber {
    final phone = singUpForm.control(kFromPhone).value;
    return "+${state.selectedCountry.phoneCode}$phone";
  }

  FutureOr<void> _onLoginEvent(
      LoginEvent event, Emitter<AuthState> emit) async {
    if (loginForm.invalid) {
      loginForm.markAllAsTouched();
      return;
    }

    emit(state.copyWith(loginStatus: const BlocStatus.loading()));

    final loginParams = LoginParams(
      email: loginForm.control(kFromEmail).value,
      password: loginForm.control(kFromPassword).value,
    );

    final response = await _loginUsecase(loginParams);

    await response.fold(
      (exception, message) async {
        emit(state.copyWith(loginStatus: BlocStatus.fail(error: message)));
        EasyLoading.showError(
          message ?? "Something went wrong!",
          duration: const Duration(seconds: 4),
          dismissOnTap: true,
        );
      },
      (value) async {
        emit(state.copyWith(
          loginStatus: const BlocStatus.success(),
        ));
        String? phoneNumber;
        String? fullName;
        String? avatarUrl;
        
        // Get user data from Supabase
        final userData = await Supabase.instance.client
            .from('users')
            .select('phone_number, full_name, avatar_url')
            .eq('id', value.id)
            .maybeSingle();

        phoneNumber = userData?['phone_number'] as String?;
        fullName = userData?['full_name'] as String?;
        avatarUrl = userData?['avatar_url'] as String?;

        print('🔐 Login successful - User metadata: ${value.userMetadata}');
        print('🔐 User from DB: fullName=$fullName, avatarUrl=$avatarUrl');
        
        // If display_name is not in metadata, update it from database
        if (fullName != null && value.userMetadata?['display_name'] == null) {
          try {
            print('🔄 Updating auth metadata with display_name from database...');
            await Supabase.instance.client.auth.updateUser(
              UserAttributes(
                data: {
                  'display_name': fullName,
                  if (avatarUrl != null) 'avatar_url': avatarUrl,
                },
              ),
            );
            // Refresh user to get updated metadata
            final updatedUser = Supabase.instance.client.auth.currentUser;
            if (updatedUser != null) {
              await _prefsRepository.setUser(updatedUser, phoneNumber ?? "");
            } else {
              await _prefsRepository.setUser(value, phoneNumber ?? "");
            }
          } catch (e) {
            print('⚠️ Could not update auth metadata: $e');
            await _prefsRepository.setUser(value, phoneNumber ?? "");
          }
        } else {
          await _prefsRepository.setUser(value, phoneNumber ?? "");
        }

        loginForm
          ..value = {
            kFromEmail: "",
            kFromPassword: "",
          }
          ..markAsUntouched();
        _appManagerCubit.checkUser();

        event.onSuccess(value);
      },
    );
  }

  FutureOr<void> _onGoogleLoginEvent(
      GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: const BlocStatus.loading()));

    // Use AuthDatasource for Google login
    final result = await _authDatasource.loginWithGoogle();

    result.fold(
      (exception, message) {
        EasyLoading.showError(
          message ?? "Something went wrong!",
          duration: const Duration(seconds: 4),
          dismissOnTap: true,
        );
        emit(state.copyWith(loginStatus: BlocStatus.fail(error: message)));
      },
      (value) async {
        emit(state.copyWith(
          loginStatus: const BlocStatus.success(),
        ));
        String? phoneNumber;
        String? fullName;
        String? avatarUrl;
        
        // Get user data from Supabase with error handling
        try {
          final userData = await Supabase.instance.client
              .from('users')
              .select('phone_number, full_name, avatar_url')
              .eq('id', value.id)
              .maybeSingle();
          
          phoneNumber = userData?['phone_number'];
          fullName = userData?['full_name'];
          avatarUrl = userData?['avatar_url'];
        } catch (e) {
          print('❌ Failed to get user data from database: $e');
          phoneNumber = null;
        }

        print('🔐 Google login successful - User metadata: ${value.userMetadata}');
        print('🔐 User from DB: fullName=$fullName, avatarUrl=$avatarUrl');
        
        // If display_name is not in metadata, update it from database
        if (fullName != null && value.userMetadata?['display_name'] == null) {
          try {
            print('🔄 Updating auth metadata with display_name from database...');
            await Supabase.instance.client.auth.updateUser(
              UserAttributes(
                data: {
                  'display_name': fullName,
                  if (avatarUrl != null) 'avatar_url': avatarUrl,
                },
              ),
            );
            // Refresh user to get updated metadata
            final updatedUser = Supabase.instance.client.auth.currentUser;
            if (updatedUser != null) {
              await _prefsRepository.setUser(updatedUser, phoneNumber ?? "");
            } else {
              await _prefsRepository.setUser(value, phoneNumber ?? "");
            }
          } catch (e) {
            print('⚠️ Could not update auth metadata: $e');
            await _prefsRepository.setUser(value, phoneNumber ?? "");
          }
        } else {
          await _prefsRepository.setUser(value, phoneNumber ?? "");
        }
        
        _appManagerCubit.checkUser();

        event.onSuccess(value);
      },
    );
  }

  FutureOr<void> _onVerificationEvent(
      VerificationEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(verificationStatus: const BlocStatus.loading()));

    final response = await _verificationUsecase();

    response.fold(
      (exception, message) {
        EasyLoading.showError(
          message ?? "Unable to send verification email",
          duration: const Duration(seconds: 4),
          dismissOnTap: true,
        );
        emit(state.copyWith(
            verificationStatus: BlocStatus.fail(error: message)));
      },
      (value) {
        EasyLoading.showToast(
          "Please check your email",
          duration: const Duration(seconds: 4),
          dismissOnTap: true,
        );
        emit(state.copyWith(
          verificationStatus: const BlocStatus.success(),
        ));
      },
    );
  }

  String get loginPhoneNumber {
    final phone = loginForm.control(kFromPhone).value;
    return "+${state.selectedCountry.phoneCode}$phone";
  }

  FutureOr<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(logoutStatus: const BlocStatus.loading()));

      final response = await _logoutUsecase();
      if (response.isFailure) {
        emit(state.copyWith(
            logoutStatus:
                BlocStatus.fail(error: response.getFailureOrNull?.message)));
      } else {
        await HelperFunctions.instance.logout().then((value) =>
            GRouter.router.goNamed(GRouter.config.krpOnboardingRoutePath));

        emit(state.copyWith(logoutStatus: const BlocStatus.success()));
      }
    } catch (e) {
      emit(state.copyWith(logoutStatus: const BlocStatus.fail(error: null)));
      debugPrint(e.toString());
    }
  }

  FutureOr<void> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    if (resetPasswordForm.invalid) {
      resetPasswordForm.markAllAsTouched();
      return;
    }
    emit(state.copyWith(resetPasswordStatus: const BlocStatus.loading()));

    final response = await _resetPasswordUsecase(ResetPasswordParams(
      email: resetPasswordForm.control(kFromEmail).value,
    ));

    response.fold(
      (exception, message) => emit(
          state.copyWith(resetPasswordStatus: BlocStatus.fail(error: message))),
      (value) {
        emit(state.copyWith(resetPasswordStatus: const BlocStatus.success()));
        if (value) {
          EasyLoading.showToast(
            "Please check your email to reset password",
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
        } else {
          EasyLoading.showError(
            "This email not exist !",
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
        }

        GRouter.router.pop();
      },
    );
  }

  FutureOr<void> _onChangeCountryEvent(
      ChangeCountryEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(selectedCountry: Nullable.value(event.country)));
  }
}

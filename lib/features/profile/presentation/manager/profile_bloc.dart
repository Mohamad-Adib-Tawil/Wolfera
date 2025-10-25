import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wolfera/features/profile/domain/use_cases/update_profile.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/utils/nullable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

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
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._appManagerCubit,
    this._updateProfileUsecase,
    this._prefsRepository,
  ) : super(ProfileState()) {
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangeProfileImage>(_onChangeProfileImage);
  }

  final AppManagerCubit _appManagerCubit;
  final PrefsRepository _prefsRepository;
  final UpdateProfileUsecase _updateProfileUsecase;

  // Form Keys
  //{
  final String kFromName = 'name';
  final String kFromPhone = 'phone';
  final String kFromEmail = 'email';
  final String kFromCountryCode = 'countryCode';
  static final initCountry = CountryParser.parsePhoneCode('966');

  // final String kFromCity = 'city';
  //}
  // profileForm
  late FormGroup profileForm;

  @override
  Future<void> close() {
    GetIt.I.resetLazySingleton<ProfileBloc>();
    return super.close();
  }

  FutureOr<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(updateProfileStatus: const BlocStatus.loading()));

      if (profileForm.invalid) {
        profileForm.markAllAsTouched();
        emit(state.copyWith(
            updateProfileStatus: const BlocStatus.fail(error: "fail")));
        return;
      }
      final result = await _updateProfileUsecase(UpdateProfileParams(
        email: profileForm.control(kFromEmail).value,
        displayName: profileForm.control(kFromName).value,
        phoneNumber: profileForm.control(kFromPhone).value,
        avatar: state.selectedFile,
      ));
      result.fold(
        (exception, message) => emit(state.copyWith(
            updateProfileStatus: BlocStatus.fail(error: message))),
        (value) async {
          emit(state.copyWith(
            updateProfileStatus: const BlocStatus.success(),
            selectedFile: const Nullable.value(null),
          ));

          String? phoneNumber;
          // Get user data from Supabase
          final userData = await Supabase.instance.client
              .from('users')
              .select('phone_number')
              .eq('id', value.id)
              .maybeSingle();

          phoneNumber = userData?['phone_number'] as String?;
          
          // Save updated user to preferences
          await _prefsRepository.setUser(value, phoneNumber ?? "");
          
          // Force UI update by checking user again
          _appManagerCubit.checkUser();
          
          // Show success message
          showMessage(tr(LocaleKeys.dataHasBeenModifiedSuccessfully),
              isSuccess: true);
          
          // Pop the edit screen
          GRouter.router.pop();
        },
      );
    } catch (exp) {
      emit(state.copyWith(
          updateProfileStatus: const BlocStatus.fail(error: "fail")));
    }
  }

  FutureOr<void> _onChangeProfileImage(
      ChangeProfileImage event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedFile: Nullable.value(event.file)));
  }
}

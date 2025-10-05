import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/features/auth/data/models/local_user.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/utils/nullable.dart';
import '../../domin/repositories/prefs_repository.dart';

part 'app_manager_state.dart';

@singleton
class AppManagerCubit extends Cubit<AppManagerState> {
  AppManagerCubit(this._prefsRepository)
      : super(AppManagerState(
            lightThemeData: ThemeData.light(),
            darkThemeData: ThemeData.dark()));

  final PrefsRepository _prefsRepository;

  changeAppTheme(BuildContext context) {
    emit(state.copyWith(
      darkThemeData: AppTheme.dark(context),
      lightThemeData: AppTheme.light(context),
    ));
  }

  bool get isRegisteredCustomer => _prefsRepository.registeredUser;
  void checkUser() {
    final user = _prefsRepository.user;

    emit(state.copyWith(user: Nullable.value(user)));
  }
}

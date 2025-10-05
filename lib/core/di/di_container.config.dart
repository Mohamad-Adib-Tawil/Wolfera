// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i6;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import '../../features/app/data/repository/prefs_repository_impl.dart' as _i18;
import '../../features/app/domin/repositories/prefs_repository.dart' as _i17;
import '../../features/app/presentation/bloc/app_manager_cubit.dart' as _i21;
import '../../features/auth/data/data_sources/auth_datasource.dart' as _i20;
import '../../features/auth/domain/use_cases/login_usecase.dart' as _i27;
import '../../features/auth/domain/use_cases/logout_usecase.dart' as _i25;
import '../../features/auth/domain/use_cases/register_usecase.dart' as _i26;
import '../../features/auth/domain/use_cases/reset_password_usecase.dart'
    as _i29;
import '../../features/auth/domain/use_cases/verification_usecase.dart' as _i28;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i30;
import '../../features/chat/presentation/manager/chat_bloc.dart' as _i9;
import '../../features/home/data/datasources/home_datasource.dart' as _i22;
import '../../features/home/presentation/manager/home_cubit/home_cubit.dart'
    as _i8;
import '../../features/my_car/data/data_sources/my_car_datasouce.dart' as _i4;
import '../../features/my_car/domain/usecases/sell_my_car_usecase.dart' as _i13;
import '../../features/my_car/presentation/manager/my_cars_bloc.dart' as _i19;
import '../../features/notifications/data/datasources/notifications_datasource.dart'
    as _i23;
import '../../features/profile/data/data_sources/profile_datasource.dart'
    as _i5;
import '../../features/profile/domain/use_cases/update_profile.dart' as _i11;
import '../../features/profile/presentation/manager/profile_bloc.dart' as _i24;
import '../../features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart'
    as _i12;
import '../../services/search_and_filters_service.dart' as _i10;
import '../api/client.dart' as _i16;
import '../storage/prefs_repository.dart' as _i14;
import '../storage/prefs_repository_impl.dart' as _i15;
import 'di_container.dart' as _i31;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i3.BaseOptions>(() => appModule.dioOption);
  gh.factory<_i4.MyCarDatasouce>(() => _i4.MyCarDatasouce());
  gh.factory<_i5.ProfileDatasource>(() => _i5.ProfileDatasource());
  gh.singleton<_i6.Logger>(() => appModule.logger);
  await gh.singletonAsync<_i7.SharedPreferences>(
    () => appModule.sharedPreferences(),
    preResolve: true,
  );
  gh.lazySingleton<_i8.HomeCubit>(() => _i8.HomeCubit());
  gh.lazySingleton<_i9.ChatBloc>(() => _i9.ChatBloc());
  gh.lazySingleton<_i10.SearchFilterService>(() => _i10.SearchFilterService());
  gh.factory<_i11.UpdateProfileUsecase>(
      () => _i11.UpdateProfileUsecase(gh<_i5.ProfileDatasource>()));
  gh.lazySingleton<_i12.SearchCubit>(
      () => _i12.SearchCubit(gh<_i10.SearchFilterService>()));
  gh.lazySingleton<_i3.Dio>(() => appModule.dio(
        gh<_i3.BaseOptions>(),
        gh<_i6.Logger>(),
      ));
  gh.factory<_i13.SellMyCarUsecase>(
      () => _i13.SellMyCarUsecase(gh<_i4.MyCarDatasouce>()));
  gh.factory<_i14.PrefsRepository>(
      () => _i15.PrefsRepositoryImpl(gh<_i7.SharedPreferences>()));
  gh.factory<_i16.ClientApi>(() => _i16.ClientApi(gh<_i3.Dio>()));
  gh.factory<_i17.PrefsRepository>(
      () => _i18.PrefsRepositoryImpl(gh<_i7.SharedPreferences>()));
  gh.lazySingleton<_i19.MyCarsBloc>(
      () => _i19.MyCarsBloc(gh<_i13.SellMyCarUsecase>()));
  gh.factory<_i20.AuthDatasource>(
      () => _i20.AuthDatasource(gh<_i17.PrefsRepository>()));
  gh.singleton<_i21.AppManagerCubit>(
      () => _i21.AppManagerCubit(gh<_i17.PrefsRepository>()));
  gh.factory<_i22.HomeDatasource>(
      () => _i22.HomeDatasource(clientApi: gh<_i16.ClientApi>()));
  gh.factory<_i23.NotificationsDatasource>(
      () => _i23.NotificationsDatasource(clientApi: gh<_i16.ClientApi>()));
  gh.lazySingleton<_i24.ProfileBloc>(() => _i24.ProfileBloc(
        gh<_i21.AppManagerCubit>(),
        gh<_i11.UpdateProfileUsecase>(),
        gh<_i17.PrefsRepository>(),
      ));
  gh.factory<_i25.LogoutUsecase>(
      () => _i25.LogoutUsecase(source: gh<_i20.AuthDatasource>()));
  gh.factory<_i26.RegisterUsecase>(
      () => _i26.RegisterUsecase(gh<_i20.AuthDatasource>()));
  gh.factory<_i27.LoginUsecase>(
      () => _i27.LoginUsecase(gh<_i20.AuthDatasource>()));
  gh.factory<_i28.VerificationUsecase>(
      () => _i28.VerificationUsecase(gh<_i20.AuthDatasource>()));
  gh.factory<_i29.ResetPasswordUsecase>(
      () => _i29.ResetPasswordUsecase(gh<_i20.AuthDatasource>()));
  gh.lazySingleton<_i30.AuthBloc>(() => _i30.AuthBloc(
        gh<_i26.RegisterUsecase>(),
        gh<_i27.LoginUsecase>(),
        gh<_i25.LogoutUsecase>(),
        gh<_i28.VerificationUsecase>(),
        gh<_i29.ResetPasswordUsecase>(),
        gh<_i21.AppManagerCubit>(),
        gh<_i17.PrefsRepository>(),
        gh<_i20.AuthDatasource>()
      ));
  return getIt;
}

class _$AppModule extends _i31.AppModule {}

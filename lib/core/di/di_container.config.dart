// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/app/data/repository/prefs_repository_impl.dart' as _i210;
import '../../features/app/domin/repositories/prefs_repository.dart' as _i483;
import '../../features/app/presentation/bloc/app_manager_cubit.dart' as _i224;
import '../../features/auth/data/data_sources/auth_datasource.dart' as _i419;
import '../../features/auth/domain/use_cases/google_login_usecase.dart' as _i7;
import '../../features/auth/domain/use_cases/login_usecase.dart' as _i1012;
import '../../features/auth/domain/use_cases/logout_usecase.dart' as _i844;
import '../../features/auth/domain/use_cases/register_usecase.dart' as _i957;
import '../../features/auth/domain/use_cases/reset_password_usecase.dart'
    as _i348;
import '../../features/auth/domain/use_cases/verification_usecase.dart'
    as _i438;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chat/presentation/manager/chat_bloc.dart' as _i243;
import '../../features/chat/presentation/manager/chat_cubit.dart' as _i770;
import '../../features/home/data/datasources/home_datasource.dart' as _i1055;
import '../../features/home/presentation/manager/home_cubit/home_cubit.dart'
    as _i535;
import '../../features/my_car/data/data_sources/my_car_datasouce.dart' as _i533;
import '../../features/my_car/domain/usecases/sell_my_car_usecase.dart'
    as _i531;
import '../../features/my_car/presentation/manager/my_cars_bloc.dart' as _i139;
import '../../features/notifications/data/datasources/notifications_datasource.dart'
    as _i200;
import '../../features/profile/data/data_sources/profile_datasource.dart'
    as _i665;
import '../../features/profile/domain/use_cases/update_profile.dart' as _i308;
import '../../features/profile/presentation/manager/profile_bloc.dart' as _i750;
import '../../features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart'
    as _i761;
import '../../services/chat_service.dart' as _i207;
import '../../services/search_and_filters_service.dart' as _i749;
import '../api/client.dart' as _i265;
import '../storage/prefs_repository.dart' as _i866;
import '../storage/prefs_repository_impl.dart' as _i1072;
import 'di_container.dart' as _i198;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i361.BaseOptions>(() => appModule.dioOption);
  gh.factory<_i533.MyCarDatasouce>(() => _i533.MyCarDatasouce());
  gh.factory<_i665.ProfileDatasource>(() => _i665.ProfileDatasource());
  gh.singleton<_i974.Logger>(() => appModule.logger);
  await gh.singletonAsync<_i460.SharedPreferences>(
    () => appModule.sharedPreferences(),
    preResolve: true,
  );
  gh.lazySingleton<_i535.HomeCubit>(() => _i535.HomeCubit());
  gh.lazySingleton<_i243.ChatBloc>(() => _i243.ChatBloc());
  gh.lazySingleton<_i207.ChatService>(() => _i207.ChatService());
  gh.lazySingleton<_i749.SearchFilterService>(
      () => _i749.SearchFilterService());
  gh.factory<_i308.UpdateProfileUsecase>(
      () => _i308.UpdateProfileUsecase(gh<_i665.ProfileDatasource>()));
  gh.factory<_i531.SellMyCarUsecase>(
      () => _i531.SellMyCarUsecase(gh<_i533.MyCarDatasouce>()));
  gh.lazySingleton<_i761.SearchCubit>(
      () => _i761.SearchCubit(gh<_i749.SearchFilterService>()));
  gh.lazySingleton<_i361.Dio>(() => appModule.dio(
        gh<_i361.BaseOptions>(),
        gh<_i974.Logger>(),
      ));
  gh.lazySingleton<_i770.ChatCubit>(
      () => _i770.ChatCubit(gh<_i207.ChatService>()));
  gh.lazySingleton<_i139.MyCarsBloc>(
      () => _i139.MyCarsBloc(gh<_i531.SellMyCarUsecase>()));
  gh.factory<_i866.PrefsRepository>(
      () => _i1072.PrefsRepositoryImpl(gh<_i460.SharedPreferences>()));
  gh.factory<_i483.PrefsRepository>(
      () => _i210.PrefsRepositoryImpl(gh<_i460.SharedPreferences>()));
  gh.factory<_i265.ClientApi>(() => _i265.ClientApi(gh<_i361.Dio>()));
  gh.factory<_i419.AuthDatasource>(
      () => _i419.AuthDatasource(gh<_i483.PrefsRepository>()));
  gh.singleton<_i224.AppManagerCubit>(
      () => _i224.AppManagerCubit(gh<_i483.PrefsRepository>()));
  gh.factory<_i1055.HomeDatasource>(
      () => _i1055.HomeDatasource(clientApi: gh<_i265.ClientApi>()));
  gh.factory<_i200.NotificationsDatasource>(
      () => _i200.NotificationsDatasource(clientApi: gh<_i265.ClientApi>()));
  gh.factory<_i957.RegisterUsecase>(
      () => _i957.RegisterUsecase(gh<_i419.AuthDatasource>()));
  gh.factory<_i1012.LoginUsecase>(
      () => _i1012.LoginUsecase(gh<_i419.AuthDatasource>()));
  gh.factory<_i7.GoogleLoginUsecase>(
      () => _i7.GoogleLoginUsecase(gh<_i419.AuthDatasource>()));
  gh.factory<_i438.VerificationUsecase>(
      () => _i438.VerificationUsecase(gh<_i419.AuthDatasource>()));
  gh.factory<_i348.ResetPasswordUsecase>(
      () => _i348.ResetPasswordUsecase(gh<_i419.AuthDatasource>()));
  gh.lazySingleton<_i750.ProfileBloc>(() => _i750.ProfileBloc(
        gh<_i224.AppManagerCubit>(),
        gh<_i308.UpdateProfileUsecase>(),
        gh<_i483.PrefsRepository>(),
      ));
  gh.factory<_i844.LogoutUsecase>(
      () => _i844.LogoutUsecase(source: gh<_i419.AuthDatasource>()));
  gh.lazySingleton<_i797.AuthBloc>(() => _i797.AuthBloc(
        gh<_i957.RegisterUsecase>(),
        gh<_i1012.LoginUsecase>(),
        gh<_i844.LogoutUsecase>(),
        gh<_i438.VerificationUsecase>(),
        gh<_i348.ResetPasswordUsecase>(),
        gh<_i224.AppManagerCubit>(),
        gh<_i483.PrefsRepository>(),
        gh<_i419.AuthDatasource>(),
      ));
  return getIt;
}

class _$AppModule extends _i198.AppModule {}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/shimmer_loading.dart';
import 'package:wolfera/services/firebase_service.dart';
import '../../../../common/constants/constants.dart';
import '../../../../core/config/routing/router.dart';
import '../../../../core/config/theme/app_theme.dart';
import '../../../../services/language_service.dart';
import '../../../../services/service_provider.dart';
import '../bloc/app_manager_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: designSize,
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: ServiceProvider(
          child: BlocBuilder<AppManagerCubit, AppManagerState>(
            builder: (context, state) {
              LanguageService(context);
              return const _AppRoute();
            },
          ),
        ),
      ),
    );
  }
}

class _AppRoute extends StatefulWidget {
  const _AppRoute();

  @override
  State<_AppRoute> createState() => _AppRouteState();
}

class _AppRouteState extends State<_AppRoute> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: MaterialApp.router(
        title: "wolfera Cars",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(context),
        darkTheme: AppTheme.dark(context),
        routerConfig: GRouter.router,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                context.locale.languageCode == 'ar' ? 0.85 : 1.0,
              ),
            ),
            child: EasyLoading.init()(context, child),
          );
        },
      ),
    );
  }
}

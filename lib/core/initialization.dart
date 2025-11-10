import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wolfera/core/models/localization_config.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/app_settings_service.dart';
import 'di/di_container.dart';

Future<void> initialization(
  FutureOr<Widget> Function() builder, {
  LocalizationConfig? localizationConfig,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Ensure FavoriteCubit is available via GetIt for cross-feature refreshes
  final getIt = GetIt.I;
  if (!getIt.isRegistered<FavoriteCubit>()) {
    getIt.registerLazySingleton<FavoriteCubit>(() => FavoriteCubit());
  }
  await AppService.initializeApp();
  
  // تحميل إعدادات التطبيق مرة واحدة عند البدء (مثل إخفاء سوريا)
  await AppSettingsService.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // if (kDebugMode) {
  //   try {
  //     final emulatorHost = defaultTargetPlatform == TargetPlatform.android
  //         ? "10.0.2.2"
  //         : "localhost";
  //     FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
  //     FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  final Widget app;
  if (localizationConfig != null) {
    app = await _easyLocalization(builder, localizationConfig);
  } else {
    app = await builder();
  }

  runApp(app);
}

Future<EasyLocalization> _easyLocalization(
  FutureOr<Widget> Function() builder,
  LocalizationConfig localizationConfig,
) async {
  await EasyLocalization.ensureInitialized();
  String systemLanguageCode =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  return EasyLocalization(
    supportedLocales: localizationConfig.supportedLocales,
    useOnlyLangCode: localizationConfig.useOnlyLangCode,
    saveLocale: localizationConfig.saveLocale,
    startLocale: localizationConfig.startLocale,
    fallbackLocale: systemLanguageCode == "en" || systemLanguageCode == "ar"
        ? Locale(systemLanguageCode)
        : const Locale('en'),
    useFallbackTranslations: localizationConfig.useFallbackTranslations,
    path: localizationConfig.path,
    child: await builder(),
  );
}

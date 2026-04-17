import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:wolfera/core/models/localization_config.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../services/firebase_service.dart';
import '../services/app_settings_service.dart';
import 'di/di_container.dart';

Future<void> initialization(
  FutureOr<Widget> Function() builder, {
  LocalizationConfig? localizationConfig,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final getIt = GetIt.I;
  if (!getIt.isRegistered<FavoriteCubit>()) {
    getIt.registerLazySingleton<FavoriteCubit>(() => FavoriteCubit());
  }
  await AppService.initializeApp();
  // Configure Firebase Crashlytics. Keep debug logs clean and avoid reporting
  // transient auth/network retries as fatal crashes.
  try {
    if (Firebase.apps.isNotEmpty) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        _recordFlutterError(details);
      };
    }
  } catch (_) {}

  await AppSettingsService.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final Widget app;
  if (localizationConfig != null) {
    app = await _easyLocalization(builder, localizationConfig);
  } else {
    app = await builder();
  }

  // تجنب Zone mismatch: يجب أن يكون ensureInitialized و runApp في نفس الـ zone.
  // لالتقاط أخطاء async غير المعالجة نستخدم PlatformDispatcher بدل runZonedGuarded.
  if (Firebase.apps.isNotEmpty) {
    ui.PlatformDispatcher.instance.onError = (error, stack) {
      _recordPlatformError(error, stack);
      return true;
    };
  }

  runApp(app);
}

void _recordFlutterError(FlutterErrorDetails details) {
  if (kDebugMode || _isRecoverableRuntimeError(details.exception)) return;

  try {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  } catch (_) {}
}

void _recordPlatformError(Object error, StackTrace stack) {
  if (kDebugMode || _isRecoverableRuntimeError(error)) return;

  try {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  } catch (_) {}
}

bool _isRecoverableRuntimeError(Object error) {
  final message = error.toString();
  return message.contains('AuthRetryableFetchException') ||
      message.contains('SocketException') ||
      message.contains('Failed host lookup');
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

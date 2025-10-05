class RouterConfiguration {
  RouterConfiguration.init();

  final String krpRoot = '/';
  final String krpOnboardingRoutePath = '/onboarding';
  final mainRoutes = const _MainRoutes._();
  final homeRoutes = const _HomeRoutes._();
  final carRoutes = const _CarRoutes._();
  final filterRoutes = const _FilterRoutes._();
  final myCarsRoutes = const _MyCarsRoutes._();
  final profileRoutes = const _ProfileRoutes._();
  final authRoutes = const _AuthRoutes._();
  final notificationsRoutes = const _NotificationsRoutes._();
  final settingsRoutes = const _SettingsRoutes._();
  final chatsRoutes = const _ChatsRoutes._();
}

class _MainRoutes {
  const _MainRoutes._();
  final String home = '/home';
  final String search = '/search';
  final String myCars = '/myCars';
  final String favorites = '/favorites';
  final String messagesBasePage = '/messagesBasePage';
}

class _HomeRoutes {
  const _HomeRoutes._();

  final String carDetails = 'carDetails';
}

class _FilterRoutes {
  const _FilterRoutes._();

  final String filter = 'filter';
}

class _CarRoutes {
  const _CarRoutes._();

  final String carImagesPreviewer = 'carDetails/carImagesPreviewer';
}

class _ProfileRoutes {
  const _ProfileRoutes._();
  final String profile = '/profile';
  final String profileEdit = 'profileEdit';
  final String addressPage = 'addressPage';
}

class _NotificationsRoutes {
  const _NotificationsRoutes._();

  final String notifications = '/notifications';
}

class _SettingsRoutes {
  const _SettingsRoutes._();

  final String settings = '/settings';
  final String privacyPolicy = 'privacyPolicy';
  final String aboutUs = 'aboutUs';
}

class _AuthRoutes {
  const _AuthRoutes._();

  final String loginPage = '/loginPage';
  final String signupPage = '/signupPage';
  final String confirmAccountPage = '/confirmAccountPage';
  final String congratsPage = '/congratsPage';
  final String resetPasswordPage = '/resetPasswordPage';
  final String selectCountryPage = '/selectCountryPage';
}

class _MyCarsRoutes {
  const _MyCarsRoutes._();
  final String sellMyCarPage = 'sellMyCarPage';
  final String congratulationsPage = 'CongratulationsPage';
}

class _ChatsRoutes {
  const _ChatsRoutes._();
  final String chatPage = 'chatPage';
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/routing/router_config.dart';
import 'package:wolfera/features/app/presentation/pages/splash_page.dart';
import 'package:wolfera/features/cars/presentation/pages/car_details_page.dart';
import 'package:wolfera/features/cars/presentation/pages/car_images_previewer.dart';
import 'package:wolfera/features/chat/presentation/pages/messages_base_page.dart';
import 'package:wolfera/features/my_car/presentation/pages/congratulations_page.dart';
import 'package:wolfera/features/my_car/presentation/pages/sell_my_car_page.dart';
import 'package:wolfera/features/search_and_filteration/presentation/pages/filter_page.dart';
import 'package:wolfera/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:wolfera/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:wolfera/features/profile/presentation/pages/about_us_page.dart';
import 'package:wolfera/features/app/presentation/pages/error_page.dart';
import 'package:wolfera/features/app/presentation/widgets/onboarding_widget.dart';
import 'package:wolfera/features/auth/presentation/pages/congrate_page.dart';
import 'package:wolfera/features/auth/presentation/pages/login_page.dart';
import 'package:wolfera/features/auth/presentation/pages/reset_password_page.dart';
import 'package:wolfera/features/auth/presentation/pages/select_country_page.dart';
import 'package:wolfera/features/auth/presentation/pages/sigup_page.dart';
import 'package:wolfera/features/home/presentation/pages/home_page.dart';
import 'package:wolfera/features/search_and_filteration/presentation/pages/search_page.dart';
import 'package:wolfera/features/chat/presentation/pages/chat_page.dart';
import 'package:wolfera/features/faviorate/presentation/pages/faviorate_page.dart';
import 'package:wolfera/features/my_car/presentation/pages/my_cars_page.dart';
import 'package:wolfera/features/notifications/presentation/pages/notifications_page.dart';
import 'package:wolfera/features/profile/presentation/pages/profile_page.dart';

import '../../../features/app/presentation/pages/base_page.dart';

class GRouter {
  static GRouter? _instance;

  factory GRouter() => _instance ??= GRouter();

  static GoRouter get router => _router;

  static RouterConfiguration get config => _config;

  static final RouterConfiguration _config = RouterConfiguration.init();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: _config.krpRoot,
        name: _config.krpRoot,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const SplashScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.krpOnboardingRoutePath,
        name: _config.krpOnboardingRoutePath,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const OnboardingPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.authRoutes.loginPage,
        name: _config.authRoutes.loginPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const LoginPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.authRoutes.signupPage,
        name: _config.authRoutes.signupPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const SingUpPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.authRoutes.resetPasswordPage,
        name: _config.authRoutes.resetPasswordPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const ResetPassword(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.authRoutes.selectCountryPage,
        name: _config.authRoutes.selectCountryPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const SelectCountyPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.authRoutes.congratsPage,
        name: _config.authRoutes.congratsPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const CongratsPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: _config.notificationsRoutes.notifications,
        name: _config.notificationsRoutes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _builderPage(
            child: const NotificationsPage(),
            state: state,
          );
        },
      ),
      GoRoute(
          path: _config.profileRoutes.profile,
          name: _config.profileRoutes.profile,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _builderPage(
              child: const ProfilePage(),
              state: state,
            );
          },
          routes: [
            GoRoute(
              path: _config.profileRoutes.profileEdit,
              name: _config.profileRoutes.profileEdit,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return _builderPage(
                  child: const EditProfilePage(),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: _config.profileRoutes.addressPage,
              name: _config.profileRoutes.addressPage,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return _builderPage(
                  child: SelectCountyPage(
                    country: state.extra as String,
                  ),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: _config.settingsRoutes.privacyPolicy,
              name: _config.settingsRoutes.privacyPolicy,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return _builderPage(
                  child: const PrivacyPolicy(),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: _config.settingsRoutes.aboutUs,
              name: _config.settingsRoutes.aboutUs,
              parentNavigatorKey: _rootNavigatorKey,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return _builderPage(
                  child: const AboutUsPage(),
                  state: state,
                );
              },
            ),
          ]),
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: _config.mainRoutes.home,
                name: _config.mainRoutes.home,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return _builderPage(
                    child: const HomePage(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    path: _config.homeRoutes.carDetails,
                    name: _config.homeRoutes.carDetails,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final carData = state.extra as Map<String, dynamic>?;
                      return CustomTransitionPage(
                        transitionDuration: const Duration(milliseconds: 200),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 200),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                        child: CarDetailsPage(carData: carData),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _config.carRoutes.carImagesPreviewer,
                        name: _config.carRoutes.carImagesPreviewer,
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final extra = state.extra as Map<String, dynamic>?;
                          final images = (extra?['images'] as List?)
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              const <String>[];
                          final initialIndex = extra?['initialIndex'] as int? ?? 0;
                          return _builderPage(
                            child: CarImagesPreviewer(
                              images: images,
                              initialIndex: initialIndex,
                            ),
                            state: state,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: _config.mainRoutes.search,
                  name: _config.mainRoutes.search,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return _builderPage(
                      child: const SearchPage(),
                      state: state,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: _config.filterRoutes.filter,
                      name: _config.filterRoutes.filter,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return _builderPage(
                          child: const FilterPage(),
                          state: state,
                        );
                      },
                    )
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: _config.mainRoutes.myCars,
                  name: _config.mainRoutes.myCars,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return _builderPage(
                      child: const MyCarsPage(),
                      state: state,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: _config.myCarsRoutes.sellMyCarPage,
                      name: _config.myCarsRoutes.sellMyCarPage,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return _builderPage(
                          child: const SellMyCarPage(),
                          state: state,
                        );
                      },
                    ),
                    GoRoute(
                      path: _config.myCarsRoutes.congratulationsPage,
                      name: _config.myCarsRoutes.congratulationsPage,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return _builderPage(
                          child: const CongratulationsPage(),
                          state: state,
                        );
                      },
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: _config.mainRoutes.favorites,
                name: _config.mainRoutes.favorites,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return _builderPage(
                    child: const FavioratePage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: _config.mainRoutes.messagesBasePage,
                name: _config.mainRoutes.messagesBasePage,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return _builderPage(
                    child: const MessagesBasePage(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    path: _config.chatsRoutes.chatPage,
                    name: _config.chatsRoutes.chatPage,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return _builderPage(
                        child: const ChatPage(),
                        state: state,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) =>
            BasePage(child: navigationShell),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(exception: state.error),
  );

  static Page<dynamic> _builderPage<T>(
      {required Widget child, required GoRouterState state}) {
    if (Platform.isIOS) {
      return CupertinoPage<T>(child: child, key: state.pageKey);
    } else {
      return MaterialPage<T>(child: child, key: state.pageKey);
    }
  }
}

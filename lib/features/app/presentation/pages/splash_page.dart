import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double ballY = 0;
  double widthVal = 50;
  double heightVal = 50;
  double bottomVal = 500;
  bool add = false;
  bool showShadow = false;
  int times = 0;
  bool showComic = false;

  late AnimationController _controller;
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(
            () {
              if (_isMounted) {
                setState(() {
                  if (add) {
                    ballY += 15;
                  } else {
                    ballY -= 15;
                  }
                  if (ballY <= -200) {
                    times += 1;
                    add = true;
                    showShadow = true;
                  }
                  if (ballY >= 0) {
                    add = false;
                    showShadow = false;
                    widthVal += 50;
                    heightVal += 50;
                    bottomVal -= 200;
                  }
                  if (times == 3) {
                    showShadow = false;
                    widthVal = 1.sw;
                    heightVal = 1.sh;
                    Timer(const Duration(milliseconds: 300), () {
                      if (_isMounted) {
                        setState(() {
                          showComic = true;
                        });
                      }
                    });
                    _controller.stop();
                  }
                });
              }
            },
          );
    _controller.repeat();

    EasyLoading.instance
      ..userInteractions = false
      ..dismissOnTap = false;

    Timer(
      const Duration(seconds: 3),
      () {
        if (!_isMounted) return;

        final isAuth = GetIt.I<PrefsRepository>().registeredUser;
        final bool isEmailVerified =
            GetIt.I<AppManagerCubit>().state.user?.emailVerified != null;
        if (isAuth && isEmailVerified) {
          GRouter.router.goNamed(GRouter.config.mainRoutes.home);
        } else if (isAuth && !isEmailVerified) {
          EasyLoading.showError(
            "Please verify your email address",
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
          GRouter.router.goNamed(GRouter.config.krpOnboardingRoutePath);
        } else {
          GRouter.router.goNamed(GRouter.config.krpOnboardingRoutePath);
        }
      },
    );
  }

  @override
  void dispose() {
    _isMounted = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              bottom: bottomVal,
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, ballY),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: times == 3 ? 5 : 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: widthVal,
                        height: heightVal,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blackLight),
                      ),
                    ),
                  ),
                  if (showShadow)
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.2),
                          borderRadius: BorderRadius.circular(100)),
                    )
                ],
              ),
            ),
            if (showComic)
              Positioned(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.imagesSplash,
                  ),
                ],
              ))
          ],
        ),
      ),
    ));
  }
}

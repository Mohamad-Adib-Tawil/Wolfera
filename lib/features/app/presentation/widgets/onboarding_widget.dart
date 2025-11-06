import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/language_dropdown.dart';
import 'package:wolfera/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../../../../core/utils/responsive_padding.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackLight,
      body: SafeArea(child: body(context)),
    );
  }

  Widget body(BuildContext context) {
    return BlocProvider.value(
        value: GetIt.I<AuthBloc>(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              Padding(
                padding: HWEdgeInsets.only(right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const LanguageDropdown(),
                  ],
                ),
              ),
              35.verticalSpace,
              Padding(
                padding: HWEdgeInsets.symmetric(horizontal: 28),
                child: Bounce(
                  duration: const Duration(milliseconds: 1300),
                  child: SimpleShadow(
                    color: AppColors.orange,
                    offset: const Offset(0, 4),
                    opacity: 0.2,
                    sigma: 4,
                    child: AppText(
                      LocaleKeys.onboarding_welcomeTowolfera,
                      style: context.textTheme.bodyLarge?.xb.s40
                          .withColor(AppColors.orange),
                    ),
                  ),
                ),
              ),
              60.verticalSpace,
              FadeInLeft(
                duration: const Duration(milliseconds: 1400),
                child: Image.asset(
                  Assets.imagesOnboarding,
                ),
              ),
              70.verticalSpace,
              Padding(
                padding: HWEdgeInsets.symmetric(horizontal: 28),
                child: Bounce(
                  child: AppText(
                    LocaleKeys.onboarding_buyAndSellCarsEffortlessly,
                    style: context.textTheme.headlineMedium?.xb
                        .withColor(AppColors.orange),
                  ),
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: HWEdgeInsetsDirectional.only(start: 5),
                child: ShakeX(
                  duration: const Duration(milliseconds: 1300),
                  child: AppText(
                    LocaleKeys.onboarding_YourPerfectRideisJustATapAway,
                    style: context.textTheme.bodyLarge?.s20.sb,
                  ),
                ),
              ),
              25.verticalSpace,
              FadeInDownBig(
                curve: Curves.easeOut,
                child: AppElevatedButton(
                  appButtonStyle: AppButtonStyle.primary,
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.white),
                      minimumSize: WidgetStatePropertyAll(Size(319.w, 54.h))),
                  onPressed: () =>
                      context.push(GRouter.config.authRoutes.signupPage),
                  text: LocaleKeys.auth_createAccount,
                  textStyle: context.textTheme.titleLarge.xb
                      .withColor(AppColors.blackLight),
                ),
              ),
              20.verticalSpace,
              FadeInDownBig(
                curve: Curves.easeOut,
                child: AppElevatedButton(
                  appButtonStyle: AppButtonStyle.primary,
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.white),
                      minimumSize: WidgetStatePropertyAll(Size(319.w, 54.h))),
                  onPressed: () =>
                      context.push(GRouter.config.authRoutes.loginPage),
                  text: LocaleKeys.auth_login,
                  textStyle: context.textTheme.titleLarge.xb
                      .withColor(AppColors.blackLight),
                ),
              ),
            ],
          ),
        ));
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_button_with_icon.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_textfeild.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:wolfera/services/language_service.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = true;
  late AuthBloc _authBloc;
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    _authBloc = GetIt.I<AuthBloc>();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Padding(
        padding:
            HWEdgeInsets.only(top: 20, right: 40, left: 40, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            45.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: SimpleShadow(
                color: AppColors.black,
                opacity: 0.15,
                offset: const Offset(0, 4),
                sigma: 4,
                child: AppText(LocaleKeys.auth_login,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall.xb),
              ),
            ),
            120.verticalSpace,
            CustomTextField(
              hint: "Enter email",
              formControlName: _authBloc.kFromEmail,
              textInputAction: TextInputAction.next,
              prefixIcon: const AppSvgPicture(
                Assets.svgEmail,
              ),
            ),
            30.verticalSpace,
            CustomTextField(
              hint: LocaleKeys.enterPasswordHint,
              isObscureText: true,
              formControlName: _authBloc.kFromPassword,
              prefixIcon: const AppSvgPicture(
                Assets.svgLock,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (control) => _onLogin(),
            ),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => setState(() {
                    isChecked = !isChecked;
                  }),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        origin: Offset.zero,
                        alignment: Alignment.centerLeft,
                        scaleX: 0.9,
                        scaleY: 0.8,
                        child: Checkbox(
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          splashRadius: 0,
                          checkColor: AppColors.white,
                          fillColor: const WidgetStatePropertyAll(
                              AppColors.primary),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(4).r),
                          value: isChecked,
                          activeColor: AppColors.primary,
                          onChanged: (newBool) => setState(() {
                            isChecked = newBool!;
                          }),
                        ),
                      ),
                      AppText(LocaleKeys.auth_rememberMe,
                          style: context.textTheme.bodySmall!.s14.m),
                    ],
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(
                      overlayColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                  onPressed: () => GoRouter.of(context)
                      .push(GRouter.config.authRoutes.resetPasswordPage),
                  child: AppText(LocaleKeys.auth_forgetPassword,
                      style: context.textTheme.bodySmall!.s14.m),
                ),
              ],
            ),
            45.verticalSpace,
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return SizedBox(
                  width: 351.w,
                  height: 54.h,
                  child: AppElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5).r)),
                        textStyle: WidgetStatePropertyAll(
                          context.textTheme.bodyMedium!.s20.b
                              .withColor(AppColors.blackLight),
                        ),
                        backgroundColor:
                            const WidgetStatePropertyAll(AppColors.white)),
                    text: LocaleKeys.auth_login,
                    isLoading: state.loginStatus.isLoading(),
                    onPressed: _onLogin,
                  ),
                );
              },
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2.h,
                    color: AppColors.grey,
                  ),
                ),
                5.horizontalSpace,
                AppText(
                  "OR",
                  style:
                      context.textTheme.bodyMedium.b.withColor(AppColors.grey),
                ),
                5.horizontalSpace,
                Expanded(
                  child: Container(
                    height: 2.h,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            CustomButtonWithIcon(
              text: "تسجيل الدخول بـ Google".tr(),
              icon: Assets.svgGoogle,
              onTap: _onGoogleLogin,
            ),
            45.verticalSpace,
            InkWell(
              overlayColor:
                  const WidgetStatePropertyAll(Colors.transparent),
              onTap: () => GRouter.router
                  .pushReplacement(GRouter.config.authRoutes.signupPage),
              child: Row(
                textDirection: LanguageService.textDirection,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Don't have an account?",
                    style: context.textTheme.titleMedium!.b
                        .withColor(AppColors.whiteLess),
                  ),
                  8.horizontalSpace,
                  AppText(
                    "Sign Up",
                    style: context.textTheme.titleMedium!.b
                        .withColor(AppColors.orange),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return BlocProvider.value(
      value: _authBloc,
      child: SafeArea(
        child: Scaffold(
          body: ReactiveForm(
            formGroup: _authBloc.loginForm,
            child: _shouldAnimateEntrance
                ? DelayedFadeSlide(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 1000),
                    beginOffset: const Offset(-0.24, 0),
                    child: content,
                  )
                : content,
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    // GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);

    FocusScope.of(context).unfocus();
    _authBloc.add(LoginEvent(
      onSuccess: (user) async {
        final bool isUserVerified = user.emailConfirmedAt != null;
        if (isUserVerified) {
          GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
        } else {
          EasyLoading.showToast(
            "Verify was sent, Please Check your email to verify",
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
          _authBloc.add(const VerificationEvent());

          // if (isVerified == true) {
          //   // await GetIt.I<PrefsRepository>().setCustomer(user.copyWith(
          //   //     customer:
          //   //         user.customer.copyWith(phoneVerifiedAt: DateTime.now())));
          //   GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
          // }
        }
      },
    ));
  }

  void _onGoogleLogin() {
    FocusScope.of(context).unfocus();
    _authBloc.add(GoogleLoginEvent(
      onSuccess: (user) async {
        final bool isUserVerified = user.emailConfirmedAt != null;
        if (isUserVerified) {
          GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
        } else {
          EasyLoading.showToast(
            "Welcome! Please complete your profile",
            duration: const Duration(seconds: 4),
            dismissOnTap: true,
          );
          GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
        }
      },
    ));
  }
}

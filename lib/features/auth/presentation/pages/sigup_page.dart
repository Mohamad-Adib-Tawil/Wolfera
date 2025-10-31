import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_button_with_icon.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_textfeild.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/services/language_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../../../../generated/locale_keys.g.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/phone_text_field.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({
    super.key,
  });

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
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
            HWEdgeInsets.only(top: 20, right: 26, left: 26, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: SimpleShadow(
                color: AppColors.black,
                opacity: 0.15,
                offset: const Offset(0, 4),
                sigma: 4,
                child: AppText(LocaleKeys.auth_createAccount,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall.xb),
              ),
            ),
            50.verticalSpace,
            CustomTextField(
              hint: LocaleKeys.enterNameHint,
              formControlName: _authBloc.kFromName,
              textInputAction: TextInputAction.next,
              prefixIcon: const AppSvgPicture(
                Assets.svgPerson,
              ),
            ),
            24.verticalSpace,
            CustomTextField(
              hint: "Enter email",
              formControlName: _authBloc.kFromEmail,
              textInputAction: TextInputAction.next,
              prefixIcon: const AppSvgPicture(
                Assets.svgEmail,
              ),
            ),
            24.verticalSpace,
            PhoneTextField(
              controlName: _authBloc.kFromPhone,
              onSelect: (value) => _authBloc.singUpForm
                  .control(_authBloc.kFromCountryCode)
                  .value = value.phoneCode,
              onInit: (value) => _authBloc.singUpForm
                  .control(_authBloc.kFromCountryCode)
                  .value = value.phoneCode,
            ),
            24.verticalSpace,
            CustomTextField(
              hint: LocaleKeys.enterPasswordHint,
              isObscureText: true,
              formControlName: _authBloc.kFromPassword,
              textInputAction: TextInputAction.next,
              prefixIcon: const AppSvgPicture(
                Assets.svgLock,
              ),
            ),
            24.verticalSpace,
            CustomTextField(
              hint: LocaleKeys.enterConfirmationPasswordHint,
              isObscureText: true,
              formControlName: _authBloc.kFromConfirmationPassword,
              textInputAction: TextInputAction.send,
              prefixIcon: const AppSvgPicture(
                Assets.svgLock,
              ),
              onSubmitted: (control) {
                _onSignUp();
              },
            ),
            30.verticalSpace,
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
                            context.textTheme.bodySmall!.s20.xb
                                .withColor(AppColors.blackLight),
                          ),
                          backgroundColor:
                              const WidgetStatePropertyAll(AppColors.white)),
                      text: LocaleKeys.auth_createAccount,
                      isLoading: state.registerStatus.isLoading(),
                      onPressed: _onSignUp),
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
              text: "Sign up with Google".tr(),
              icon: Assets.svgGoogle,
              onTap: _onGoogleSignUp,
            ),
            20.verticalSpace,
            InkWell(
              overlayColor:
                  const WidgetStatePropertyAll(Colors.transparent),
              onTap: () => GRouter.router
                  .push(GRouter.config.authRoutes.loginPage),
              child: Row(
                textDirection: LanguageService.textDirection,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    LocaleKeys.auth_youAlreadyHaveAnAccount,
                    style: context.textTheme.titleMedium!.b
                        .withColor(AppColors.whiteLess),
                  ),
                  8.horizontalSpace,
                  AppText(
                    LocaleKeys.auth_login,
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
            formGroup: _authBloc.singUpForm,
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

  void _onSignUp() {
    FocusScope.of(context).unfocus();
    _authBloc.add(RegisterEvent(
      onSuccess: () {
        _authBloc.loginForm
          ..control(_authBloc.kFromEmail).value =
              _authBloc.singUpForm.control(_authBloc.kFromEmail).value
          ..control(_authBloc.kFromPassword).value =
              _authBloc.singUpForm.control(_authBloc.kFromPassword).value;
        _authBloc.singUpForm.reset();
        GoRouter.of(context).push(GRouter.config.authRoutes.loginPage);
      },
    ));
  }

  void _onGoogleSignUp() {
    FocusScope.of(context).unfocus();
    _authBloc.add(GoogleLoginEvent(
      onSuccess: (user) async {
        final bool isUserVerified = user.emailConfirmedAt != null;
        if (isUserVerified) {
          GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
        } else {
          showMessage(
            "Welcome! Please complete your profile",
            isSuccess: true,
          );
          GRouter.router.goNamed(GRouter.config.authRoutes.selectCountryPage);
        }
      },
    ));
  }
}

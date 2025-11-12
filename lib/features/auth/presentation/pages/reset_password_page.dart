import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../app/presentation/widgets/app_elvated_button.dart';
import '../../../app/presentation/widgets/app_text.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_textfeild.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
    return BlocProvider.value(
      value: _authBloc,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.h),
            child: _shouldAnimateEntrance
                ? DelayedFadeSlide(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 1000),
                    beginOffset: const Offset(0, -0.24),
                    child: AppBar(
                      toolbarHeight: 90.h,
                      centerTitle: true,
                      title: SimpleShadow(
                        color: AppColors.black,
                        opacity: 0.15,
                        offset: const Offset(0, 4),
                        sigma: 4,
                        child: AppText("Reset Password".tr(),
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall.xb),
                      ),
                      leading: IconButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        icon: Transform.rotate(
                          angle: context.locale.languageCode == 'ar' ? 3.14 : 0,
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: AppColors.white),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      actions: const [],
                    ),
                  )
                : AppBar(
                    toolbarHeight: 90.h,
                    centerTitle: true,
                    title: SimpleShadow(
                      color: AppColors.black,
                      opacity: 0.15,
                      offset: const Offset(0, 4),
                      sigma: 4,
                      child: AppText("Reset Password".tr(),
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineSmall.xb),
                    ),
                    leading: IconButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      icon: Transform.rotate(
                        angle: context.locale.languageCode == 'ar' ? 3.14 : 0,
                        child: const Icon(Icons.arrow_back_ios_rounded,
                            color: AppColors.white),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    actions: const [],
                  ),
          ),
          body: ReactiveForm(
            formGroup: _authBloc.resetPasswordForm,
            child: _shouldAnimateEntrance
                ? DelayedFadeSlide(
                    delay: const Duration(milliseconds: 220),
                    duration: const Duration(milliseconds: 1000),
                    beginOffset: const Offset(-0.24, 0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: HWEdgeInsets.only(
                            top: 125, right: 40, left: 40, bottom: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hint: "enter_email",
                              formControlName: _authBloc.kFromEmail,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const AppSvgPicture(
                                Assets.svgEmail,
                              ),
                            ),
                            200.verticalSpace,
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: 351.w,
                                  height: 54.h,
                                  child: AppElevatedButton(
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5).r)),
                                        textStyle: WidgetStatePropertyAll(
                                          context.textTheme.bodyMedium!.s20.b
                                              .withColor(AppColors.blackLight),
                                        ),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                                AppColors.white)),
                                    text: LocaleKeys.auth_reset,
                                    isLoading:
                                        state.resetPasswordStatus.isLoading(),
                                    onPressed: _onResetPassword,
                                  ),
                                );
                              },
                            ),
                            85.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: HWEdgeInsets.only(
                          top: 125, right: 40, left: 40, bottom: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hint: "enter_email",
                            formControlName: _authBloc.kFromEmail,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const AppSvgPicture(
                              Assets.svgEmail,
                            ),
                          ),
                          200.verticalSpace,
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: 351.w,
                                height: 54.h,
                                child: AppElevatedButton(
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5).r)),
                                      textStyle: WidgetStatePropertyAll(
                                        context.textTheme.bodyMedium!.s20.b
                                            .withColor(AppColors.blackLight),
                                      ),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              AppColors.white)),
                                  text: LocaleKeys.auth_reset,
                                  isLoading:
                                      state.resetPasswordStatus.isLoading(),
                                  onPressed: _onResetPassword,
                                ),
                              );
                            },
                          ),
                          85.verticalSpace,
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _onResetPassword() {
    _authBloc.add(const ResetPasswordEvent());
  }
}

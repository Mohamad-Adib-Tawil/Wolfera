import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CustomLogoutDialog extends StatelessWidget {
  const CustomLogoutDialog({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<AuthBloc>(),
      child: Dialog(
        child: Container(
          width: 500.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(19.2.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    HWEdgeInsets.only(top: 18, bottom: 3, right: 16, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppSvgPicture(
                      Assets.svgLogout,
                      color: AppColors.blackLight,
                    ),
                    10.horizontalSpace,
                    AppText(
                      LocaleKeys.logout,
                      style: context.textTheme.titleMedium?.b.withColor(
                        AppColors.blackLight,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(25.w, 25.h),
                          maximumSize: Size(25.w, 25.h),
                          padding: HWEdgeInsets.all(2),
                          shape: const CircleBorder(),
                          backgroundColor: AppColors.blackLight,
                          side: BorderSide.none),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              AppSvgPicture(
                Assets.imagesSplash,
                width: 285.w,
                fit: BoxFit.contain,
              ),
              31.verticalSpace,
              Padding(
                padding: HWEdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: AppText(
                  textAlign: TextAlign.center,
                  LocaleKeys.areYouSureYouWantToLogout,
                  style: context.textTheme.titleMedium.sb
                      .withColor(AppColors.blackLight),
                ),
              ),
              Padding(
                padding:
                    HWEdgeInsets.only(left: 38, right: 38, bottom: 45, top: 40),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStatePropertyAll(Size(250.w, 50.h)),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 27)),
                        backgroundColor:
                            const MaterialStatePropertyAll(AppColors.primary),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(19.2.r),
                            ),
                          ),
                        ),
                      ),
                      child: AppText(
                        LocaleKeys.noIdoNotWant,
                        style: context.textTheme.bodyMedium.sb
                            .withColor(AppColors.white),
                      ),
                    ),
                    15.verticalSpace,
                    // context.goNamed(GRouter.config.authRoutes.authPage)
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state.logoutStatus.isLoading()) {
                          return const Center(
                            child: AppLoader.spinKitCircle(),
                          );
                        }
                        return TextButton(
                          onPressed: () => GetIt.I<AuthBloc>()
                              .add(LogoutEvent(onSuccess: () async {})),
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStatePropertyAll(Size(250.w, 50.h)),
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 27)),
                            backgroundColor:
                                const MaterialStatePropertyAll(AppColors.white),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                side: BorderSide(
                                    color: AppColors.primary, width: 1.6.w),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(19.2.r),
                                ),
                              ),
                            ),
                          ),
                          child: AppText(
                            LocaleKeys.yesAmSure,
                            style: context.textTheme.bodyMedium.m.withColor(
                              AppColors.blackLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

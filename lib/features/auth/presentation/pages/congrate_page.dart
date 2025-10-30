import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff7fafc),
        body: Padding(
          padding: HWEdgeInsets.only(top: 85, right: 40, left: 40, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SimpleShadow(
                  color: AppColors.black,
                  opacity: 0.15,
                  offset: const Offset(0, 4),
                  sigma: 4,
                  child: AppText(
                    LocaleKeys.auth_confirmed,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall.xb.withColor(
                      AppColors.blackLight.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
              152.verticalSpace,
              AppText(
                LocaleKeys.auth_congratulationsYouCanNowBrowse,
                style: context.textTheme.titleMedium!.r
                    ?.copyWith(color: AppColors.blackLight, fontSize: 19.sp),
                maxLines: 2,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              37.verticalSpace,
              AppSvgPicture(
                Assets.svgStarWithTick,
                height: 122.4.h,
                width: 138.6.w,
              ),
              74.verticalSpace,
              AppElevatedButton(
                onPressed: () =>
                    context.goNamed(GRouter.config.mainRoutes.home),
                text: LocaleKeys.Continue,
                textStyle: context.textTheme.bodyMedium.s18.b
                    .withColor(AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

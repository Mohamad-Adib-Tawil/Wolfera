import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(
          text: LocaleKeys.settingsApp_aboutTheApplication,
          automaticallyImplyLeading: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              'This App Developed by',
              style: context.textTheme.bodyLarge!.s18.xb
                  .withColor(AppColors.white),
            ),
            AppSvgPicture(
              Assets.svgAboutUsArrows,
              height: 175.h,
              width: 175.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SvgPersonWidget(),
                    SizedBox(
                        width: 100.w,
                        child: const NameText(name: 'Mohamad Adib Tawil'))
                  ],
                ),
                60.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SvgPersonWidget(),
                    SizedBox(
                      width: 100.w,
                      child: const NameText(name: 'Mohamad Jrab'),
                  )
                  ],
                )
              ],
            )
          ],
        ));
  }
}

class NameText extends StatelessWidget {
  const NameText({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return AppText(
      name,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge!.s18.xb
          .withColor(AppColors.primary)
          ?.copyWith(letterSpacing: 2),
    );
  }
}

class SvgPersonWidget extends StatelessWidget {
  const SvgPersonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppSvgPicture(
      Assets.svgPerson,
      height: 44.h,
      width: 44.w,
      color: AppColors.primary,
    );
  }
}

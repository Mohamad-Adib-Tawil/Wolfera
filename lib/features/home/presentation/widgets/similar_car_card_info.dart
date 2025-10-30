import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_text_container.dart';
import 'package:wolfera/features/app/presentation/widgets/space_text_widget.dart';
import 'package:wolfera/generated/assets.dart';

class SimilarCarCardInfo extends StatelessWidget {
  const SimilarCarCardInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        SizedBox(
          width: 170.w,
          child: AppText(
            "KIA SELTOS 2021",
            style: context.textTheme.titleMedium?.xb,
          ),
        ),
        4.verticalSpace,
        SizedBox(
          width: 170.w,
          child: AppText(
            "GTX 1.4 GDI PETROL",
            style: context.textTheme.titleMedium.s14.r
                .withColor(AppColors.white.withValues(alpha: 0.8)),
          ),
        ),
        8.verticalSpace,
        Row(
          children: [
            CustomTextContainer(maxWidth: 85.w, text: "99,488 KM"),
            const SpaceTextWidget(),
            CustomTextContainer(maxWidth: 68.w, text: "Petrol"),
          ],
        ),
        7.verticalSpace,
        Row(
          children: [
            CustomTextContainer(
                maxWidth: 85.w, icon: Assets.svgLocationPin, text: "Germany"),
            const SpaceTextWidget(),
            CustomTextContainer(maxWidth: 68.w, text: "Manual"),
          ],
        ),
        8.verticalSpace,
        Container(
          width: 170.w,
          alignment: Alignment.bottomRight,
          child: AppText(
            r"34,999$",
            style:
                context.textTheme.titleLarge.s15.xb.withColor(AppColors.white),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

import 'space_text_widget.dart';

class BottomSectionCarMiniDetailsCard extends StatelessWidget {
  const BottomSectionCarMiniDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.only(right: 12, left: 12, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '2021 KIA SELTOS',
                style:
                    context.textTheme.titleSmall!.xb.withColor(AppColors.white),
              ),
              10.verticalSpace,
              Row(
                children: [
                  AppText(
                    'GTX 1.4 GDI PETROL',
                    style: context.textTheme.titleSmall!.s13.b
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),
                  AppText(
                    'Manual',
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                ],
              ),
              6.verticalSpace,
              Row(
                children: [
                  AppText(
                    '99,488 KM',
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),

                  AppText(
                    'Petrol',
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),
                  // ToDo check
                  Padding(
                    padding: HWEdgeInsets.only(right: 4),
                    child: AppSvgPicture(
                      Assets.svgLocationPin,
                      height: 14.h,
                      width: 12.w,
                    ),
                  ),
                  AppText(
                    ' Germany',
                    style: context.textTheme.titleSmall!.sb
                        .withColor(AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          AppText(
            r'34,999$',
            style: context.textTheme.titleMedium!.xb.withColor(AppColors.white),
          ),
        ],
      ),
    );
  }
}

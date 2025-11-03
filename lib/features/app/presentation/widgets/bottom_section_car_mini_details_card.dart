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
    this.title,
    this.spec1,
    this.spec2,
    this.mileage,
    this.fuel,
    this.location,
    this.price,
  });

  final String? title;
  final String? spec1;
  final String? spec2;
  final String? mileage;
  final String? fuel;
  final String? location;
  final String? price;

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
                title ?? '2021 KIA SELTOS',
                translation: false,
                style:
                    context.textTheme.titleSmall!.xb.withColor(AppColors.white),
              ),
              10.verticalSpace,
              Row(
                children: [
                  AppText(
                    spec1 ?? 'GTX 1.4 GDI PETROL',
                    translation: false,
                    style: context.textTheme.titleSmall!.s13.b
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),
                  AppText(
                    spec2 ?? 'Manual',
                    translation: false,
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                ],
              ),
              6.verticalSpace,
              Row(
                children: [
                  AppText(
                    mileage ?? '99,488 KM',
                    translation: false,
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),

                  AppText(
                    fuel ?? 'Petrol',
                    translation: false,
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
                    ' ${location ?? 'WorldWide'}',
                    translation: false,
                    style: context.textTheme.titleSmall!.sb
                        .withColor(AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          AppText(
            price ?? r'34,999$',
            translation: false,
            style: context.textTheme.titleMedium!.xb.withColor(AppColors.white),
          ),
        ],
      ),
    );
  }
}

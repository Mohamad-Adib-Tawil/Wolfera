import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';

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
    this.secondPrice,
  });

  final String? title;
  final String? spec1;
  final String? spec2;
  final String? mileage;
  final String? fuel;
  final String? location;
  final String? price;
  final String? secondPrice;

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
                    spec2 != null
                        ? CarValueTranslator.translateTransmission(spec2)
                        : 'transmission_types.manual'.tr(),
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
                    mileage != null
                        ? '${mileage} ${'km'.tr()}'
                        : '99,488 ${'km'.tr()}',
                    translation: false,
                    style: context.textTheme.titleSmall!.s13.sb
                        .withColor(AppColors.white),
                  ),
                  const SpaceTextWidget(),

                  AppText(
                    fuel != null
                        ? CarValueTranslator.translateFuelType(fuel)
                        : 'fuel_types.petrol'.tr(),
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
                    location == null || location!.isEmpty
                        ? ' ${'worldwide'.tr()}'
                        : ' $location',
                    translation: false,
                    style: context.textTheme.titleSmall!.sb
                        .withColor(AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (secondPrice != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  price ?? '',
                  translation: false,
                  style: context.textTheme.titleMedium!.xb
                      .withColor(AppColors.white),
                ),
                4.verticalSpace,
                AppText(
                  secondPrice ?? '',
                  translation: false,
                  style: context.textTheme.titleSmall!.s13.sb
                      .withColor(AppColors.white),
                ),
              ],
            )
          ]
          else ...[
            AppText(
              price ?? '',
              translation: false,
              style:
                  context.textTheme.titleMedium!.xb.withColor(AppColors.white),
            ),
          ],
        ],
      ),
    );
  }
}

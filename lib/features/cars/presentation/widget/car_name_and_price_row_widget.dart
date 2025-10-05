import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class CarNameAndPriceRowWidget extends StatelessWidget {
  const CarNameAndPriceRowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          'Ferrari',
          style: context.textTheme.bodyLarge!.s20.b.withColor(AppColors.white),
        ),
        6.horizontalSpace,
        AppText(
          'SF90 Stradale',
          style: context.textTheme.bodyLarge!.s20.r.withColor(AppColors.white),
        ),
        const Spacer(),
        AppSvgPicture(
          Assets.svgBell,
          height: 20.h,
          width: 18.w,
        ),
        10.horizontalSpace,
        AppText(
          r'125,000 $',
          style:
              context.textTheme.bodyLarge!.s20.xb.withColor(AppColors.primary),
        ),
      ],
    );
  }
}

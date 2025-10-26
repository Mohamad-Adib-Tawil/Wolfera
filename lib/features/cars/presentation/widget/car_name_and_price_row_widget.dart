import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class CarNameAndPriceRowWidget extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const CarNameAndPriceRowWidget({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    final brand = carData['brand']?.toString() ?? '';
    final model = carData['model']?.toString() ?? '';
    final price = carData['price']?.toString() ?? '0';
    final currency = carData['currency']?.toString() ?? '\$';
    
    return Row(
      children: [
        if (brand.isNotEmpty)
          AppText(
            brand,
            translation: false,
            style: context.textTheme.bodyLarge!.s20.b.withColor(AppColors.white),
          ),
        if (brand.isNotEmpty && model.isNotEmpty)
          6.horizontalSpace,
        if (model.isNotEmpty)
          AppText(
            model,
            translation: false,
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
          '$price $currency',
          translation: false,
          style:
              context.textTheme.bodyLarge!.s20.xb.withColor(AppColors.primary),
        ),
      ],
    );
  }
}

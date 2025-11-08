import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/core/utils/money_formatter.dart';

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
    final priceRaw = carData['price']?.toString();
    final currency = carData['currency']?.toString() ?? '\$';
    final listingType = carData['listing_type']?.toString();
    String displayPrice;
    if (listingType == 'rent') {
      final candidates = [
        ['rental_price_per_day', 'day'],
        ['rental_price_per_week', 'week'],
        ['rental_price_per_month', 'month'],
        ['rental_price_per_3months', '3 months'],
        ['rental_price_per_6months', '6 months'],
        ['rental_price_per_year', 'year'],
      ];
      String? rp;
      for (final c in candidates) {
        final raw = carData[c[0]];
        if (raw != null) {
          final num? v = raw is num ? raw : num.tryParse(raw.toString());
          if (v != null) {
            final compact = MoneyFormatter.compact(v, symbol: currency);
            rp = compact != null ? '$compact / ${c[1]}' : null;
            break;
          }
        }
      }
      displayPrice = rp ?? (MoneyFormatter.compactFromString(priceRaw, symbol: currency) ?? '');
    } else {
      displayPrice = MoneyFormatter.compactFromString(priceRaw, symbol: currency) ?? '';
    }
    
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
          displayPrice,
          translation: false,
          style:
              context.textTheme.bodyLarge!.s20.xb.withColor(AppColors.primary),
        ),
      ],
    );
  }
}

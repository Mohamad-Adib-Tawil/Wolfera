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
  final Map<String, dynamic>? carData;
  
  const SimilarCarCardInfo({
    super.key,
    this.carData,
  });

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات من carData
    final brand = carData?['brand']?.toString() ?? '';
    final model = carData?['model']?.toString() ?? '';
    final year = carData?['year']?.toString() ?? '';
    final title = carData?['title']?.toString() ?? '$brand $model $year';
    
    final mileage = carData?['mileage'];
    final mileageText = mileage != null ? '${_formatNumber(mileage)} KM' : 'N/A';
    
    final fuelType = carData?['fuel_type']?.toString() ?? carData?['fuelType']?.toString() ?? 'N/A';
    final transmission = carData?['transmission']?.toString() ?? 'N/A';
    
    final city = carData?['city']?.toString();
    final country = carData?['country']?.toString();
    final location = city ?? country ?? 'Unknown';
    
    final price = carData?['price'];
    final currency = carData?['currency']?.toString() ?? '\$';
    final priceText = price != null ? '${_formatNumber(price)}$currency' : 'N/A';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        SizedBox(
          width: 170.w,
          child: AppText(
            title,
            translation: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.xb,
          ),
        ),
        4.verticalSpace,
        SizedBox(
          width: 170.w,
          child: AppText(
            '$brand $model',
            translation: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium.s14.r
                .withColor(AppColors.white.withValues(alpha: 0.8)),
          ),
        ),
        8.verticalSpace,
        Row(
          children: [
            CustomTextContainer(maxWidth: 85.w, text: mileageText),
            const SpaceTextWidget(),
            CustomTextContainer(maxWidth: 68.w, text: fuelType),
          ],
        ),
        7.verticalSpace,
        Row(
          children: [
            CustomTextContainer(
                maxWidth: 85.w, icon: Assets.svgLocationPin, text: location),
            const SpaceTextWidget(),
            CustomTextContainer(maxWidth: 68.w, text: transmission),
          ],
        ),
        8.verticalSpace,
        Container(
          width: 170.w,
          alignment: Alignment.bottomRight,
          child: AppText(
            priceText,
            translation: false,
            style:
                context.textTheme.titleLarge.s15.xb.withColor(AppColors.white),
          ),
        ),
      ],
    );
  }
  
  String _formatNumber(dynamic number) {
    if (number == null) return '0';
    final numValue = number is num ? number : (num.tryParse(number.toString()) ?? 0);
    if (numValue >= 1000) {
      return '${(numValue / 1000).toStringAsFixed(numValue % 1000 == 0 ? 0 : 1)}K';
    }
    return numValue.toStringAsFixed(0);
  }
}

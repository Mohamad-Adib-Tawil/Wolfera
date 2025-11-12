import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class ListingTypeSelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeChanged;

  const ListingTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'listing_type',
          style:
              context.textTheme.titleMedium?.s13.m.withColor(AppColors.white),
        ),
        10.verticalSpace,
        Row(
          children: [
            _buildOption(
              context: context,
              value: 'sale',
              label: 'listing_types.for_sale'.tr(),
              icon: Icons.sell_outlined,
              isSelected: selectedType == 'sale',
            ),
            12.horizontalSpace,
            _buildOption(
              context: context,
              value: 'rent',
              label: 'listing_types.for_rent'.tr(),
              icon: Icons.car_rental,
              isSelected: selectedType == 'rent',
            ),
            10.horizontalSpace,
            _buildOption(
              context: context,
              value: 'both',
              label: 'listing_types.both'.tr(),
              icon: Icons.all_inclusive,
              isSelected: selectedType == 'both',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: HWEdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.greyStroke.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.greyStroke,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
              6.verticalSpace,
              AppText(
                label,
                style: context.textTheme.bodySmall?.m.withColor(
                  isSelected ? AppColors.primary : AppColors.grey,
                ),
                translation: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

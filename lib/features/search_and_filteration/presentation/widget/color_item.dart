import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/car_color.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/color_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    super.key,
    required this.colorItem,
    required this.isSelected,
    required this.onTap,
  });

  final CarColor colorItem;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: HWEdgeInsets.only(left: 20),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(
                        color: colorItem.colorValue == Colors.orange
                            ? Colors.white
                            : AppColors.orange,
                        width: 2.r)
                    : null,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: colorItem.colorValue,
                radius: isSelected ? 23.5.r : 25.r,
              ),
            ),
            10.verticalSpace,
            AppText(
              colorItem.displayName,
              style: context.textTheme.bodyLarge?.s14.l
                  .withColor(isSelected ? AppColors.orange : AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

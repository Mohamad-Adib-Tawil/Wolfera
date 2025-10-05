import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/vehicle_types.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CarTypeItem extends StatelessWidget {
  final bool isSelected;
  final VehicleType vehicleType;
  final VoidCallback? onTap;

  const CarTypeItem({
    super.key,
    required this.isSelected,
    required this.vehicleType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.center,
        width: 100.w,
        margin: HWEdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.grey.shade900,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.2.r,
          ),
        ),
        child: SizedBox(
          height: 50.h,
          child: Stack(
            children: [
              Positioned(
                top: -8.h,
                left: 0,
                right: 0,
                child: Center(
                  child: AppSvgPicture(
                    vehicleType.asset,
                    height: 55.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 4.h,
                left: 0,
                right: 0,
                child: Center(
                  child: AppText(
                    vehicleType.name,
                    style: context.textTheme.bodySmall.s10.sb,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

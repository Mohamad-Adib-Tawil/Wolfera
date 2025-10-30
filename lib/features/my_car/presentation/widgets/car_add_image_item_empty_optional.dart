import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/plus_icon_widget.dart';

class CarAddImageItemEmptyOptional extends StatelessWidget {
  const CarAddImageItemEmptyOptional({
    super.key,
    required this.onAddImage,
  });

  final VoidCallback onAddImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddImage,
      child: SizedBox(
        width: 150.w,
        height: 145.w,
        child: Column(
          children: [
            SizedBox(
              width: 150.w,
              height: 100.h,
              child: DottedBorder(
                color: AppColors.greyStroke.withValues(alpha: 0.8),
                strokeWidth: 1.5.w,
                dashPattern: const [6, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(10.r),
                child: Container(
                  width: 150.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const PlusIconWidget(),
                ),
              ),
            ),
            10.verticalSpace,
            AppText(
              'Extra Pictures Optional',
              style: context.textTheme.bodyMedium?.m.s14
                  .withColor(AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

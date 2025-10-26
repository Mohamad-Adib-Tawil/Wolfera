import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CarDetailesWithIconItem extends StatelessWidget {
  const CarDetailesWithIconItem(
      {super.key,
      required this.title,
      required this.path,
      this.textPadding = EdgeInsets.zero,
      required this.textWidth});
  final double textWidth;
  final String title, path;
  final EdgeInsetsGeometry textPadding;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppSvgPicture(
          path,
          height: 40.h,
          width: 40.w,
        ),
        6.verticalSpace,
        Padding(
          padding: textPadding,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: textWidth.w,
              child: AppText(
                title,
                translation: false,
                textAlign: TextAlign.center,
                style:
                    context.textTheme.bodySmall!.r.withColor(AppColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  final String text;
  const CustomButtonWithIcon({
    super.key,
    this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(const Radius.circular(5).r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgPicture(icon),
            16.horizontalSpace,
            AppText(
              text,
              style: context.textTheme.bodyLarge?.s20.b
                  .withColor(AppColors.blackLight),
            ),
          ],
        ),
      ),
    );
  }
}

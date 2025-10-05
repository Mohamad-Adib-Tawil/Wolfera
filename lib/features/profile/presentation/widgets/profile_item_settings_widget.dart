import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class ProfileItemSettingsWidget extends StatelessWidget {
  const ProfileItemSettingsWidget({
    super.key,
    required this.title,
    required this.svgIcon,
    this.isLastItem = true,
    this.color = AppColors.white,
    this.onTap,
  });
  final String title;
  final String svgIcon;
  final bool isLastItem;
  final Color color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 55.h,
        child: Row(
          children: [
            AppSvgPicture(
              svgIcon,
              height: 25.h,
              width: 25.w,
              color: color,
            ),
            20.horizontalSpace,
            AppText(
              title,
              style: context.textTheme.bodyLarge!.s17.b.withColor(color),
            ),
            const Spacer(),
            isLastItem
                ? Transform.rotate(
                    angle: 3.14,
                    child: AppSvgPicture(
                      Assets.svgArrowLeft,
                      height: 25.h,
                      width: 25.w,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class SearchBarButton extends StatelessWidget {
  const SearchBarButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey, width: 1.2.r),
            borderRadius: BorderRadius.circular(10).r),
        padding: HWEdgeInsetsDirectional.only(start: 22, end: 24),
        margin: HWEdgeInsets.only(left: 24, right: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.r,
              child: const AppSvgPicture(
                Assets.svgSearch,
                color: Color(0xff8C9199),
              ),
            ),
            12.horizontalSpace,
            AppText(
              LocaleKeys.searchHereForCars,
              style: context.textTheme.bodyMedium?.r
                  .withColor(AppColors.white.withValues(alpha: 0.67)),
            ),
            const Spacer(),
            SizedBox(
              width: 24.r,
              child: const AppSvgPicture(
                Assets.svgFilter,
                color: Color(0xff8C9199),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

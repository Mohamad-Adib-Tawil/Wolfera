import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class DateTimeWidgetMessageItem extends StatelessWidget {
  const DateTimeWidgetMessageItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144.w,
      padding: HWEdgeInsets.symmetric(vertical: 9, horizontal: 16),
      margin: HWEdgeInsets.only(bottom: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: const Color(0xffF4F5FA),
      ),
      child: AppText(
        '8 Jun 2024',
        maxLines: 1,
        style:
            context.textTheme.labelLarge.b.withColor(const Color(0xff1C1D22)),
      ),
    );
  }
}

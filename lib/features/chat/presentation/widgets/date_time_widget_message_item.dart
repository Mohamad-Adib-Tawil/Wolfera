import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class DateTimeWidgetMessageItem extends StatelessWidget {
  const DateTimeWidgetMessageItem({
    super.key,
    required this.dateTime,
  });
  
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(local.year, local.month, local.day);
    final diffDays = today.difference(thatDay).inDays;

    String displayText;
    if (diffDays == 0) {
      displayText = 'اليوم';
    } else if (diffDays == 1) {
      displayText = 'أمس';
    } else {
      final sameYear = local.year == now.year;
      final fmt = sameYear ? DateFormat('d MMMM', 'ar') : DateFormat('d MMMM yyyy', 'ar');
      displayText = fmt.format(local);
    }
    
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
        displayText,
        maxLines: 1,
        style:
            context.textTheme.labelLarge.b.withColor(const Color(0xff1C1D22)),
        translation: false,
      ),
    );
  }
}

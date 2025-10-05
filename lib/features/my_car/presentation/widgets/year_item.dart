import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class YearItem extends StatelessWidget {
  const YearItem({
    super.key,
    required this.year,
    this.currentYear,
    required this.onYearChanged,
  });

  final int year;
  final int? currentYear;
  final ValueChanged<int> onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.only(left: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: year == currentYear
            ? Border.all(color: AppColors.primary, width: 1.r)
            : null,
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: AppText(
          year.toString(),
          style: context.textTheme.bodyMedium?.b?.copyWith(shadows: [
            Shadow(
              color: AppColors.primary.withOpacity(0.8),
              blurRadius: 5.0,
              offset: const Offset(2.0, 2.0),
            ),
          ]),
        ),
        selectedTileColor: AppColors.blue,
        selectedColor: AppColors.green,
        selected: year == currentYear,
        onTap: () {
          onYearChanged(year);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

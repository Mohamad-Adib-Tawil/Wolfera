import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/years_grid_view.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class YearPickerDialog extends StatelessWidget {
  final int? currentYear;
  final void Function()? onReset;
  final ValueChanged<int> onYearChanged;

  const YearPickerDialog({
    super.key,
    this.currentYear,
    this.onReset,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int nowYear = DateTime.now().year;
    const int startYear = 2000;

    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          _buildHeader(context),
          YearsGridView(
              nowYear: nowYear,
              startYear: startYear,
              currentYear: currentYear,
              onYearChanged: onYearChanged),
          10.verticalSpace,
          ElevatedButton(
            onPressed: onReset,
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    currentYear != null ? AppColors.primary : AppColors.grey),
                minimumSize: WidgetStatePropertyAll(
                  Size(150.w, 45.h),
                )),
            child: AppText(
              LocaleKeys.auth_reset,
              style: context.textTheme.bodyMedium.b,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Year',
          style: context.textTheme.titleMedium?.s20.b,
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: AppColors.blackLight,
      borderRadius: BorderRadius.circular(10.r),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          color: AppColors.primary,
        )
      ],
    );
  }
}

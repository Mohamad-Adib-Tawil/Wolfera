import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_button/group_button.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';

import '../../../../core/config/theme/colors_app.dart';
import '../../../../core/utils/responsive_padding.dart';
import 'app_text.dart';

class GroupedButtons extends StatelessWidget {
  GroupedButtons({
    super.key,
    this.enableDeselect = false,
    this.maxSelected,
    this.buttons = const [],
    this.spacing,
    this.title,
  });

  final List<String> buttons;
  final bool enableDeselect;
  final int? maxSelected;
  final double? spacing;
  final String? title;

  final GroupButtonController controller =
      GroupButtonController(selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...{
          AppText(title!, style: context.textTheme.titleMedium.s15.sb),
          10.verticalSpace,
        },
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: HWEdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
              boxShadow: [
                BoxShadow(
                    color: AppColors.grey.shade100.withAlpha(100),
                    spreadRadius: 5,
                    blurRadius: 10),
              ],
            ),
            child: GroupButton(
              onSelected: (value, index, isSelected) {
                print('$index button is selected');
              },
              controller: controller,
              buttons: buttons,
              enableDeselect: enableDeselect,
              maxSelected: maxSelected,
              options: GroupButtonOptions(
                buttonWidth:
                    (MediaQuery.sizeOf(context).width / buttons.length) - 30.w,
                borderRadius: BorderRadius.circular(10).r,
                spacing: spacing ?? 10.w,
                selectedShadow: [
                  BoxShadow(
                      color: context.colorScheme.primary.withAlpha(20),
                      spreadRadius: 5,
                      blurRadius: 10),
                ],
                unselectedTextStyle: context.textTheme.bodyMedium,
                selectedTextStyle: context.textTheme.bodyLarge.sb
                    .withColor(context.colorScheme.primary),
                buttonHeight: 45.r,
                selectedBorderColor: context.colorScheme.primary,
                selectedColor: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

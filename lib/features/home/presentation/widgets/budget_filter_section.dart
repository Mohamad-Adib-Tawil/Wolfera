import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/budget_list_view.dart';

class BudgetFilterSection extends StatelessWidget {
  const BudgetFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: HWEdgeInsetsDirectional.only(start: 24, top: 20, bottom: 20),
          child: AppText(
            "Browse by Budget",
            style: context.textTheme.bodyMedium?.s20.sb,
          ),
        ),
        Container(
          width: 1.sw,
          height: 50.h,
          margin: HWEdgeInsetsDirectional.only(start: 10, end: 14),
          child: const BudgetListView(),
        ),
      ],
    );
  }
}

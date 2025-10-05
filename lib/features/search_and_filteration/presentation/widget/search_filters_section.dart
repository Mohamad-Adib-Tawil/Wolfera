import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_item.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_with_bidge_widget.dart';

class SearchFiltersSection extends StatelessWidget {
  const SearchFiltersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.I<SearchCubit>();

    return Container(
      height: 34.h,
      margin: HWEdgeInsets.only(left: 23),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const FilterWithBidgeWidget(),
          10.horizontalSpace,
          const FilterItem(title: "Make"),
          10.horizontalSpace,
          const FilterItem(title: "Price"),
          10.horizontalSpace,
          const FilterItem(title: "Year"),
          10.horizontalSpace,
          const FilterItem(title: "Mileage"),
          10.horizontalSpace,
          TextButton(
            onPressed: () => bloc.resetAllFilters(),
            child: AppText(
              "Reset",
              style: context.textTheme.titleMedium?.s13.m
                  .withColor(AppColors.primary),
            ),
          ),
          14.horizontalSpace,
        ],
      ),
    );
  }
}

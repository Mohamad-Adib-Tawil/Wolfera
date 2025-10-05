import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/makers_list_view_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/section_title_and_reset_filter_widget.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/show_car_makers_list_view_widget.dart';

class MakersSectionFilter extends StatelessWidget {
  final SearchCubit searchCubit;
  const MakersSectionFilter({
    super.key,
    required this.searchCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleAndResetFilterWidget(
            title: 'Makers',
            resetFilter: () => searchCubit.resetMakerSelectionFilter()),
        20.verticalSpace,
        SizedBox(height: 70.h, child: const MakersListViewFilter()),
        25.verticalSpace,
        const Align(
          alignment: Alignment.center,
          child: ShowCarMakersListViewWidget(),
        ),
        10.verticalSpace,
        const CustomDivider(
          color: AppColors.whiteLess,
          thickness: 0.5,
          endIndent: 15,
          indent: 15,
        ),
        8.verticalSpace,
      ],
    );
  }
}

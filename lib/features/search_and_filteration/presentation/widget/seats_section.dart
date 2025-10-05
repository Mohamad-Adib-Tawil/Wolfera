import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/seats_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/section_title_and_reset_filter_widget.dart';

class SeatsSection extends StatelessWidget {
  final SearchCubit searchCubit;

  const SeatsSection({
    super.key,
    required this.searchCubit,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleAndResetFilterWidget(
            title: 'Seats', resetFilter: () => searchCubit.resetSeatsFilter()),
        20.verticalSpace,
        SizedBox(
          height: 46.h,
          child: const SeatsListView(),
        ),
        30.verticalSpace,
      ],
    );
  }
}

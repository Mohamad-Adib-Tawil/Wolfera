import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/section_title_and_reset_filter_widget.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/transmission_list_view.dart';

class TransmissionSection extends StatelessWidget {
  final SearchCubit searchCubit;

  const TransmissionSection({
    super.key,
    required this.searchCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleAndResetFilterWidget(
          title: 'transmission',
          resetFilter: () => searchCubit.resetTransmissionFilter(),
        ),
        20.verticalSpace,
        SizedBox(
          height: 46.h,
          child: const TransmissionListView(),
        ),
        20.verticalSpace,
        const CustomDivider(
          color: AppColors.whiteLess,
          thickness: .5,
          endIndent: 15,
          indent: 15,
        ),
        10.verticalSpace,
      ],
    );
  }
}

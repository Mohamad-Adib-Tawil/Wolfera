import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/kilometers_dialog.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/section_title_and_reset_filter_widget.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/year_item_widget_state.dart';

class KilometersSectionFilter extends StatelessWidget {
  final SearchCubit searchCubit;

  const KilometersSectionFilter({
    super.key,
    required this.searchCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleAndResetFilterWidget(
            title: 'mileage_label',
            resetFilter: () => searchCubit.resetKilometersFilter(
                resetMinKilometers: true, resetMaxKilometers: true)),
        20.verticalSpace,
        Padding(
          padding: HWEdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'min_mileage',
                style:
                    context.textTheme.bodyLarge?.s14.withColor(AppColors.white),
              ),
              AppText(
                'max_mileage',
                style:
                    context.textTheme.bodyLarge?.s14.withColor(AppColors.white),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        Padding(
          padding: HWEdgeInsets.symmetric(horizontal: 25),
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  YearItemWidget(
                    key: const Key("MinKilometers"),
                    selectedYear: state.selectedCarMinKilometers,
                    onTap: () => AnimatedDialog.show(context,
                        insetPadding: HWEdgeInsets.only(
                            top: 60, left: 40, right: 40, bottom: 30),
                        child: KilometersDialog(
                          isMin: true,
                          onSelectionConfirmed: (p0) {
                            searchCubit.changeCarKilometersFilter(
                                minKilometers: p0);
                            context.pop();
                          },
                          onReset: () {
                            searchCubit.resetKilometersFilter(
                                resetMinKilometers: true);
                            context.pop();
                          },
                        ),
                        barrierDismissible: true,
                        barrierLabel: "MinKilometersPickerDialog"),
                  ),
                  Container(
                    width: 30.w,
                    height: 0.5.h,
                    decoration: const BoxDecoration(color: AppColors.whiteLess),
                  ),
                  YearItemWidget(
                    key: const Key("MaxKilometers"),
                    selectedYear: state.selectedCarMaxKilometers,
                    onTap: () => AnimatedDialog.show(context,
                        insetPadding: HWEdgeInsets.only(
                            top: 60, left: 40, right: 40, bottom: 30),
                        child: KilometersDialog(
                          isMin: false,
                          onSelectionConfirmed: (p0) {
                            searchCubit.changeCarKilometersFilter(
                                maxKilometers: p0);
                            context.pop();
                          },
                          onReset: () {
                            searchCubit.resetKilometersFilter(
                                resetMaxKilometers: true);
                            context.pop();
                          },
                        ),
                        barrierDismissible: true,
                        barrierLabel: "MaxKilometersPickerDialog"),
                  ),
                ],
              );
            },
          ),
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

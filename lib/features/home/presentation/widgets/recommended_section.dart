import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({
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
            "Recommended",
            style: context.textTheme.bodyMedium.s20.sb,
          ),
        ),
        SizedBox(
          height: 215.h,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              late final Widget content;
              if (state.carsState.isLoading || state.carsState.isInit) {
                content = const Center(
                  key: ValueKey('rec-loading'),
                  child: AppLoader(),
                );
              } else {
                final cars = state.carsState.getDataWhenSuccess;
                if (cars == null || cars.isEmpty) {
                  content = Center(
                    key: const ValueKey('rec-empty'),
                    child: AppEmptyState.foodsEmpty(),
                  );
                } else {
                  content = Container(
                    key: const ValueKey('rec-list'),
                    margin: HWEdgeInsetsDirectional.only(start: 4, end: 14),
                    width: double.infinity,
                    child: CarsListViewBuilder(
                      scrollDirection: Axis.horizontal,
                      padding: HWEdgeInsetsDirectional.only(start: 14),
                      cars: cars,
                    ),
                  );
                }
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                child: content,
              );
            },
          ),
        ),
      ],
    );
  }
}

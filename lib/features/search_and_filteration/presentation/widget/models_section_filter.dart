import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/extensions/parse_string_to_enum.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/models_dialog.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/section_title_and_reset_filter_widget.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/see_full_list_button_widget.dart';

class ModelsSectionFilter extends StatelessWidget {
  final SearchCubit searchCubit;
  const ModelsSectionFilter({super.key, required this.searchCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleAndResetFilterWidget(
          title: 'car_filters.model',
          resetFilter: () => searchCubit.resetModelSelectionFilter(),
        ),
        12.verticalSpace,
        // Selected models preview as chips
        Padding(
          padding: HWEdgeInsets.only(left: 16, right: 16),
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              final models = state.selectedCarModelsFilter;
              if (models.isEmpty) {
                return AppText(
                  modelsGuideText(state),
                  translation: false,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey),
                );
              }
              return SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: models.length,
                  separatorBuilder: (_, __) => 8.horizontalSpace,
                  itemBuilder: (context, index) {
                    final m = models[index];
                    return GestureDetector(
                      onTap: () => context.read<SearchCubit>().toggleModelSelection(m),
                      child: Container(
                        padding: HWEdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.grey.shade700,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.primary.withValues(alpha: .6), width: 1),
                        ),
                        child: AppText(
                          m,
                          translation: false,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        16.verticalSpace,
        Align(
          alignment: Alignment.center,
          child: SeeFullListButtonWidget(
            onTap: () => _openModelsDialog(context),
          ),
        ),
        10.verticalSpace,
        const Divider(height: 1, color: AppColors.whiteLess),
        8.verticalSpace,
      ],
    );
  }

  String modelsGuideText(SearchState state) {
    if (state.selectedCarMakersFilter.isEmpty) {
      return 'Select maker first';
    }
    return 'Tap to choose models';
  }

  void _openModelsDialog(BuildContext context) {
    final bloc = context.read<SearchCubit>();
    final makersStr = bloc.state.selectedCarMakersFilter;
    final makers = <CarMaker>[];
    for (final s in makersStr) {
      try {
        makers.add(s.toEnum());
      } catch (_) {}
    }

    AnimatedDialog.show(
      context,
      insetPadding: HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
      child: CarModelsDialog(
        isMultiSelect: true,
        makers: makers.isEmpty ? null : makers,
        selectedModels: bloc.state.selectedCarModelsFilter,
        includeAllOption: true,
        onSelectionConfirmed: (selected) {
          if (selected is List<String>) {
            bloc.setModelsSelection(selected);
          } else {
            bloc.resetModelSelectionFilter();
          }
        },
      ),
      barrierDismissible: true,
      barrierLabel: 'ModelsDialog',
    );
  }
}

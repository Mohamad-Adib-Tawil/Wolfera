import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/kilometers_section_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/makers_section_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/models_section_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/seats_section.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/year_section_filter.dart';
import '../widget/car_type_section.dart';
import '../widget/colors_section.dart';
import '../widget/condition_section.dart';
import '../widget/cylinders_section.dart';
import '../widget/fuel_type_section.dart';
import '../widget/price_section.dart';
import '../widget/transmission_section.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.I<SearchCubit>();
    final list = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          MakersSectionFilter(searchCubit: bloc),
          ModelsSectionFilter(searchCubit: bloc),
          KilometersSectionFilter(searchCubit: bloc),
          YearSectionFilter(searchCubit: bloc),
          PriceSection(searchCubit: bloc),
          TransmissionSection(searchCubit: bloc),
          CarTypeSection(searchCubit: bloc),
          FuelTypeSection(searchCubit: bloc),
          CylindersSection(searchCubit: bloc),
          SeatsSection(searchCubit: bloc),
          ColorsSection(searchCubit: bloc),
          ConditionSection(searchCubit: bloc),
          90.verticalSpace,
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? DelayedFadeSlide(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 1000),
                beginOffset: const Offset(0, -0.24),
                child: CustomAppbar(
                  text: 'filter',
                  automaticallyImplyLeading: true,
                ),
              )
            : CustomAppbar(
                text: 'filter',
                automaticallyImplyLeading: true,
              ),
      ),
      body: _shouldAnimateEntrance
          ? DelayedFadeSlide(
              delay: const Duration(milliseconds: 260),
              duration: const Duration(milliseconds: 1000),
              beginOffset: const Offset(-0.24, 0),
              child: list,
            )
          : list,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionButtons(context, bloc),
    );
  }

  Row floatingActionButtons(BuildContext context, SearchCubit bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.extended(
            autofocus: true,
            label: Padding(
              padding: HWEdgeInsets.symmetric(horizontal: 36),
              child: AppText(
                "apply",
                style: context.textTheme.bodyMedium?.s20.b,
              ),
            ),
            heroTag: null,
            backgroundColor: AppColors.primary,
            onPressed: () => context.pop()),
        FloatingActionButton.extended(
            label: Padding(
              padding: HWEdgeInsets.symmetric(horizontal: 20),
              child: AppText(
                "reset",
                style: context.textTheme.bodyMedium?.s20.b,
              ),
            ),
            heroTag: null,
            backgroundColor: AppColors.grey,
            onPressed: () {
              bloc.resetAllFilters();
              context.pop();
            }),
      ],
    );
  }
}

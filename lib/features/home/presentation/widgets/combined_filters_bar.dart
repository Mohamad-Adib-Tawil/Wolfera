import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/city_dropdown.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/budget_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/car_body_type_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/makers_list_view_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/transmission_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/fuel_type_list_view_state.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/cylinders_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/seats_list_view.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/colors_list_view_state.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/condition_list_view_state.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/year_item_widget_state.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/year_picker_dialog.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/kilometers_dialog.dart';

/// A compact, professional filter bar showing categories in a row and the
/// selected category content right below it. Reuses existing search widgets.
class CombinedFiltersBar extends StatefulWidget {
  const CombinedFiltersBar({super.key});

  @override
  State<CombinedFiltersBar> createState() => _CombinedFiltersBarState();
}

class _CombinedFiltersBarState extends State<CombinedFiltersBar> {
  int _selectedIndex = 0;

  final _tabs = const [
    _FilterTab('Makers', Icons.local_offer_outlined),
    _FilterTab('Location', Icons.place_outlined),
    _FilterTab('Budget', Icons.attach_money_rounded),
    _FilterTab('Body type', Icons.directions_car_filled_outlined),
    _FilterTab('Year', Icons.calendar_month_outlined),
    _FilterTab('Kilometers', Icons.speed),
    _FilterTab('Transmission', Icons.swap_horiz),
    _FilterTab('Fuel', Icons.local_gas_station_outlined),
    _FilterTab('Cylinders', Icons.blur_circular),
    _FilterTab('Seats', Icons.airline_seat_recline_normal),
    _FilterTab('Colors', Icons.color_lens_outlined),
    _FilterTab('Condition', Icons.check_circle_outline),
  ];

  SearchCubit get _searchCubit => GetIt.I<SearchCubit>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs Row
        Padding(
          padding: HWEdgeInsetsDirectional.only(start: 16, end: 16, top: 8),
          child: SizedBox(
            height: 42.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final t = _tabs[i];
                final isSel = _selectedIndex == i;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedIndex = i;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: isSel
                        ? HWEdgeInsets.symmetric(horizontal: 18, vertical: 8)
                        : HWEdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.primary.withValues(alpha: 0.16)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20).r,
                      border: Border.all(
                        color: isSel ? AppColors.primary : AppColors.grey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          t.icon,
                          size: 16.r,
                          color: isSel ? AppColors.primary : AppColors.white,
                        ),
                        8.horizontalSpace,
                        AppText(
                          t.label,
                          translation: false,
                          style: context.textTheme.titleSmall?.s13.m.withColor(
                              isSel ? AppColors.primary : AppColors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => 8.horizontalSpace,
              itemCount: _tabs.length,
            ),
          ),
        ),
        10.verticalSpace,
        // Content Area (reuses existing search widgets)
        Padding(
          padding: HWEdgeInsetsDirectional.only(start: 8, end: 8),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: Container(
              height: _contentHeightForIndex(_selectedIndex),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12).r,
              ),
              clipBehavior: Clip.hardEdge,
              child: BlocProvider.value(
                value: _searchCubit,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  layoutBuilder: (currentChild, previousChildren) =>
                      currentChild ?? const SizedBox.shrink(),
                  transitionBuilder: (child, animation) {
                    final offsetAnim = Tween<Offset>(
                      begin: _offsetForIndex(_selectedIndex),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offsetAnim, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey('tab|$_selectedIndex'),
                    child: _buildContentForIndex(_selectedIndex),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Note: No state-based switching here; inner lists animate themselves.

  Offset _offsetForIndex(int index) {
    switch (index) {
      case 0: // Makers: from left
        return const Offset(-0.22, 0);
      case 1: // Location: from top
        return const Offset(0, -0.22);
      case 2: // Budget: from bottom
        return const Offset(0, 0.22);
      case 3: // Body type: from right
        return const Offset(0.22, 0);
      case 4: // Year: from left
        return const Offset(-0.22, 0);
      case 5: // Kilometers: from right
        return const Offset(0.22, 0);
      case 6: // Transmission: from bottom
        return const Offset(0, 0.22);
      case 7: // Fuel: from top
        return const Offset(0, -0.22);
      case 8: // Cylinders: from right
        return const Offset(0.22, 0);
      case 9: // Seats: from left
        return const Offset(-0.22, 0);
      case 10: // Colors: from right
        return const Offset(0.22, 0);
      case 11: // Condition: from bottom
        return const Offset(0, 0.22);
      default:
        return const Offset(0.18, 0);
    }
  }

  double _contentHeightForIndex(int index) {
    switch (index) {
      case 0: // Makers
        return 70.h;
      case 1: // Location
        return 60.h;
      case 2: // Budget
        return 60.h;
      case 3: // Body type
        return 60.h;
      case 4: // Year
        return 56.h;
      case 5: // Kilometers
        return 56.h;
      case 6: // Transmission
      case 7: // Fuel
      case 8: // Cylinders
      case 9: // Seats
        return 56.h;
      case 10: // Colors
        return 84.h; // circle (≈55) + gap (≈10-12) + text (≈18)
      case 11: // Condition
        return 56.h;
      default:
        return 60.h;
    }
  }

  Widget _buildContentForIndex(int index) {
    switch (index) {
      case 0: // Makers
        return const MakersListViewFilter();
      case 1: // Location
        return Align(
          alignment: Alignment.centerLeft,
          child: CityDropdown(onChanged: (_) => _searchCubit.searchCars()),
        );
      case 2: // Budget
        return const BudgetListView();
      case 3: // Body Type
        return const CarBodyTypeListView();
      case 4: // Year quick controls
        return Padding(
          padding: HWEdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<SearchCubit, SearchState>(
            bloc: _searchCubit,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  YearItemWidget(
                    key: const Key('MinYearQuick'),
                    selectedYear: state.selectedCarMinYear?.toString(),
                    onTap: () => AnimatedDialog.show(
                      context,
                      insetPadding:
                          HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                      child: YearPickerDialog(
                        currentYear: state.selectedCarMinYear,
                        onYearChanged: (minYear) =>
                            _searchCubit.changeCarYearFilter(minYear: minYear),
                        onReset: () {
                          _searchCubit.resetYearFilter(resetMinYear: true);
                          context.pop();
                        },
                      ),
                      barrierDismissible: true,
                      barrierLabel: 'YearPickerDialogMin',
                    ),
                  ),
                  Container(width: 30.w, height: 0.5.h, color: AppColors.whiteLess),
                  YearItemWidget(
                    key: const Key('MaxYearQuick'),
                    selectedYear: state.selectedCarMaxYear?.toString(),
                    onTap: () => AnimatedDialog.show(
                      context,
                      insetPadding:
                          HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                      child: YearPickerDialog(
                        currentYear: state.selectedCarMaxYear,
                        onYearChanged: (maxYear) {
                          if (state.selectedCarMinYear != null
                              ? maxYear > state.selectedCarMinYear!
                              : true) {
                            _searchCubit.changeCarYearFilter(maxYear: maxYear);
                          }
                        },
                        onReset: () {
                          _searchCubit.resetYearFilter(resetMaxYear: true);
                          context.pop();
                        },
                      ),
                      barrierDismissible: true,
                      barrierLabel: 'YearPickerDialogMax',
                    ),
                  ),
                ],
              );
            },
          ),
        );
      case 5: // Kilometers quick controls
        return Padding(
          padding: HWEdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<SearchCubit, SearchState>(
            bloc: _searchCubit,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  YearItemWidget(
                    key: const Key('MinKilometersQuick'),
                    selectedYear: state.selectedCarMinKilometers,
                    onTap: () => AnimatedDialog.show(
                      context,
                      insetPadding:
                          HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                      child: KilometersDialog(
                        isMin: true,
                        onSelectionConfirmed: (val) {
                          _searchCubit.changeCarKilometersFilter(minKilometers: val);
                          context.pop();
                        },
                        onReset: () {
                          _searchCubit.resetKilometersFilter(resetMinKilometers: true);
                          context.pop();
                        },
                      ),
                      barrierDismissible: true,
                      barrierLabel: 'MinKilometersPickerDialog',
                    ),
                  ),
                  Container(width: 30.w, height: 0.5.h, color: AppColors.whiteLess),
                  YearItemWidget(
                    key: const Key('MaxKilometersQuick'),
                    selectedYear: state.selectedCarMaxKilometers,
                    onTap: () => AnimatedDialog.show(
                      context,
                      insetPadding:
                          HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                      child: KilometersDialog(
                        isMin: false,
                        onSelectionConfirmed: (val) {
                          _searchCubit.changeCarKilometersFilter(maxKilometers: val);
                          context.pop();
                        },
                        onReset: () {
                          _searchCubit.resetKilometersFilter(resetMaxKilometers: true);
                          context.pop();
                        },
                      ),
                      barrierDismissible: true,
                      barrierLabel: 'MaxKilometersPickerDialog',
                    ),
                  ),
                ],
              );
            },
          ),
        );
      case 6: // Transmission
        return const TransmissionListView();
      case 7: // Fuel Type
        return const FuelTypeListView();
      case 8: // Cylinders
        return const CylindersListView();
      case 9: // Seats
        return const SeatsListView();
      case 10: // Colors
        return const ColorsListView();
      case 11: // Condition
        return const ConditionListView();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _FilterTab {
  final String label;
  final IconData icon;
  const _FilterTab(this.label, this.icon);
}

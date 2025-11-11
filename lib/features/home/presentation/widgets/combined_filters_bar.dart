import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:wolfera/features/search_and_filteration/presentation/widget/listing_type_filter.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';

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
    _FilterTab('car_filters.brand', Icons.local_offer_outlined),
    _FilterTab('sell_car.listing_type', Icons.category_outlined),
    _FilterTab('location', Icons.place_outlined),
    _FilterTab('car_filters.price_range', Icons.attach_money_rounded),
    _FilterTab('car_filters.body_type', Icons.directions_car_filled_outlined),
    _FilterTab('car_filters.year', Icons.calendar_month_outlined),
    _FilterTab('mileage', Icons.speed),
    _FilterTab('car_filters.transmission', Icons.swap_horiz),
    _FilterTab('car_filters.fuel_type', Icons.local_gas_station_outlined),
    _FilterTab('car_filters.cylinders', Icons.blur_circular),
    _FilterTab('car_filters.seats', Icons.airline_seat_recline_normal),
    _FilterTab('car_filters.color', Icons.color_lens_outlined),
    _FilterTab('car_filters.condition', Icons.check_circle_outline),
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
                          style: context.textTheme.titleSmall?.s13.m
                              .withColor(isSel ? AppColors.primary : AppColors.white),
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
      case 1: // Type: from top
        return const Offset(0, -0.22);
      case 2: // Location: from top
        return const Offset(0, -0.22);
      case 3: // Budget: from bottom
        return const Offset(0, 0.22);
      case 4: // Body type: from right
        return const Offset(0.22, 0);
      case 5: // Year: from left
        return const Offset(-0.22, 0);
      case 6: // Kilometers: from right
        return const Offset(0.22, 0);
      case 7: // Transmission: from bottom
        return const Offset(0, 0.22);
      case 8: // Fuel: from top
        return const Offset(0, -0.22);
      case 9: // Cylinders: from right
        return const Offset(0.22, 0);
      case 10: // Seats: from left
        return const Offset(-0.22, 0);
      case 11: // Colors: from right
        return const Offset(0.22, 0);
      case 12: // Condition: from bottom
        return const Offset(0, 0.22);
      default:
        return const Offset(0.18, 0);
    }
  }

  double _contentHeightForIndex(int index) {
    switch (index) {
      case 0: // Makers
        return 70.h;
      case 1: // Type (Sale/Rent)
        return 45.h;
      case 2: // Location
        return 60.h;
      case 3: // Budget
        return 60.h;
      case 4: // Body type
        return 60.h;
      case 5: // Year
        return 56.h;
      case 6: // Kilometers
        return 56.h;
      case 7: // Transmission
      case 8: // Fuel
      case 9: // Cylinders
      case 10: // Seats
        return 56.h;
      case 11: // Colors
        return 84.h; // circle (≈55) + gap (≈10-12) + text (≈18)
      case 12: // Condition
        return 56.h;
      default:
        return 60.h;
    }
  }

  Widget _buildContentForIndex(int index) {
    switch (index) {
      case 0: // Makers
        return const MakersListViewFilter();
      case 1: // Type (Sale/Rent)
        return const ListingTypeFilter();
      case 2: // Location
        return Align(
          alignment: Alignment.centerLeft,
          child: CityDropdown(
            onChanged: (label) {
              final v = label ?? 'Worldwide';
              if (v == 'Worldwide') {
                _searchCubit.setWorldwide(true);
                return;
              }
              // Parse "Country - Region" or just "Country"
              final idx = v.indexOf(' - ');
              final countryName = idx == -1 ? v : v.substring(0, idx);
              final region = idx == -1 ? null : v.substring(idx + 3);
              _searchCubit.selectCountryByName(countryName);
              if (region != null && region.isNotEmpty) {
                _searchCubit.selectRegionOrCity(region);
              }
              try { GetIt.I<HomeCubit>().getHomeData(); } catch (_) {}
            },
          ),
        );
      case 3: // Budget
        return const BudgetListView();
      case 4: // Body Type
        return const CarBodyTypeListView();
      case 5: // Year quick controls
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
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
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
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
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
      case 6: // Kilometers quick controls
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
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        onReset: () {
                          _searchCubit.resetKilometersFilter(resetMinKilometers: true);
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
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
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        onReset: () {
                          _searchCubit.resetKilometersFilter(resetMaxKilometers: true);
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
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
      case 7: // Transmission
        return const TransmissionListView();
      case 8: // Fuel Type
        return const FuelTypeListView();
      case 9: // Cylinders
        return const CylindersListView();
      case 10: // Seats
        return const SeatsListView();
      case 11: // Colors
        return const ColorsListView();
      case 12: // Condition
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

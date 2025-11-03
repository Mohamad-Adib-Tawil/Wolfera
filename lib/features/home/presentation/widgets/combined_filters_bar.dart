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
    _FilterTab('Location', Icons.place_outlined),
    _FilterTab('Budget', Icons.attach_money_rounded),
    _FilterTab('Body type', Icons.directions_car_filled_outlined),
    _FilterTab('Makers', Icons.local_offer_outlined),
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
      case 0: // Location: from top
        return const Offset(0, -0.22);
      case 1: // Budget: from bottom
        return const Offset(0, 0.22);
      case 2: // Body type: from right
        return const Offset(0.22, 0);
      case 3: // Makers: from left
        return const Offset(-0.22, 0);
      default:
        return const Offset(0.18, 0);
    }
  }

  double _contentHeightForIndex(int index) {
    // Fixed height for all tabs to avoid layout jumps and overflow
    return 70.h;
  }

  Widget _buildContentForIndex(int index) {
    switch (index) {
      case 0: // Location
        return Align(
          alignment: Alignment.centerLeft,
          child: CityDropdown(onChanged: (_) => _searchCubit.searchCars()),
        );
      case 1: // Budget
        return const BudgetListView();
      case 2: // Body Type
        return const CarBodyTypeListView();
      case 3: // Makers
        return const MakersListViewFilter();
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

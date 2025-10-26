import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_item.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_with_bidge_widget.dart';

class SearchFiltersSection extends StatelessWidget {
  const SearchFiltersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.I<SearchCubit>();

    return SizedBox(
      height: 48.h,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final countries = LocationsData.countryNames();
          final selectedCountryName = state.isWorldwide
              ? 'Worldwide'
              : (LocationsData.findByCode(state.selectedCountryCode)?.name ?? 'Worldwide');
          final selectedCountry = LocationsData.findByCode(state.selectedCountryCode) ??
              (state.isWorldwide ? LocationsData.countries.first : null);
          final regions = (selectedCountry?.secondLevel ?? const <String>[]);
          final hasRegions = !state.isWorldwide && regions.isNotEmpty;

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: HWEdgeInsets.only(left: 23, right: 10),
            children: [
              // Country dropdown (with Worldwide)
              SizedBox(
                width: 180.w,
                child: AppDropdownSearch<String>(
                  items: countries,
                  selectedItem: selectedCountryName,
                  hintText: 'Worldwide',
                  onChanged: (val) => bloc.selectCountryByName(val),
                  contentPadding: HWEdgeInsets.symmetric(horizontal: 8),
                  borderColor: Colors.transparent,
                  filled: false,
                ),
              ),
              10.horizontalSpace,

              // Region / City dropdown (depends on country)
              if (hasRegions) ...[
                SizedBox(
                  width: 170.w,
                  child: AppDropdownSearch<String>(
                    items: regions,
                    selectedItem: state.selectedRegionOrCity,
                    hintText: selectedCountry?.secondLevelLabel ?? 'Region',
                    onChanged: (val) => bloc.selectRegionOrCity(val),
                    contentPadding: HWEdgeInsets.symmetric(horizontal: 8),
                    borderColor: Colors.transparent,
                    filled: false,
                  ),
                ),
                10.horizontalSpace,
              ],

              const FilterWithBidgeWidget(),
              10.horizontalSpace,
              const FilterItem(title: "Make"),
              10.horizontalSpace,
              const FilterItem(title: "Price"),
              10.horizontalSpace,
              const FilterItem(title: "Year"),
              10.horizontalSpace,
              const FilterItem(title: "Mileage"),
              10.horizontalSpace,
              TextButton(
                onPressed: () => bloc.resetAllFilters(),
                child: AppText(
                  "Reset",
                  style: context.textTheme.titleMedium?.s13.m
                      .withColor(AppColors.primary),
                ),
              ),
              14.horizontalSpace,
            ],
          );
        },
      ),
    );
  }
}

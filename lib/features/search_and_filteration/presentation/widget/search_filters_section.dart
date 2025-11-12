import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:country_flags/country_flags.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_item.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/filter_with_bidge_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
          final countries = LocationsData.countries;
          final selectedCountry = state.isWorldwide
              ? countries.first
              : (LocationsData.findByCode(state.selectedCountryCode) ?? countries.first);
          final regions = (selectedCountry.secondLevel);
          final hasRegions = !state.isWorldwide && regions.isNotEmpty;

          return Padding(
            padding: HWEdgeInsets.only(left: 23, right: 10),
            child: Row(
              children: [
                // Always-visible Filters button with badge
                const FilterWithBidgeWidget(),
                10.horizontalSpace,

                // Scrollable filters area
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Country dropdown (with Worldwide)
                      SizedBox(
                        width: 145.w,
                        child: AppDropdownSearch<CountryOption>(
                          items: countries,
                          selectedItem: selectedCountry,
                          itemAsString: (co) => co.translatedName,
                          hintText: 'worldwide'.tr(),
                          baseStyle: context.textTheme.titleSmall.b
                              .withColor(AppColors.white),
                          dropdownBuilder: (context, co) {
                            final code = (co?.code ?? 'WW').toUpperCase();
                            final isWw = code == LocationsData.worldwideCode;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isWw)
                                  const Icon(Icons.public, size: 16)
                                else
                                  CountryFlag.fromCountryCode(
                                    code,
                                    theme: const ImageTheme(
                                      width: 18,
                                      height: 12,
                                      shape: RoundedRectangle(4),
                                    ),
                                  ),
                                4.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    co?.translatedName ?? 'worldwide'.tr(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.titleSmall.b
                                        .withColor(AppColors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            itemBuilder: (context, co, isSelected) {
                              final isWw = co.code == LocationsData.worldwideCode;
                              return Padding(
                                padding: HWEdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    if (isWw)
                                      const Icon(Icons.public, size: 18)
                                    else
                                      CountryFlag.fromCountryCode(
                                        co.code.toUpperCase(),
                                        theme: const ImageTheme(
                                          width: 20,
                                          height: 14,
                                          shape: RoundedRectangle(4),
                                        ),
                                      ),
                                    10.horizontalSpace,
                                    Expanded(child: Text(co.translatedName)),
                                  ],
                                ),
                              );
                            },
                          ),
                          onChanged: (co) => bloc.selectCountryByName(co?.name),
                          contentPadding: HWEdgeInsets.symmetric(horizontal: 6),
                          borderColor: Colors.transparent,
                          filled: false,
                        ),
                      ),
                      10.horizontalSpace,

                      // Region / City dropdown (depends on country)
                      if (hasRegions) ...[
                        SizedBox(
                          width: 125.w,
                          child: AppDropdownSearch<String>(
                            items: regions,
                            selectedItem: state.selectedRegionOrCity,
                            hintText: selectedCountry.translatedSecondLevelLabel ?? 'region'.tr(),
                            baseStyle: context.textTheme.titleSmall.b
                                .withColor(AppColors.white),
                            dropdownBuilder: (context, val) {
                              final text = val ?? (selectedCountry.translatedSecondLevelLabel ?? 'region'.tr());
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      text,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textTheme.titleSmall.b
                                          .withColor(AppColors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                            onChanged: (val) => bloc.selectRegionOrCity(val),
                            contentPadding: HWEdgeInsets.symmetric(horizontal: 6),
                            borderColor: Colors.transparent,
                            filled: false,
                          ),
                        ),
                        10.horizontalSpace,
                      ],

                      const FilterItem(title: "make"),
                      10.horizontalSpace,
                      const FilterItem(title: "price"),
                      10.horizontalSpace,
                      const FilterItem(title: "year"),
                      10.horizontalSpace,
                      const FilterItem(title: "mileage_label"),
                      10.horizontalSpace,
                      TextButton(
                        onPressed: () => bloc.resetAllFilters(),
                        child: AppText(
                          "reset",
                          style: context.textTheme.titleMedium?.s13.m
                              .withColor(AppColors.primary),
                        ),
                      ),
                      14.horizontalSpace,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

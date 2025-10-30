import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/cars_search_bar.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/search_filters_section.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearcgPageState();
}

class _SearcgPageState extends State<SearchPage> {
  late SearchCubit _searchCubit;

  @override
  void initState() {
    _searchCubit = GetIt.I<SearchCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              25.verticalSpace,
              const SearchItemsBar(),
              16.verticalSpace,
              const SearchFiltersSection(),
              14.verticalSpace,

              // عرض عدد النتائج
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final resultsCount = state.searchQuery.isEmpty
                      ? 0
                      : state.searchResults.length;
                  final hasActiveFilters = state.activeFilterCount() > 0;

                  return Padding(
                    padding: HWEdgeInsets.symmetric(horizontal: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          state.searchQuery.isEmpty
                              ? "Search for cars".tr()
                              : "$resultsCount Cars found".tr(),
                          style: context.textTheme.titleMedium?.s13.m
                              .withColor(AppColors.white),
                        ),
                        Row(
                          children: [
                            if (hasActiveFilters) ...[
                              AppElevatedButton(
                                onPressed: () => _searchCubit.resetAllFilters(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  side: const BorderSide(
                                      color: AppColors.primary, width: 0.7),
                                  padding: HWEdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20).r,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.filter_alt_off_rounded,
                                      size: 14.r,
                                      color: AppColors.primary,
                                    ),
                                    6.horizontalSpace,
                                    AppText(
                                      'Clear all filters'.tr(),
                                      style: context
                                          .textTheme.titleMedium?.s13.m
                                          .withColor(AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              12.horizontalSpace,
                            ],
                            Icon(
                              Icons.sort_outlined,
                              size: 12.r,
                            ),
                            5.horizontalSpace,
                            AppText(
                              "Sort by".tr(),
                              style: context.textTheme.titleMedium?.s13.m
                                  .withColor(AppColors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              const CustomDivider(indent: 10, endIndent: 10),

              // عرض النتائج
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    // حالة الخطأ
                    if (state.searchError != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              'Error: ${state.searchError}',
                              style: context.textTheme.bodyMedium
                                  ?.withColor(AppColors.white),
                            ),
                            20.verticalSpace,
                            ElevatedButton(
                              onPressed: () {
                                _searchCubit.searchCars();
                              },
                              child: AppText('Retry'.tr()),
                            ),
                          ],
                        ),
                      );
                    }

                    // التحقق من وجود فلاتر نشطة
                    final hasActiveFilters = state.activeFilterCount() > 0;
                    final hasSearchQuery = state.searchQuery.isNotEmpty;

                    // حالة عدم وجود نص بحث ولا فلاتر
                    if (!hasSearchQuery && !hasActiveFilters) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 80.r,
                              color: AppColors.white.withValues(alpha: 0.3),
                            ),
                            20.verticalSpace,
                            AppText(
                              'Search for cars or apply filters'.tr(),
                              style: context.textTheme.bodyLarge?.withColor(
                                  AppColors.white.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      );
                    }

                    // حالة عدم وجود نتائج
                    if (state.searchResults.isEmpty) {
                      return SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppEmptyState.foodsEmpty(),
                              if (hasActiveFilters) ...[
                                4.verticalSpace,
                                AppElevatedButton(
                                  onPressed: () =>
                                      _searchCubit.resetAllFilters(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    side: const BorderSide(
                                        color: AppColors.primary, width: 0.7),
                                    padding: HWEdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24).r,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.filter_alt_off_rounded,
                                        size: 16.r,
                                        color: AppColors.primary,
                                      ),
                                      8.horizontalSpace,
                                      AppText(
                                        'Clear all filters'.tr(),
                                        style: context
                                            .textTheme.titleMedium?.s13.m
                                            .withColor(AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    // عرض النتائج
                    return CarsListViewBuilder(
                      scrollDirection: Axis.vertical,
                      padding: HWEdgeInsetsDirectional.only(
                        start: 8,
                        end: 8,
                        top: 12,
                      ),
                      cars: state.searchResults,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: 328.w,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10).r),
      padding: HWEdgeInsetsDirectional.only(start: 36, end: 24),
      margin: HWEdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: [
          SizedBox(
            width: 24.r,
            child: const AppSvgPicture(
              Assets.svgSearch,
              color: Color(0xff8C9199),
            ),
          ),
          18.horizontalSpace,
          AppText(
            LocaleKeys.searchHereForCars,
            style: context.textTheme.bodyMedium?.r
                .withColor(AppColors.blackLight.withValues(alpha: 0.67)),
          ),
          60.horizontalSpace,
        ],
      ),
    );
  }
}

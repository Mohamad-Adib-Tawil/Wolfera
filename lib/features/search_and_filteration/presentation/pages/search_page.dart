import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/refresh_list_widget.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';
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
  late HomeCubit _homeCubit;
  @override
  void initState() {
    _homeCubit = GetIt.I<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: SafeArea(
        child: Scaffold(
          body: RefreshListWidget(
            onRefresh: _homeCubit.getHomeData,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                25.verticalSpace,
                const SearchItemsBar(),
                16.verticalSpace,
                const SearchFiltersSection(),
                14.verticalSpace,
                Padding(
                  padding: HWEdgeInsets.symmetric(horizontal: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        "89 Cars found",
                        style: context.textTheme.titleMedium?.s13.m
                            .withColor(AppColors.white),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.sort_outlined,
                            size: 12.r,
                          ),
                          5.horizontalSpace,
                          AppText(
                            "Sort by",
                            style: context.textTheme.titleMedium?.s13.m
                                .withColor(AppColors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const CustomDivider(indent: 10, endIndent: 10),
                Expanded(
                  child: CarsListViewBuilder(
                    scrollDirection: Axis.vertical,
                    padding:
                        HWEdgeInsetsDirectional.only(start: 8, end: 8, top: 12),
                  ),
                ),
              ],
            ),
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
                .withColor(AppColors.blackLight.withOpacity(0.67)),
          ),
          60.horizontalSpace,
        ],
      ),
    );
  }
}

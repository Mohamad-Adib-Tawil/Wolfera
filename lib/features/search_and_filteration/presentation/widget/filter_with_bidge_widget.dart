import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:badges/badges.dart' as badges;

class FilterWithBidgeWidget extends StatelessWidget {
  const FilterWithBidgeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GRouter.router.pushNamed(GRouter.config.filterRoutes.filter);
      },
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.center,
            width: 65.w,
            padding: HWEdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              // color: AppColors.grey.shade900,
              border: state.activeFilterCount() > 0
                  ? Border.all(color: AppColors.primary, width: 1.6.r)
                  : Border.all(color: AppColors.grey, width: 1.2.r),
            ),
            child: badges.Badge(
              position: badges.BadgePosition.bottomEnd(end: -8),
              showBadge: true,
              onTap: () {
                GRouter.router.pushNamed(GRouter.config.filterRoutes.filter);
              },
              badgeContent: Center(
                child: AppText(
                  state.activeFilterCount().toString(),
                  style: context.textTheme.bodySmall!.sb!.copyWith(
                    color: AppColors.white,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              badgeAnimation: const badges.BadgeAnimation.slide(),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: AppColors.blackLight,
                padding: HWEdgeInsets.all(3.5),
              ),
              child: AppSvgPicture(
                  state.activeFilterCount() > 0
                      ? Assets.svgFilterAcitve
                      : Assets.svgFilter,
                  width: 25.r),
            ),
          );
        },
      ),
    );
  }
}

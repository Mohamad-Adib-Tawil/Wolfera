import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';

class ListingTypeFilter extends StatelessWidget {
  const ListingTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Container(
          height: 35.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            children: [
              _buildChip(
                context: context,
                label: 'listing_types.all'.tr(),
                value: null,
                isSelected: state.selectedListingType == null,
                icon: Icons.all_inclusive,
              ),
              8.horizontalSpace,
              _buildChip(
                context: context,
                label: 'listing_types.for_sale'.tr(),
                value: 'sale',
                isSelected: state.selectedListingType == 'sale',
                icon: Icons.sell_outlined,
              ),
              8.horizontalSpace,
              _buildChip(
                context: context,
                label: 'listing_types.for_rent'.tr(),
                value: 'rent',
                isSelected: state.selectedListingType == 'rent',
                icon: Icons.car_rental,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required String? value,
    required bool isSelected,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<SearchCubit>().selectListingType(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            6.horizontalSpace,
            AppText(
              label,
              style: context.textTheme.bodyMedium?.s13.withColor(
                isSelected ? AppColors.white : AppColors.grey,
              ),
              translation: false,
            ),
          ],
        ),
      ),
    );
  }
}

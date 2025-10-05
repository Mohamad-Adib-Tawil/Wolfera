import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text_field.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class SearchItemsBar extends StatelessWidget {
  const SearchItemsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.I<SearchCubit>();

    return Container(
      height: 60.h,
      width: 380.w,
      margin: HWEdgeInsetsDirectional.only(end: 22),
      padding: EdgeInsets.zero,
      child: ReactiveForm(
        formGroup: bloc.form,
        child: Padding(
          padding: HWEdgeInsetsDirectional.only(start: 25, bottom: 5, top: 5),
          child: AppTextField(
            formControlName: "searchCars",
            hintText: LocaleKeys.searchHereForCars,
            hintTextStyle: context.textTheme.titleSmall?.s13.r
                .withColor(AppColors.white.withOpacity(0.67)),
            textInputAction: TextInputAction.search,
            maxLines: 1,
            borderWidth: 1.2.r,
            borderSideColor: AppColors.grey,
            prefixBoxConstraints: BoxConstraints(minWidth: 60.w),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 22, right: 12),
              child: Transform.translate(
                offset: Offset(2, 2.r),
                child: Center(
                  widthFactor: 0.1,
                  child: SizedBox(
                    width: 20.r,
                    child: const AppSvgPicture(
                      Assets.svgSearch,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

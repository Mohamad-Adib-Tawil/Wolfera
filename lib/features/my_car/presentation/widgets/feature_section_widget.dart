import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/feature_grid_view_item.dart';

class FeatureSection extends StatelessWidget {
  final String title;
  final String formControlName;

  final void Function()? onTap;
  const FeatureSection(
      {super.key,
      required this.title,
      this.onTap,
      required this.formControlName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                style: context.textTheme.bodyMedium?.s20.r
                    .withColor(AppColors.grey),
              ),
              InkWell(
                onTap: onTap,
                child: AppText(
                  'add_edit',
                  style: context.textTheme.bodySmall?.s14.r
                      .withColor(AppColors.grey),
                ),
              ),
            ],
          ),
          ReactiveValueListenableBuilder<List<String>?>(
            formControlName: formControlName,
            builder: (context, control, child) => GridView.builder(
              padding: HWEdgeInsets.only(top: 15),
              shrinkWrap: true,
              itemCount: control.value == null ? 0 : control.value?.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.4 / 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5),
              itemBuilder: (context, index) =>
                  FeatureGridViewItem(name: control.value?[index] ?? ""),
            ),
          )
        ],
      ),
    );
  }
}

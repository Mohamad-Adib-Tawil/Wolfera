import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/cars/presentation/widget/features_grid_view.dart';

class FeaturesListView extends StatelessWidget {
  final List<String> safetyFeatures;
  final List<String> interiorFeatures;
  final List<String> exteriorFeatures;
  
  const FeaturesListView({
    super.key,
    this.safetyFeatures = const [],
    this.interiorFeatures = const [],
    this.exteriorFeatures = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        if (safetyFeatures.isNotEmpty)
          ExpansionTile(
            iconColor: AppColors.grey,
            collapsedIconColor: AppColors.grey,
            title: AppText(
              'Safety',
              style:
                  context.textTheme.bodyMedium?.s18.b.withColor(AppColors.grey),
            ),
            children: [FeaturesGridView(features: safetyFeatures)],
          ),
        if (safetyFeatures.isNotEmpty) 5.verticalSpace,
        if (exteriorFeatures.isNotEmpty)
          ExpansionTile(
            iconColor: AppColors.grey,
            collapsedIconColor: AppColors.grey,
            title: AppText(
              'Exterior',
              style: context.textTheme.bodyMedium.s18.b.withColor(AppColors.grey),
            ),
            children: [FeaturesGridView(features: exteriorFeatures)],
          ),
        if (exteriorFeatures.isNotEmpty) 5.verticalSpace,
        if (interiorFeatures.isNotEmpty)
          ExpansionTile(
            collapsedIconColor: AppColors.grey,
            iconColor: AppColors.grey,
            title: AppText(
              'Interior',
              style: context.textTheme.bodyMedium.s18.b.withColor(AppColors.grey),
            ),
            children: [FeaturesGridView(features: interiorFeatures)],
          ),
      ],
    );
  }
}

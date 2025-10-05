import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/cars/presentation/widget/features_grid_view.dart';

class FeaturesListView extends StatelessWidget {
  const FeaturesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        ExpansionTile(
          iconColor: AppColors.grey,
          collapsedIconColor: AppColors.grey,
          title: AppText(
            'Safety',
            style:
                context.textTheme.bodyMedium?.s18.b.withColor(AppColors.grey),
          ),
          children: const [FeaturesGridView()],
        ),
        5.verticalSpace,
        ExpansionTile(
          iconColor: AppColors.grey,
          collapsedIconColor: AppColors.grey,
          title: AppText(
            'Exterior',
            style: context.textTheme.bodyMedium.s18.b.withColor(AppColors.grey),
          ),
          children: const [FeaturesGridView()],
        ),
        5.verticalSpace,
        ExpansionTile(
          collapsedIconColor: AppColors.grey,
          iconColor: AppColors.grey,
          title: AppText(
            'Interior',
            style: context.textTheme.bodyMedium.s18.b.withColor(AppColors.grey),
          ),
          children: const [FeaturesGridView()],
        ),
      ],
    );
  }
}

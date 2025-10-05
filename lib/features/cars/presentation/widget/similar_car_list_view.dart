import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/similar_car_item.dart';

class SimilarCarsListView extends StatelessWidget {
  const SimilarCarsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.only(left: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Similar',
            style: context.textTheme.bodyLarge!.s17.b.withColor(AppColors.grey),
          ),
          20.verticalSpace,
          SizedBox(
            height: 160.h,
            child: ListView.builder(
                padding: HWEdgeInsets.only(left: 8, right: 10),
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                      padding: HWEdgeInsets.only(right: 15),
                      child: const SimilarCarItem(),
                    )),
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}

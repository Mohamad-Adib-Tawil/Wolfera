import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/car_body_type_list_view.dart';

class BodyTypesFilterSection extends StatelessWidget {
  const BodyTypesFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: HWEdgeInsetsDirectional.only(start: 24, top: 20, bottom: 20),
          child: AppText(
            "Browse by body type",
            style: context.textTheme.bodyMedium.s20.sb,
          ),
        ),
        Container(
          margin: HWEdgeInsetsDirectional.only(end: 10),
          width: 1.sw,
          height: 50.h,
          child: const CarBodyTypeListView(),
        ),
      ],
    );
  }
}

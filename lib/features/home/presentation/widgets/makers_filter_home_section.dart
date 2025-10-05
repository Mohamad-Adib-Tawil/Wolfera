import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/maker_list_view_home.dart';

class MakersFilterHomeSection extends StatelessWidget {
  const MakersFilterHomeSection({
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
            "Browse by Makers",
            style: context.textTheme.bodyMedium.s20.sb,
          ),
        ),
        SizedBox(
          width: 1.sw,
          height: 60.h,
          child: const MakersListViewHome(),
        ),
      ],
    );
  }
}

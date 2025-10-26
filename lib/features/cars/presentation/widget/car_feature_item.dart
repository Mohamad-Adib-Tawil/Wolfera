import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class CarFeautreItem extends StatelessWidget {
  const CarFeautreItem({
    super.key,
    required this.featureName,
  });

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          AppSvgPicture(
            Assets.svgCheckCircle,
            width: 20.w,
          ),
          8.horizontalSpace,
          Flexible(
            child: AppText(
              featureName,
              translation: false,
              style: context.textTheme.titleMedium?.r,
            ),
          ),
        ],
      ),
    );
  }
}

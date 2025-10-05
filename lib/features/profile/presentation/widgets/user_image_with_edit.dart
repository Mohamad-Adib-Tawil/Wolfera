import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';

class UserImageWithEdit extends StatelessWidget {
  const UserImageWithEdit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          const CirclueUserImageWidget(
            width: 90,
          ),
          Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: HWEdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.white,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.blackLight,
                ),
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/generated/assets.dart';

class UserSectionWithLocation extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const UserSectionWithLocation({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch user data from user_id in carData
    // For now, use placeholder data
    final userName = carData['seller_name']?.toString() ?? 'Car Owner';
    final userLocation = carData['country']?.toString() ?? 
                        carData['city']?.toString() ?? 
                        carData['location']?.toString() ?? 
                        'Unknown Location';
    
    return Row(
      children: [
        const CirclueUserImageWidget(
          width: 80,
        ),
        25.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 200.w,
              child: AppText(
                userName,
                style: context.textTheme.bodyLarge!.s17.xb
                    .withColor(AppColors.white),
              ),
            ),
            7.verticalSpace,
            Row(
              children: [
                AppSvgPicture(
                  Assets.svgLocationPin,
                  height: 15.h,
                  width: 15.w,
                  color: AppColors.grey,
                ),
                9.horizontalSpace,
                SizedBox(
                  width: 200.w,
                  child: AppText(
                    userLocation,
                    style: context.textTheme.bodyLarge!.s17.r
                        .withColor(AppColors.grey),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

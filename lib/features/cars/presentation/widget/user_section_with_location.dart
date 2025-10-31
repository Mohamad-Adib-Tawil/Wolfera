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
    // استخراج بيانات المالك من owner object أو من carData مباشرة
    final owner = carData['owner'] as Map<String, dynamic>?;
    
    final userName = owner?['full_name']?.toString() ?? 
                     carData['seller_name']?.toString() ?? 
                     'Car Owner';
    
    final userCity = owner?['city']?.toString() ?? carData['city']?.toString();
    final userCountry = owner?['country']?.toString() ?? carData['country']?.toString();
    final userLocation = owner?['location']?.toString() ?? carData['location']?.toString();
    
    // بناء نص الموقع
    String locationText = 'Unknown Location';
    if (userCity != null && userCountry != null) {
      locationText = '$userCity, $userCountry';
    } else if (userCity != null) {
      locationText = userCity;
    } else if (userCountry != null) {
      locationText = userCountry;
    } else if (userLocation != null) {
      locationText = userLocation;
    }
    
    final avatarUrl = owner?['avatar_url']?.toString();
    
    return Row(
      children: [
        CirclueUserImageWidget(
          width: 80,
          userImage: avatarUrl,
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
                translation: false,
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
                    locationText,
                    translation: false,
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

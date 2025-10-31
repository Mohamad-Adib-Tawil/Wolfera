import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/home/presentation/widgets/similar_car_card_image.dart';
import 'package:wolfera/features/home/presentation/widgets/similar_car_card_info.dart';

class SimilarCarItem extends StatelessWidget {
  final Map<String, dynamic>? carData;
  final bool isFaviorateIcon;
  
  const SimilarCarItem({
    super.key,
    this.carData,
    this.isFaviorateIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GRouter.router.pushNamed(
        GRouter.config.homeRoutes.carDetails,
        extra: carData,
      ),
      child: Container(
        width: 335.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.grey, width: 0.9.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimilarCarCardImage(
              isFaviorateIcon: isFaviorateIcon,
              carData: carData,
            ),
            15.horizontalSpace,
            SimilarCarCardInfo(carData: carData),
          ],
        ),
      ),
    );
  }
}

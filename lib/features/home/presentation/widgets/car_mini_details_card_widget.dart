import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import '../../../app/presentation/widgets/bottom_section_car_mini_details_card.dart';
import '../../../app/presentation/widgets/status_section_widget.dart';
import '../../../app/presentation/widgets/top_secrion_car_mini_details_card.dart';

class CarMiniDetailsCardWidget extends StatelessWidget {
  const CarMiniDetailsCardWidget(
      {super.key,
      this.isFaviorateIcon = true,
      this.isStatus = false,
      this.image});
  final bool isFaviorateIcon;
  final bool isStatus;
  final String? image;

  @override
  Widget build(BuildContext context) {
    double h = isStatus ? 200.h + 60.h : 215.h;
    return GestureDetector(
      onTap: () =>
          GRouter.router.pushNamed(GRouter.config.homeRoutes.carDetails),
      child: Container(
        height: h,
        width: 320.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.greyStroke, width: 1.5.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSecrionCarMiniDetailsCard(
              isFaviorateIcon: isFaviorateIcon,
              image: image,
            ),
            const BottomSectionCarMiniDetailsCard(),
            if (isStatus) const StatusSectionWidget()
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import '../../../app/presentation/widgets/bottom_section_car_mini_details_card.dart';
import '../../../app/presentation/widgets/status_section_widget.dart';
import '../../../app/presentation/widgets/top_secrion_car_mini_details_card.dart';

class CarMiniDetailsCardWidget extends StatelessWidget {
  const CarMiniDetailsCardWidget({
    super.key,
    this.isFaviorateIcon = true,
    this.isStatus = false,
    this.image,
    this.title,
    this.spec1,
    this.spec2,
    this.mileage,
    this.fuel,
    this.location,
    this.price,
    this.carData,
    this.fullWidth = false,
  });
  final bool isFaviorateIcon;
  final bool isStatus;
  final String? image;
  final String? title;
  final String? spec1;
  final String? spec2;
  final String? mileage;
  final String? fuel;
  final String? location;
  final String? price;
  final Map<String, dynamic>? carData;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    double h = isStatus ? 200.h + 60.h : 215.h;
    
    // Check if this is a rental car
    final listingType = carData?['listing_type']?.toString();
    final isRental = listingType == 'rent' || listingType == 'both';
    
    return GestureDetector(
      onTap: () => GRouter.router.pushNamed(
        GRouter.config.homeRoutes.carDetails,
        extra: carData,
      ),
      child: Container(
        height: h,
        width: fullWidth ? double.infinity : 320.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.greyStroke, width: 1.5.r),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopSecrionCarMiniDetailsCard(
                  isFaviorateIcon: isFaviorateIcon,
                  image: image,
                  carData: carData,
                ),
                BottomSectionCarMiniDetailsCard(
                  title: title,
                  spec1: spec1,
                  spec2: spec2,
                  mileage: mileage,
                  fuel: fuel,
                  location: location,
                  price: price,
                ),
                if (isStatus) const StatusSectionWidget()
              ],
            ),
            // Rental/Sale Badge
            if (isRental)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: listingType == 'rent' 
                        ? AppColors.primary.withOpacity(0.9)
                        : Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        listingType == 'rent' ? Icons.car_rental : Icons.all_inclusive,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                      4.horizontalSpace,
                      AppText(
                        listingType == 'rent' ? 'For Rent' : 'Sale & Rent',
                        style: context.textTheme.bodySmall?.b.withColor(AppColors.white),
                        translation: false,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

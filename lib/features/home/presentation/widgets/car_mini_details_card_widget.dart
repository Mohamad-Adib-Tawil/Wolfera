import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
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
    
    // Listing type and status
    final listingType = carData?['listing_type']?.toString().toLowerCase();
    final status = carData?['status']?.toString().toLowerCase();
    final isSold = status == 'sold';
    
    // Compute sale and rent prices, and choose how to display them
    String? effectivePrice = price; // fallback single-line
    String? salePriceDisplay;
    String? rentPriceDisplay;
    if (carData != null) {
      final currency = carData!['currency']?.toString() ?? r'$';
      // Sale price
      salePriceDisplay = MoneyFormatter.compactFromString(
        carData!['price']?.toString(),
        symbol: currency,
      );
      // Rent price (first available period)
      String? rentalPrice() {
        final candidates = const [
          ['rental_price_per_day', 'day'],
          ['rental_price_per_week', 'week'],
          ['rental_price_per_month', 'month'],
          ['rental_price_per_3months', '3 months'],
          ['rental_price_per_6months', '6 months'],
          ['rental_price_per_year', 'year'],
        ];
        for (final c in candidates) {
          final raw = carData![c[0]];
          if (raw != null) {
            final num? v = raw is num ? raw : num.tryParse(raw.toString());
            if (v != null) {
              final compact = MoneyFormatter.compact(v, symbol: currency);
              if (compact != null) return '$compact / ${c[1]}';
            }
          }
        }
        return null;
      }
      rentPriceDisplay = rentalPrice();

      // Determine single or double-line price
      if (listingType == 'both') {
        // Show sale price on top, rent price under it
        // If one is missing, fall back to the other
        effectivePrice = salePriceDisplay ?? rentPriceDisplay ?? price;
      } else if (listingType == 'rent') {
        effectivePrice = rentPriceDisplay ?? price;
      } else {
        effectivePrice = salePriceDisplay ?? price;
      }
    }
    
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
                  // When listing is both, ensure sale is on top and rent below
                  price: listingType == 'both' ? (salePriceDisplay ?? effectivePrice) : effectivePrice,
                  secondPrice: listingType == 'both' ? rentPriceDisplay : null,
                ),
                if (isStatus) StatusSectionWidget(status: status)
              ],
            ),
            // Status/Listing Badges
            if (isSold)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sell_rounded,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                      4.horizontalSpace,
                      AppText(
                        'Sold',
                        style: context.textTheme.bodySmall?.b.withColor(AppColors.white),
                        translation: false,
                      ),
                    ],
                  ),
                ),
              )
            else if (listingType == 'rent' || listingType == 'both' || listingType == 'sale')
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: listingType == 'rent'
                        ? AppColors.primary.withOpacity(0.9)
                        : listingType == 'both'
                            ? Colors.green.withOpacity(0.9)
                            : Colors.blueGrey.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        listingType == 'rent'
                            ? Icons.car_rental
                            : listingType == 'both'
                                ? Icons.all_inclusive
                                : Icons.sell_outlined,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                      4.horizontalSpace,
                      AppText(
                        listingType == 'rent'
                            ? 'listing_types.for_rent'
                            : listingType == 'both'
                                ? 'listing_types.both'
                                : 'listing_types.for_sale',
                        style: context.textTheme.bodySmall?.b.withColor(AppColors.white),
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

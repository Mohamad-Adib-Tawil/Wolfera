import 'package:flutter/material.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/features/app/presentation/widgets/shimmer_loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCarsListViewBuilder extends StatelessWidget {
  const MyCarsListViewBuilder({
    super.key,
    required this.loadCarsStatus,
    required this.myCars,
  });

  final BlocStatus loadCarsStatus;
  final List<Map<String, dynamic>> myCars;

  @override
  Widget build(BuildContext context) {
    // حالة التحميل (وأيضًا الحالة الابتدائية لمنع وميض الحالة الفارغة)
    if (loadCarsStatus.isLoading() || loadCarsStatus.isInitial()) {
      return Shimmer(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 4,
          padding: HWEdgeInsets.only(bottom: 75),
          itemBuilder: (context, index) => Padding(
            padding: HWEdgeInsets.only(top: 20, right: 14, left: 14),
            child: ShimmerLoading(
              isLoading: true,
              child: _MyCarCardSkeleton(),
            ),
          ),
        ),
      );
    }

    // حالة الفراغ: لا توجد سيارات
    if (myCars.isEmpty) {
      return Center(
        child: AppEmptyState.foodsEmpty(),
      );
    }

    // عرض قائمة السيارات الفعلية
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: myCars.length,
      padding: HWEdgeInsets.only(bottom: 75),
      itemBuilder: (context, index) {
        final car = myCars[index];
        
        // استخراج البيانات من carData
        final imageUrls = (car['image_urls'] as List?)?.cast<dynamic>() ?? const [];
        final mainImage = car['main_image_url']?.toString();
        final imageUrl = imageUrls.isNotEmpty 
            ? imageUrls.first?.toString() 
            : mainImage;
        
        final title = [
          car['year']?.toString(),
          car['brand']?.toString(),
          car['model']?.toString()
        ].where((e) => e != null && e.isNotEmpty).join(' ');
        
        final spec1 = (car['body_type'] ?? car['engine_capacity'])?.toString();
        final spec2 = car['transmission']?.toString();
        final mileageVal = car['mileage']?.toString();
        final mileage = mileageVal != null && mileageVal.isNotEmpty
            ? '$mileageVal KM'
            : null;
        final fuel = car['fuel_type']?.toString();
        final location = (car['city'] ?? car['location'])?.toString();
        final priceVal = car['price']?.toString();
        final price = priceVal != null && priceVal.isNotEmpty
            ? '${priceVal}\$'
            : null;

        return Padding(
          padding: HWEdgeInsets.only(top: 20, right: 14, left: 14),
          child: CarMiniDetailsCardWidget(
            isFaviorateIcon: false,
            isStatus: true,
            image: imageUrl,
            title: title.isNotEmpty ? title : null,
            spec1: spec1,
            spec2: spec2,
            mileage: mileage,
            fuel: fuel,
            location: location,
            price: price,
            carData: car,
          ),
        );
      },
    );
  }
}

/// هيكل عظمي لكارت السيارة أثناء التحميل
class _MyCarCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double h = 215.h;
    return Container(
      height: h,
      width: 320.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // صورة علوية
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFFDCDCDC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 180.w, height: 14.h),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _line(width: 80.w, height: 10.h),
                    SizedBox(width: 12.w),
                    _line(width: 60.w, height: 10.h),
                    SizedBox(width: 12.w),
                    _line(width: 50.w, height: 10.h),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _line(width: 100.w, height: 12.h),
                    _line(width: 60.w, height: 12.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFDCDCDC),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

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
    // حالة التحميل (وأيضًا الحالة الابتدائية)
    if (loadCarsStatus.isLoading() || loadCarsStatus.isInitial()) {
      return Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutBack,
          builder: (context, t, child) => Transform.scale(
            scale: t,
            child: child,
          ),
          child: const AppLoader(
            // لون اللودر Primary كما طلبت
            color: AppColors.primary,
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

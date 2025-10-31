import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_description.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_section.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detalis_appbar.dart';
import 'package:wolfera/features/cars/presentation/widget/features_list_view.dart';
import 'package:wolfera/features/cars/presentation/widget/more_images_cars_list.dart';
import 'package:wolfera/features/cars/presentation/widget/seller_sction_detalis.dart';
import 'package:wolfera/features/cars/presentation/widget/similar_car_list_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';

class CarDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? carData;

  const CarDetailsPage({super.key, this.carData});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.carData ?? {};
    // Log car data for debugging purposes
    // ignore: avoid_print
    print('\n🚘 ========== CAR DETAILS PAGE ==========');
    // ignore: avoid_print
    print('🆔 Car ID: ${data['id']}');
    // ignore: avoid_print
    print('📝 Title: ${data['title']}');
    // ignore: avoid_print
    print('🏷️ Brand: ${data['brand']}');
    // ignore: avoid_print
    print('🏷️ Model: ${data['model']}');
    // ignore: avoid_print
    print('💰 Price: ${data['price']} ${data['currency']}');
    // ignore: avoid_print
    print('📍 Location: ${data['location']}');
    // ignore: avoid_print
    print('🛠️ Condition: ${data['condition']}');
    // ignore: avoid_print
    print('🧩 Full data payload:');
    data.forEach((key, value) {
      if (value is List) {
        // ignore: avoid_print
        print('   ▸ $key (${value.length} items): $value');
      } else {
        // ignore: avoid_print
        print('   ▸ $key: $value');
      }
    });

    // Extract all car data
    final imageUrls = (data['image_urls'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final mainImage = data['main_image_url']?.toString();
    final allImages = imageUrls.isNotEmpty ? imageUrls : (mainImage != null ? [mainImage] : <String>[]);
    
    final safetyFeatures = (data['safety_features'] as List?)?.cast<String>() ?? [];
    final interiorFeatures = (data['interior_features'] as List?)?.cast<String>() ?? [];
    final exteriorFeatures = (data['exterior_features'] as List?)?.cast<String>() ?? [];
    final description = data['description']?.toString() ?? '';
    
    final body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          8.verticalSpace,
          MoreImagesCarsList(images: allImages),
          10.verticalSpace,
          CarDetailsSection(carData: data),
          FeaturesListView(
            safetyFeatures: safetyFeatures,
            interiorFeatures: interiorFeatures,
            exteriorFeatures: exteriorFeatures,
          ),
          Padding(
            padding: HWEdgeInsets.symmetric(horizontal: 11),
            child:
                CustomDivider(color: AppColors.whiteLess, thickness: 0.6.r),
          ),
          if (description.isNotEmpty)
            CarDescription(description: description),
          Padding(
            padding:
                HWEdgeInsets.only(left: 11, right: 11, top: 10, bottom: 5),
            child:
                CustomDivider(color: AppColors.whiteLess, thickness: 0.6.r),
          ),
          SellerSctionDetalis(carData: data),
          SimilarCarsListView(currentCarData: data)
        ],
      ),
    );

    final carId = data['id']?.toString();
    final isFavorite = data['is_favorite'] == true || data['is_favourited'] == true;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? DelayedFadeSlide(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 1000),
                beginOffset: const Offset(0, -0.24),
                child: CarDetalisAppbar(
                  carId: carId,
                  initialIsFavorite: isFavorite,
                ),
              )
            : CarDetalisAppbar(
                carId: carId,
                initialIsFavorite: isFavorite,
              ),
      ),
      body: _shouldAnimateEntrance
          ? DelayedFadeSlide(
              delay: const Duration(milliseconds: 260),
              duration: const Duration(milliseconds: 1000),
              beginOffset: const Offset(-0.24, 0),
              child: body,
            )
          : body,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
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
import 'package:wolfera/services/search_and_filters_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class CarDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? carData;

  const CarDetailsPage({super.key, this.carData});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  Map<String, dynamic>? _enrichedData;
  bool _loadingOwner = false;

  @override
  void initState() {
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    // Try to enrich car data with owner info
    final id = widget.carData?['id']?.toString();
    if (id != null && id.isNotEmpty) {
      _loadingOwner = true;
      _fetchOwner(id);
    }
    super.initState();
  }

  Future<void> _fetchOwner(String carId) async {
    try {
      final svc = GetIt.I.isRegistered<SearchFilterService>()
          ? GetIt.I<SearchFilterService>()
          : SearchFilterService();
      final res = await svc.getCarWithOwner(carId);
      if (res != null && res.isNotEmpty && res['owner'] != null) {
        setState(() {
          _enrichedData = res;
          _loadingOwner = false;
        });
        return;
      }
      // Fallback: fetch user by user_id directly if join didn't return owner
      final userId = widget.carData?['user_id']?.toString();
      if (userId != null && userId.isNotEmpty) {
        final user = await SupabaseService.client
            .from('users')
            .select('id, full_name, email, phone_number, location, city, country, is_dealer, dealer_name, rating, total_reviews')
            .eq('id', userId)
            .maybeSingle();
        if (user != null) {
          setState(() {
            _enrichedData = {
              ...?widget.carData,
              'owner': user,
            };
            _loadingOwner = false;
          });
          return;
        }
      }
    } catch (_) {
      // ignore: avoid_print
      print('⚠️ Failed to fetch owner for car $carId');
    }
    if (mounted) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.carData ?? {};
    
    // Debug info about the car (only in debug mode)
    if (kDebugMode) {
      print('🚘 ========== CAR DETAILS PAGE ==========');
      print('🆔 Car ID: ${data['id']}');
      print('📝 Title: ${data['title']}');
      print('🏷️ Brand: ${data['brand']}');
      print('🏷️ Model: ${data['model']}');
      print('💰 Price: ${data['price']} ${data['currency']}');
      print('📍 Location: ${data['location']}');
      print('🛠️ Condition: ${data['condition']}');
      print('🧩 Full data payload:');
      data.forEach((key, value) {
        if (value is List) {
          print('   ▸ $key (${value.length} items): $value');
        } else {
          print('   ▸ $key: $value');
        }
      });
    }

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
          CarDetailsSection(carData: widget.carData ?? {}),
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
          SellerSctionDetalis(carData: widget.carData ?? {}),
          SimilarCarsListView(currentCarData: widget.carData ?? {}),
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? DelayedFadeSlide(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 1000),
                beginOffset: const Offset(0, -0.24),
                child: CarDetalisAppbar(carData: data),
              )
            : CarDetalisAppbar(carData: data),
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

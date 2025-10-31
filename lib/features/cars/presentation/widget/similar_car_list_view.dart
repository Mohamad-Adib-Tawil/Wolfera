import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/similar_car_item.dart';
import 'package:wolfera/services/search_and_filters_service.dart';

class SimilarCarsListView extends StatefulWidget {
  final Map<String, dynamic> currentCarData;
  
  const SimilarCarsListView({
    super.key,
    required this.currentCarData,
  });

  @override
  State<SimilarCarsListView> createState() => _SimilarCarsListViewState();
}

class _SimilarCarsListViewState extends State<SimilarCarsListView> {
  final _searchService = GetIt.I<SearchFilterService>();
  List<Map<String, dynamic>> _similarCars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSimilarCars();
  }

  Future<void> _loadSimilarCars() async {
    final carId = widget.currentCarData['id']?.toString();
    if (carId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final brand = widget.currentCarData['brand']?.toString();
    final country = widget.currentCarData['country']?.toString();
    final city = widget.currentCarData['city']?.toString();
    final price = widget.currentCarData['price'];
    
    // حساب نطاق السعر (±20%)
    double? minPrice;
    double? maxPrice;
    if (price != null) {
      final priceValue = price is num ? price.toDouble() : double.tryParse(price.toString());
      if (priceValue != null) {
        minPrice = priceValue * 0.8;
        maxPrice = priceValue * 1.2;
      }
    }

    try {
      final cars = await _searchService.getSimilarCars(
        currentCarId: carId,
        brand: brand,
        country: country,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: 4,
      );
      
      setState(() {
        _similarCars = cars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // إخفاء القسم إذا لم توجد سيارات مشابهة
    if (!_isLoading && _similarCars.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: HWEdgeInsets.only(left: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Similar',
            style: context.textTheme.bodyLarge!.s17.b.withColor(AppColors.grey),
          ),
          20.verticalSpace,
          SizedBox(
            height: 160.h,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : ListView.builder(
                    padding: HWEdgeInsets.only(left: 8, right: 10),
                    itemCount: _similarCars.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: HWEdgeInsets.only(right: 15),
                      child: SimilarCarItem(carData: _similarCars[index]),
                    ),
                  ),
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}

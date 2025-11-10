import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_item.dart';
import 'package:wolfera/features/cars/presentation/widget/car_name_and_price_row_widget.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detailes_grid_view.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class CarDetailsSection extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const CarDetailsSection({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    String? _stringValue(dynamic v) {
      if (v == null) return null;
      final s = v.toString();
      if (s.isEmpty || s == 'null') return null;
      return s;
    }

    final resolvedLocation = _stringValue(carData['country']) ??
        _stringValue(carData['city']) ??
        _stringValue(carData['location']);

    final List<Widget> items = [];
    void addItem(String title, dynamic value) {
      final s = _stringValue(value);
      if (s != null) {
        items.add(CarDetailsItem(title: title, value: s));
      }
    }
    void addBool(String title, dynamic value) {
      if (value is bool) {
        items.add(CarDetailsItem(title: title, value: value ? 'yes'.tr() : 'no'.tr()));
      }
    }

    addItem('brand'.tr(), carData['brand']);
    addItem('model'.tr(), carData['model']);
    addItem('year_model'.tr(), carData['year']);
    addItem('color'.tr(), carData['color']);
    addItem('trim'.tr(), carData['trim']);
    addItem('paint_parts'.tr(), carData['paint_parts']);
    addItem('plate'.tr(), carData['plate']);
    addItem('seat_material'.tr(), carData['seat_material']);
    addItem('wheels'.tr(), carData['wheels']);
    addItem('cylinders'.tr(), carData['cylinders']);
    addItem('seat_number'.tr(), carData['seats']);
    // metrics
    final mileage = _stringValue(carData['mileage']);
    if (mileage != null) {
      items.add(CarDetailsItem(title: 'mileage'.tr(), value: '$mileage KM'));
    }
    addItem('fuel_type'.tr(), carData['fuel_type']);
    addItem('doors'.tr(), carData['doors']);
    addItem('seats'.tr(), carData['seats']);
    addItem('cylinders'.tr(), carData['cylinders']);
    addItem('transmission'.tr(), carData['transmission']);
    addItem('car_filters.body_type'.tr(), carData['body_type']);
    addBool('accidents_history'.tr(), carData['accidents_history']);
    addBool('service_history'.tr(), carData['service_history']);
    addBool('warranty'.tr(), carData['warranty']);
    if (resolvedLocation != null) addItem('location'.tr(), resolvedLocation);

    // Rental prices (show if listing type is rent or both)
    final listingType = carData['listing_type']?.toString();
    if (listingType == 'rent' || listingType == 'both') {
      final currency = carData['currency']?.toString() ?? r'$';
      String? fmt(num? v) => MoneyFormatter.compact(v, symbol: currency);
      // For each available rental field, add an item
      void addRental(String title, dynamic raw) {
        if (raw == null) return;
        final num? val = raw is num ? raw : num.tryParse(raw.toString());
        final f = fmt(val);
        if (f != null) items.add(CarDetailsItem(title: title, value: f));
      }
      addRental('rental_labels.rent_per_day'.tr(), carData['rental_price_per_day']);
      addRental('rental_labels.rent_per_week'.tr(), carData['rental_price_per_week']);
      addRental('rental_labels.rent_per_month'.tr(), carData['rental_price_per_month']);
      addRental('rental_labels.rent_per_3months'.tr(), carData['rental_price_per_3months']);
      addRental('rental_labels.rent_per_6months'.tr(), carData['rental_price_per_6months']);
      addRental('rental_labels.rent_per_year'.tr(), carData['rental_price_per_year']);
    }

    return Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          CarNameAndPriceRowWidget(carData: carData),
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          5.verticalSpace,
          CarDetailesGridView(carData: carData),
          6.verticalSpace,
          CustomDivider(color: AppColors.whiteLess, thickness: 1.r),
          ...items,
          10.verticalSpace,
        ],
      ),
    );
  }
}

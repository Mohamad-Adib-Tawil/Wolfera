import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_details_item.dart';
import 'package:wolfera/features/cars/presentation/widget/car_name_and_price_row_widget.dart';
import 'package:wolfera/features/cars/presentation/widget/car_detailes_grid_view.dart';
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
        items.add(CarDetailsItem(title: title, value: value ? 'Yes' : 'No'));
      }
    }

    addItem('Brand', carData['brand']);
    addItem('Model', carData['model']);
    addItem('Year Model', carData['year']);
    addItem('Color', carData['color']);
    addItem('Trim', carData['trim']);
    addItem('Paint Parts', carData['paint_parts']);
    addItem('Plate', carData['plate']);
    addItem('Seat Material', carData['seat_material']);
    addItem('Wheels', carData['wheels']);
    addItem('Cylinders', carData['cylinders']);
    addItem('Seat Number', carData['seats']);
    addItem('Condition', carData['condition']);
    addItem('Vehicle Type', carData['body_type']);
    addItem('Gearbox', carData['transmission']);
    // metrics
    final mileage = _stringValue(carData['mileage']);
    if (mileage != null) {
      items.add(CarDetailsItem(title: 'Mileage', value: '$mileage KM'));
    }
    addItem('Fuel Type', carData['fuel_type']);
    addItem('Doors', carData['doors']);
    addItem('Drive Type', carData['drive_type']);
    addItem('Interior Color', carData['interior_color']);
    addItem('Exterior Color', carData['exterior_color']);
    addItem('Engine Capacity', carData['engine_capacity'] == null ? null : carData['engine_capacity']);
    // booleans
    addBool('Accidents History', carData['accidents_history']);
    addBool('Service History', carData['service_history']);
    addBool('Warranty', carData['warranty']);
    if (resolvedLocation != null) addItem('Location', resolvedLocation);

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

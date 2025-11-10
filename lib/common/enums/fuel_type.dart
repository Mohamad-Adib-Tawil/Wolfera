import 'package:easy_localization/easy_localization.dart';

enum FuelType {
  diesel('fuel_types.diesel'),
  gasoline('fuel_types.gasoline'),
  petrol('fuel_types.petrol'),
  electric('fuel_types.electric');

  final String translationKey;

  const FuelType(
    this.translationKey,
  );
  
  String get name => translationKey.tr();
}

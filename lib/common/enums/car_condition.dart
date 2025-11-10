import 'package:easy_localization/easy_localization.dart';

enum CarCondition {
  newCar('car_conditions.new'),
  usedCar('car_conditions.used'),
  ;

  final String translationKey;
  
  String get title => translationKey.tr();

  const CarCondition(
    this.translationKey,
  );
}

import 'package:wolfera/common/enums/car_makers.dart';

extension EnumEx on String {
  CarMaker toEnum() {
    return CarMaker.values.firstWhere(
      (c) => c.name.toLowerCase() == toLowerCase(),
      orElse: () => throw StateError('No matching CarMaker found for $this'),
    );
  }
}

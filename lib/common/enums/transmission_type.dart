import 'package:easy_localization/easy_localization.dart';

enum TransmissionType {
  automatic('transmission_types.automatic'),
  manual('transmission_types.manual'),
  semiAutomatic('transmission_types.semi_automatic');

  final String translationKey;

  const TransmissionType(
    this.translationKey,
  );
  
  String get name => translationKey.tr();
}

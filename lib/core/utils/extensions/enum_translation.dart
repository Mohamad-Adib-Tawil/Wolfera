import 'package:easy_localization/easy_localization.dart';

extension EnumTranslation on Enum {
  String tr(){
    return toString().tr();
  }
}
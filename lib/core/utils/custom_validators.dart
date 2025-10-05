import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PhoneNumberValidator extends Validator<dynamic> {
  static final RegExp phoneNumberRegex = RegExp(r'^\+\d+$');

  const PhoneNumberValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return (control.value == null) ||
            !phoneNumberRegex.hasMatch(control.value.toString())
        ? <String, dynamic>{tr(LocaleKeys.phoneNumberMustStart): true}
        : null;
  }
}

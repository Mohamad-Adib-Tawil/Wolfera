import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_textfeild.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_country_picker_bottom_sheet.dart';

class AddPhoneTextField extends StatefulWidget {
  const AddPhoneTextField({
    super.key,
    required this.controlName,
    required this.onCountrySelect,
  });

  final String controlName;
  final ValueChanged<Country> onCountrySelect;

  @override
  State<AddPhoneTextField> createState() => _AddPhoneTextFieldState();
}

class _AddPhoneTextFieldState extends State<AddPhoneTextField> {
  late ValueNotifier<Country> _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Default to UAE
    _selectedCountry = ValueNotifier(CountryParser.parsePhoneCode('971'));
    widget.onCountrySelect(_selectedCountry.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Country>(
      valueListenable: _selectedCountry,
      builder: (context, country, _) {
        return CustomTextField(
          hint: 'enter_phone_hint'.tr(),
          formControlName: widget.controlName,
          textInputType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          prefixIcon: InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              await showCustomCountryPicker(
                context: context,
                onSelect: (value) {
                  _selectedCountry.value = value;
                  widget.onCountrySelect(value);
                },
              );
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => FocusScope.of(context).unfocus(),
              );
            },
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromCountryCode(
                    country.countryCode,
                    theme: const ImageTheme(
                      width: 24,
                      height: 16,
                      shape: RoundedRectangle(3),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "+${country.phoneCode}",
                    style: context.textTheme.titleSmall
                        ?.copyWith(color: AppColors.blackLight),
                  ),
                  4.horizontalSpace,
                  VerticalDivider(
                    indent: 10.r,
                    endIndent: 10.r,
                    color: AppColors.blackLight,
                    width: 10.w,
                    thickness: 0.7,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _selectedCountry.dispose();
    super.dispose();
  }
}

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:country_flags/country_flags.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_country_picker_bottom_sheet.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../app/presentation/widgets/app_text.dart';
import '../../../auth/presentation/widgets/custom_textfeild.dart';
import '../manager/profile_bloc.dart';

class ProfilePhoneTextField extends StatefulWidget {
  const ProfilePhoneTextField({
    super.key,
    required this.controlName,
    required this.onSelect,
    required this.onInit,
  });

  final String controlName;
  final ValueChanged<Country> onSelect;
  final ValueChanged<Country> onInit;

  @override
  State<ProfilePhoneTextField> createState() => _ProfilePhoneTextFieldState();
}

class _ProfilePhoneTextFieldState extends State<ProfilePhoneTextField> {
  late final ValueNotifier<Country> _selectedCountry;
  late ProfileBloc profileBloc;

  @override
  void initState() {
    profileBloc = GetIt.I<ProfileBloc>();
    
    // Get the country code from the form
    final countryCodeValue = profileBloc.profileForm
        .control(profileBloc.kFromCountryCode).value as String?;
    
    // Parse the country from the code
    Country initialCountry = ProfileBloc.initCountry;
    if (countryCodeValue != null) {
      final parsedCountry = CountryParser.tryParsePhoneCode(countryCodeValue);
      if (parsedCountry != null) {
        initialCountry = parsedCountry;
      }
    }
    
    _selectedCountry = ValueNotifier(initialCountry);
    widget.onInit(_selectedCountry.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Country>(
        valueListenable: _selectedCountry,
        builder: (context, country, _) {
          return CustomTextField(
            hint: LocaleKeys.enterPhoneHint,
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
                    widget.onSelect(value);
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
                    AppText(
                      "+${country.phoneCode}",
                      style: context.textTheme.titleSmall
                          .withColor(AppColors.blackLight),
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
        });
  }
}

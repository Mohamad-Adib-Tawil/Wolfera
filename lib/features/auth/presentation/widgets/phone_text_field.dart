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
import '../bloc/auth_bloc.dart';
import 'custom_textfeild.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.controlName,
    required this.onSelect,
    required this.onInit,
  });

  final String controlName;
  final ValueChanged<Country> onSelect;
  final ValueChanged<Country> onInit;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late final ValueNotifier<Country> _selectedCountry;
  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = GetIt.I<AuthBloc>();
    _selectedCountry = ValueNotifier(authBloc.state.selectedCountry);
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
            textInputAction: TextInputAction.next,
            prefixIcon: InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                await showCustomCountryPicker(
                  context: context,
                  onSelect: (value) {
                    _selectedCountry.value = value;
                    authBloc.add(ChangeCountryEvent(country: value));
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
                    // 10.horizontalSpace,
                  ],
                ),
              ),
            ),
          );
        });
  }
}

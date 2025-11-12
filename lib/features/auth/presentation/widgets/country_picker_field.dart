import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class CountryPickerField extends StatefulWidget {
  final String controlName;
  final String initialValue;

  const CountryPickerField({
    Key? key,
    required this.controlName,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  late String _selectedDialCode;

  @override
  void initState() {
    super.initState();
    _selectedDialCode = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder<String>(
      formControlName: widget.controlName,
      builder: (context, control, child) {
        return GestureDetector(
          onTap: () => _showCountryPicker(context, control),
          child: Container(
            height: 60.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                _selectedDialCode,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCountryPicker(BuildContext context, AbstractControl<String> control) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedDialCode = '+${country.phoneCode}';
        });
        control.value = _selectedDialCode;
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: const Color(0xFF1E1F24),
        textStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey),
          ),
        ),
      ),
    );
  }
}

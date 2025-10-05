import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<String> items;
  final String hint;
  final TextStyle? hintStyle;
  final double? radius;
  final Color? background;
  final Color? arrowColor;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const CustomDropDownButton(
      {super.key,
      required this.items,
      this.onChanged,
      required this.hint,
      this.radius,
      this.arrowColor,
      this.background,
      this.hintStyle,
      this.validator});

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: widget.background,
        filled: widget.background != null,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffefeff0))),
        contentPadding: HWEdgeInsets.symmetric(
          vertical: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      hint: AppText(
        widget.hint,
        style: widget.hintStyle ??
            context.textTheme.bodyMedium?.s26.m.withColor(AppColors.grey),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: AppText(item, style: context.textTheme.bodyMedium.s26.m),
              ))
          .toList(),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: ButtonStyleData(
        padding: HWEdgeInsets.only(right: 24),
      ),
      iconStyleData: IconStyleData(
        icon: AppSvgPicture(
          Assets.svgArrowDown,
          fit: BoxFit.contain,
          width: 18.w,
          height: 11.h,
          color: widget.arrowColor,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

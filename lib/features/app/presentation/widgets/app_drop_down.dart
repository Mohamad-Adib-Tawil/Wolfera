import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';

import '../../../../core/utils/theme_state.dart';
import 'app_text.dart';

typedef DropdownSearchItemAsValue<T> = dynamic Function(T item);

class AppDropdownButtonFormField<T> extends StatefulWidget {
  const AppDropdownButtonFormField({
    this.itemAsValue,
    this.itemAsString,
    this.items = const [],
    required this.onChange,
    this.onSaved,
    this.onTap,
    this.validator,
    this.hint,
    this.menuMaxHeight,
    this.icon,
    this.focusNode,
    Key? key,
    this.value,
    this.title,
    this.textStyle,
  }) : super(key: key);

  final List<T> items;
  final T? value;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchItemAsValue<T>? itemAsValue;
  final ValueChanged onChange;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final VoidCallback? onTap;
  final String? hint;
  final double? menuMaxHeight;
  final Widget? icon;
  final FocusNode? focusNode;
  final String? title;
  final TextStyle? textStyle;

  @override
  State<AppDropdownButtonFormField> createState() =>
      _AppDropdownButtonFormFieldState();
}

class _AppDropdownButtonFormFieldState<T>
    extends ThemeState<AppDropdownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: false,
      items: widget.items
          .map(
            (item) => DropdownMenuItem<T>(
              value: widget.itemAsValue?.call(item) ?? item,
              child: AppText(
                widget.itemAsString?.call(item) ?? item.toString(),
                style: widget.textStyle ?? textTheme.titleSmall.r,
              ),
            ),
          )
          .toList(),
      onChanged: widget.onChange,
      onTap: widget.onTap,
      onSaved: widget.onSaved,
      validator: widget.validator,
      menuMaxHeight: widget.menuMaxHeight,
      icon: widget.icon ?? const SizedBox.shrink(),
      focusNode: widget.focusNode,
      value: widget.value,
      dropdownColor: colorScheme.borderTextField,
      isDense: true,
      alignment: Alignment.center,
      hint: widget.hint != null
          ? AppText(
              widget.hint!,
              style: textTheme.titleSmall
                  ?.copyWith(color: colorScheme.drawer.withOpacity(0.3)),
            )
          : null,
      borderRadius: BorderRadius.circular(8).r,
      style: textTheme.bodyMedium?.r,
      decoration: InputDecoration(
        filled: false,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        isCollapsed: false,
        isDense: false,
        suffixIcon: Icon(Icons.arrow_drop_down_rounded,
            color: widget.items.isEmpty
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.primary),
      ),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/state_ext.dart';
import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/config/theme/colors_app.dart';
import '../../../../core/utils/responsive_padding.dart';

class AppDropdownSearch<T> extends StatefulWidget {
  const AppDropdownSearch({
    super.key,
    this.items = const [],
    this.selectedItem,
    this.selectedItems = const [],
    this.asyncItems,
    this.onChanged,
    this.onChangedMultiSelection,
    this.dropdownBuilder,
    this.dropdownBuilderMultiSelection,
    this.itemAsString,
    this.filterFn,
    this.enabled = true,
    this.compareFn,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onSaved,
    this.onSavedMultiSelection,
    this.validator,
    this.validatorMultiSelection,
    this.onBeforeChange,
    this.onBeforeChangeMultiSelection,
    this.isMultiSelectionMode = false,
    this.clearButtonProps,
    this.dropdownButtonProps,
    this.popupProps,
    this.dropdownDecoratorProps,
    this.onBeforePopupOpening,
    this.onBeforePopupOpeningMultiSelection,
    this.hintText,
    this.hintSearch,
    this.filled = false,
    this.fillColor,
    this.borderColor,
    this.baseStyle,
    this.contentPadding,
  });

  ///offline items list
  final List<T> items;

  ///selected item
  final T? selectedItem;

  ///selected items
  final List<T> selectedItems;

  ///function that returns item from API
  final DropdownSearchOnFind<T>? asyncItems;

  ///called when a new item is selected
  final ValueChanged<T?>? onChanged;

  ///called when a new items are selected
  final ValueChanged<List<T>>? onChangedMultiSelection;

  ///to customize list of items UI
  final DropdownSearchBuilder<T>? dropdownBuilder;

  ///to customize list of items UI in MultiSelection mode
  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T>? itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T>? filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T>? compareFn;

  /// Used to configure the auto validation of [FormField] and [Form] widgets.
  final AutovalidateMode? autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T>? onSaved;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<List<T>>? onSavedMultiSelection;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T>? validator;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<List<T>>? validatorMultiSelection;

  /// callback executed before applying value change
  final BeforeChange<T>? onBeforeChange;

  /// callback executed before applying values changes
  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///define whatever we are in multi selection mode or single selection mode
  final bool isMultiSelectionMode;

  ///custom dropdown clear button icon properties
  final ClearButtonProps? clearButtonProps;

  ///custom dropdown icon button properties
  final DropdownButtonProps? dropdownButtonProps;

  ///custom props to single mode popup
  final PopupProps<T>? popupProps;

  ///dropdown decoration props
  final DropDownDecoratorProps? dropdownDecoratorProps;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpening<T>? onBeforePopupOpening;

  ///a callBack will be called before opening le popup
  ///if the callBack return FALSE, the opening of the popup will be cancelled
  final BeforePopupOpeningMultiSelection<T>? onBeforePopupOpeningMultiSelection;

  final String? hintText;
  final String? hintSearch;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? baseStyle;

  @override
  State<AppDropdownSearch<T>> createState() => _AppDropdownSearchState<T>();
}

class _AppDropdownSearchState<T> extends State<AppDropdownSearch<T>> {
  @override
  Widget build(BuildContext context) {
    final clearButtonProps =
        widget.clearButtonProps ?? const ClearButtonProps();

    final dropdownButtonProps = widget.dropdownButtonProps ??
        DropdownButtonProps(
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: widget.items.isEmpty
                  ? colorScheme.grey.withOpacity(0.3)
                  : colorScheme.grey),
        );

    final dropdownDecoratorProps = widget.dropdownDecoratorProps ??
        DropDownDecoratorProps(
            textAlignVertical: TextAlignVertical.center,
            dropdownSearchDecoration: InputDecoration(
              filled: widget.filled,
              fillColor: widget.fillColor,
              hintText: widget.hintText,
              hintStyle: context.textTheme.titleSmall.b
                  .withColor(AppColors.greyStroke),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0xffe2e2e3)),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0xffe2e2e3)),
                borderRadius: BorderRadius.circular(15.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0xffe2e2e3)),
                borderRadius: BorderRadius.circular(15.r),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.borderColor ?? const Color(0xffe2e2e3)),
                borderRadius: BorderRadius.circular(15.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: widget.borderColor ?? colorScheme.error),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: widget.borderColor ?? colorScheme.error),
                borderRadius: BorderRadius.circular(15.r),
              ),
              contentPadding: widget.contentPadding ??
                  HWEdgeInsetsDirectional.only(start: 12, end: 12),
              suffixIcon: Icon(Icons.arrow_drop_down_rounded,
                  color: widget.items.isEmpty
                      ? colorScheme.primary.withOpacity(0.3)
                      : colorScheme.primary),
            ),
            baseStyle: widget.baseStyle ??
                context.textTheme.titleSmall.b.withColor(AppColors.blackLight));

    final popupProps = widget.popupProps ??
        PopupPropsMultiSelection.dialog(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.grey.shade100.withAlpha(40),
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(kbrBorderTextField),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.grey.shade100.withAlpha(40),
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(kbrBorderTextField),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.grey.shade100.withAlpha(40),
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(kbrBorderTextField),
              ),
              filled: true,
              fillColor: AppColors.grey.shade100.withAlpha(40),
              contentPadding: HWEdgeInsetsDirectional.only(start: 16, end: 10),
              prefixIcon:
                  Icon(CupertinoIcons.search, color: AppColors.grey.shade600),
              hintText: widget.hintSearch,
              hintStyle: context.textTheme.bodyMedium.s13
                  .withColor(context.colorScheme.grey700),
            ),
          ),
          dialogProps: DialogProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kbrBorderTextField),
            ),
          ),
        );

    if (widget.isMultiSelectionMode) {
      return DropdownSearch<T>.multiSelection(
        enabled: widget.enabled,
        asyncItems: widget.asyncItems,
        autoValidateMode: widget.autoValidateMode,
        compareFn: widget.compareFn,
        clearButtonProps: clearButtonProps,
        dropdownButtonProps: dropdownButtonProps,
        dropdownDecoratorProps: dropdownDecoratorProps,
        filterFn: widget.filterFn,
        itemAsString: widget.itemAsString,
        items: widget.items,
        selectedItems: widget.selectedItems,
      );
    }

    return DropdownSearch<T>(
      validator: widget.validator,
      enabled: widget.enabled,
      asyncItems: widget.asyncItems,
      autoValidateMode: widget.autoValidateMode,
      compareFn: widget.compareFn,
      dropdownBuilder: widget.dropdownBuilder,
      clearButtonProps: clearButtonProps,
      dropdownButtonProps: dropdownButtonProps,
      dropdownDecoratorProps: dropdownDecoratorProps,
      popupProps: popupProps,
      filterFn: widget.filterFn,
      itemAsString: widget.itemAsString,
      items: widget.items,
      onBeforeChange: widget.onBeforeChange,
      onBeforePopupOpening: widget.onBeforePopupOpening,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      selectedItem: widget.selectedItem,
    );
  }
}

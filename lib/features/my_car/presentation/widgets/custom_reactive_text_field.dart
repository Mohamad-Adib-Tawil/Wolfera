import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/app_theme.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../../../../core/utils/responsive_padding.dart';

class CustomReactiveTextField extends StatefulWidget {
  const CustomReactiveTextField({
    Key? key,
    this.controller,
    this.onTap,
    this.onEditingComplete,
    this.onChange,
    this.onFieldSubmitted,
    this.onSaved,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.textInputType,
    this.textInputAction,
    this.textDirection,
    this.validator,
    this.maxLengthEnforcement,
    this.focusNode,
    this.autoValidateMode,
    this.scrollPhysics,
    this.scrollController,
    this.initialValue,
    this.keyboardAppearance,
    this.textAlignVertical,
    this.expands = false,
    this.readOnly = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.showLength = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.icon,
    this.hintTextStyle,
    this.textStyle,
    this.suffixIcon,
    this.suffix,
    this.hintText,
    this.labelText,
    this.inputFormatters,
    this.contentPadding,
    this.borderSideColor,
    this.filled,
    this.fillColor,
    this.labelTextStyle,
    this.translateHint = true,
    this.translateLabel = true,
    this.borderRadius,
    this.title,
    this.borderWidth,
    this.prefixBoxConstraints,
    this.initValue,
    this.formControlName,
    this.prefix,
  }) : super(key: key);

  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String? val)? onChange;
  final void Function(String val)? onFieldSubmitted;
  final void Function(String? val)? onSaved;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final FormFieldValidator<String?>? validator;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final FocusNode? focusNode;
  final AutovalidateMode? autoValidateMode;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final String? initialValue;
  final Brightness? keyboardAppearance;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final EdgeInsets scrollPadding;
  final bool expands;
  final bool readOnly;
  final bool autocorrect;
  final bool autofocus;
  final bool showLength;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? icon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderSideColor;
  final Color? fillColor;
  final bool? filled;
  final bool translateHint;
  final bool translateLabel;
  final TextStyle? labelTextStyle;
  final BorderRadius? borderRadius;
  final String? title;
  final double? borderWidth;
  final BoxConstraints? prefixBoxConstraints;
  final String? initValue;
  final String? formControlName;

  @override
  State<CustomReactiveTextField> createState() =>
      _CustomReactiveTextFieldState();
}

class _CustomReactiveTextFieldState extends State<CustomReactiveTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h,
      child: ReactiveTextField(
        controller: widget.controller,
        formControlName: widget.formControlName,
        onSubmitted: (value) => widget.onFieldSubmitted,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.showLength ? widget.maxLength : null,
        textAlign: widget.textAlign,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        textDirection: widget.textDirection,
        scrollPadding: widget.scrollPadding,
        expands: widget.expands,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        scrollPhysics: widget.scrollPhysics,
        scrollController: widget.scrollController,
        autocorrect: widget.autocorrect,
        autofocus: widget.autofocus,
        cursorColor: AppColors.primary,
        keyboardAppearance: widget.keyboardAppearance,
        textAlignVertical: widget.textAlignVertical,
        textCapitalization: widget.textCapitalization,
        validationMessages: {
          ValidationMessage.required: (error) => tr(LocaleKeys.required),
          ValidationMessage.email: (error) =>
              tr(LocaleKeys.auth_enterTheCorrectEmail),
          ValidationMessage.minLength: (error) =>
              tr(LocaleKeys.auth_enterAtLeastEightCharacters),
          ValidationMessage.mustMatch: (error) => tr(LocaleKeys.mustMatch),
          ValidationMessage.number: (error) =>
              tr(LocaleKeys.enterValidMobileNumber),
        },
        inputFormatters: [
          if (widget.maxLength != null)
            LengthLimitingTextInputFormatter(widget.maxLength),
          if (widget.textInputType == TextInputType.phone ||
              widget.textInputType == TextInputType.number) ...[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          ...?widget.inputFormatters
        ],
        style: widget.textStyle ??
            context.textTheme.bodyLarge?.m.withColor(AppColors.white)?.copyWith(
                  color: context.colorScheme.onSurface,
                  decoration: TextDecoration.none,
                ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: widget.borderWidth ?? 0,
              ),
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(kbrBorderTextField),
            ),
            contentPadding: widget.contentPadding ??
                HWEdgeInsetsDirectional.only(start: 0, end: 10),
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            prefixIconConstraints: widget.prefixBoxConstraints,
            icon: widget.icon,
            suffixIcon: widget.suffixIcon,
            suffix: widget.suffix,
            hintText:
                widget.translateHint ? widget.hintText?.tr() : widget.hintText,
            hintStyle: widget.hintTextStyle ??
                context.textTheme.bodyMedium?.s13.withColor(
                    context.colorScheme.drawer.withValues(alpha: 0.3)),
            labelText: widget.translateLabel
                ? widget.labelText?.tr()
                : widget.labelText,
            labelStyle: widget.labelTextStyle ??
                context.textTheme.bodyMedium?.s13
                    .withColor(context.colorScheme.hint),
            floatingLabelStyle: context.textTheme.bodyMedium?.m.s15
                .withColor(context.colorScheme.onSurface),
            errorStyle: context.textTheme.bodySmall?.m
                .withColor(AppColors.red.withValues(alpha: 0.8))),
      ),
    );
  }
}

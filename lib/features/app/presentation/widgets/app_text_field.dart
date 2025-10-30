import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/utils/responsive_padding.dart';

class AppTextField<T> extends StatefulWidget {
  const AppTextField({
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
    this.obscuringCharacter = "*",
    this.expands = false,
    this.readOnly = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.showLength = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.obscure = false,
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
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.borderSideColor,
    this.filled,
    this.fillColor,
    this.labelTextStyle,
    this.translateHint = true,
    this.translateLabel = true,
    this.borderRadius,
    this.title,
    this.borderWidth,
    this.isPasswordFiled = false,
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
  final String obscuringCharacter;
  final bool showLength;
  final bool obscure;
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
  final EditableTextContextMenuBuilder contextMenuBuilder;
  final Color? borderSideColor;
  final Color? fillColor;
  final bool? filled;
  final bool translateHint;
  final bool translateLabel;
  final TextStyle? labelTextStyle;
  final BorderRadius? borderRadius;
  final String? title;
  final double? borderWidth;
  final bool isPasswordFiled;
  final BoxConstraints? prefixBoxConstraints;
  final String? initValue;
  final String? formControlName;

  @override
  State<AppTextField> createState() => _AppTextFieldState();

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}

class _AppTextFieldState extends State<AppTextField> {
  late final ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    obscureNotifier = ValueNotifier(widget.isPasswordFiled);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: obscureNotifier,
        builder: (context, obscureValue, _) {
          return ReactiveTextField(
            controller: widget.controller,
            formControlName: widget.formControlName,
            onSubmitted: (value) => widget.onFieldSubmitted,
            maxLines: widget.isPasswordFiled ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.showLength ? widget.maxLength : null,
            textAlign: widget.textAlign,
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            textDirection: widget.textDirection,
            scrollPadding: widget.scrollPadding,
            expands: widget.expands,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            focusNode: widget.focusNode,
            obscureText: obscureValue,
            obscuringCharacter: widget.obscuringCharacter,
            readOnly: widget.readOnly,
            scrollPhysics: widget.scrollPhysics,
            scrollController: widget.scrollController,
            autocorrect: widget.autocorrect,
            autofocus: widget.autofocus,
            cursorColor: context.colorScheme.primary,
            keyboardAppearance: widget.keyboardAppearance,
            textAlignVertical: widget.textAlignVertical,
            textCapitalization: widget.textCapitalization,
            contextMenuBuilder: widget.contextMenuBuilder,
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
                context.textTheme.titleSmall?.r?.copyWith(
                  color: context.colorScheme.onSurface,
                  decoration: TextDecoration.none,
                  decorationColor: context.colorScheme.borderTextField,
                ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderSideColor ?? context.colorScheme.primary,
                  width: widget.borderWidth ?? 1,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: widget.borderWidth ?? 1.0,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderSideColor ?? context.colorScheme.primary,
                  width: widget.borderWidth ?? 1,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderSideColor ?? context.colorScheme.primary,
                  width: widget.borderWidth ?? 1.0,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderSideColor ?? context.colorScheme.error,
                  width: widget.borderWidth ?? 1.0,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderSideColor ?? context.colorScheme.error,
                  width: widget.borderWidth ?? 1.0,
                ),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(kbrBorderTextField),
              ),
              filled: widget.filled,
              fillColor: widget.fillColor,
              contentPadding: widget.contentPadding ??
                  HWEdgeInsetsDirectional.only(start: 16, end: 10),
              prefixIcon: widget.prefixIcon,
              prefix: widget.prefix,
              prefixIconConstraints: widget.prefixBoxConstraints,
              icon: widget.icon,
              suffixIcon: widget.isPasswordFiled
                  ? eyeIcon(obscureValue)
                  : widget.suffixIcon,
              suffix: widget.suffix,
              hintText: widget.translateHint
                  ? widget.hintText?.tr()
                  : widget.hintText,
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
            ),
          );
        });
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Builds an [IconButton] which is used as a suffix icon for password fields.
  /// The icon is an eye or an eye with a slash depending on [obscure].
  /// The icon color is the primary color of the color scheme.
  /// The icon is pressed to toggle the value of [obscureNotifier].
  ///
  /// ****  b1975b12-7980-466b-aef2-cc760d82956b  ******
  Widget eyeIcon(bool obscure) {
    return IconButton(
      onPressed: () => obscureNotifier.value = !obscure,
      icon: Icon(obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
          color: context.colorScheme.primary),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/num.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../../../../core/utils/theme_state.dart';
import 'app_text.dart';
import 'loading_indicator.dart';

enum AppButtonStyle {
  primary,
  secondary,
}

class AppElevatedButton extends StatefulWidget {
  const AppElevatedButton({
    Key? key,
    this.onPressed,
    this.onDisabled,
    this.child,
    this.text,
    this.isLoading = false,
    this.sensitiveNetwork = false,
    this.appButtonStyle,
    this.textStyle,
    this.style,
  }) : super(key: key);

  final Function()? onPressed;
  final Function()? onDisabled;
  final Widget? child;
  final String? text;
  final bool isLoading;
  final AppButtonStyle? appButtonStyle;
  final ButtonStyle? style;
  final bool sensitiveNetwork;
  final TextStyle? textStyle;

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends ThemeState<AppElevatedButton> {
  ElevatedButtonThemeData? _buttonTheme;

  bool get absorbing => widget.onDisabled != null ? false : widget.isLoading;

  CrossFadeState get crossFadeState =>
      widget.isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst;

  Function()? get onTap =>
      widget.isLoading ? widget.onDisabled?.call() ?? () {} : widget.onPressed;

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.text == null && widget.child == null) {
        throw FlutterError("Can't be both text and child is null");
      }
      // if (widget.style != null && widget.appButtonStyle != null) {
      //   throw FlutterError("Can't be pass both style and tripperButtonStyle");
      // }
      return true;
    }());

    setButtonStyle();

    final baseStyle = widget.style ?? _buttonTheme?.style;

    final child = ElevatedButton(
      onPressed: widget.isLoading ? null : onTap,
      style: baseStyle ?? ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 56.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: AnimatedCrossFade(
        firstChild: firstChild,
        secondChild: secondChild,
        duration: 300.milliseconds,
        crossFadeState: crossFadeState,
      ),
    );

    // if (widget.sensitiveNetwork) {
    //   return NetworkBlocSensitive(child: child);
    // }

    return child;
  }

  Widget get secondChild => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: AppText(
              LocaleKeys.requestIsInProgress,
              style: context.textTheme.bodySmall!.s20.xb
                  .withColor(AppColors.blackLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.isLoading) ...[
            8.horizontalSpace,
            const LoadingIndicator(),
            4.horizontalSpace,
          ],
        ],
      );

  Widget get firstChild => widget.child ??
      AppText(
        widget.text!.tr(),
        style: widget.textStyle,
      );

  void setButtonStyle() {
    final defaultElevatedTheme = theme.elevatedButtonTheme;

    final secondaryElevatedTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape: defaultElevatedTheme.style?.shape?.resolve({}),
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          elevation: 0.0,
          shadowColor: colorScheme.white.withValues(alpha: 0.1),
          textStyle: widget.textStyle,
          side: const BorderSide(color: AppColors.primary, width: 0.7)),
    );

    final loadingElevatedTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: defaultElevatedTheme.style?.shape?.resolve({}),
        backgroundColor: AppColors.primary,
        foregroundColor: colorScheme.outline,
        textStyle: widget.textStyle,
      ),
    );

    _buttonTheme = widget.isLoading
        ? loadingElevatedTheme
        : widget.appButtonStyle == AppButtonStyle.secondary
            ? secondaryElevatedTheme
            : defaultElevatedTheme;
  }
}

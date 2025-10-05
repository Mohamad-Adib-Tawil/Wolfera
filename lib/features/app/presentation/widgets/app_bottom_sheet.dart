import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';

class AppBottomSheet<T> extends StatelessWidget {
  const AppBottomSheet._({
    Key? key,
    required this.child,
    required this.showCloseIcon,
  }) : super(key: key);

  final Widget child;
  final bool showCloseIcon;

  static Future<T?> show<T>({
    required BuildContext context,
    required final Widget child,
    final bool? enableDrag,
    final bool? isDismissible,
    final bool? isScrollControlled,
    final Color? backgroundColor,
    final Color? barrierColor,
    final bool showCloseIcon = true,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        enableDrag: enableDrag ?? true,
        isDismissible: isDismissible ?? true,
        isScrollControlled: isScrollControlled ?? true,
        barrierColor: barrierColor,
        backgroundColor: backgroundColor ?? context.colorScheme.background,
        builder: (_) =>
            AppBottomSheet._(showCloseIcon: showCloseIcon, child: child),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

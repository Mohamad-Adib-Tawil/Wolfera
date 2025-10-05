import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animationController!,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                if (_animationController!.isCompleted) {
                  _animationController!.reverse();
                } else {
                  _animationController!.forward();
                }
                widget.value == false
                    ? widget.onChanged(true)
                    : widget.onChanged(false);
              },
              child: Container(
                width: 48.0.w,
                height: 24.0.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0.r),
                    color: widget.value
                        ? AppColors.primary.shade100
                        : const Color(0xfffdeeed)),
                child: Padding(
                  padding: HWEdgeInsets.only(
                      top: 2.4, bottom: 2.4, left: 2.4, right: 2.4),
                  child: Container(
                    alignment: widget.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 19.18.w,
                      height: 19.18.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              widget.value ? AppColors.primary : AppColors.red),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        12.horizontalSpace,
        AppText(
          widget.value ? "On" : "Off",
          style: context.textTheme.labelSmall.s21.m,
        )
      ],
    );
  }
}

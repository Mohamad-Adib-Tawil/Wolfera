import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CustomRadioButton extends StatefulWidget {
  final bool isSelected;

  final String title;
  final String subtitle;
  final String icon;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              width: 347.w,
              height: 68.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8).r,
                color: const Color(0xffFEFEFD),
                border: widget.isSelected == true
                    ? Border.all(color: const Color(0xff6080a0), width: 1.5)
                    : Border.all(
                        color: const Color(0xff6080a0).withOpacity(0.88),
                        width: 0.5),
              ),
              child: Padding(
                padding:
                    HWEdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SimpleShadow(
                      opacity: 0.1,
                      color: Colors.black,
                      offset: const Offset(0, 0),
                      sigma: 2,
                      child: Container(
                        alignment: Alignment.center,
                        width: 47.0.w,
                        height: 47.0.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF).withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: AppSvgPicture(
                          widget.icon,
                        ),
                      ),
                    ),
                    13.horizontalSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.title,
                          style: context.textTheme.titleMedium?.s15
                              .withColor(AppColors.blackLight),
                        ),
                        4.verticalSpace,
                        AppText(
                          widget.subtitle,
                          style: context.textTheme.bodySmall.r
                              ?.copyWith(color: AppColors.blackLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 20.w),
                child: widget.isSelected == true
                    ? SvgPicture.asset(Assets.svgCheck)
                    : const SizedBox()),
          ),
        ],
      ),
    );
  }
}

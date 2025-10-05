import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class DotsIndicator extends AnimatedWidget {
  const DotsIndicator(
      {super.key,
      required this.controller,
      required this.itemCount,
      required this.onPageSelected,
      this.color = Colors.white})
      : super(listenable: controller);
  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;
  static const double _kDotSize = 11.0;
  static const double _kMaxZoom = 2.0;
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(max(
      0.0,
      1.0 -
          ((controller.hasClients
                      ? controller.page ?? 0
                      : controller.initialPage) -
                  index)
              .abs(),
    ));
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;

    return SizedBox(
      width: _kDotSpacing.w,
      height: _kDotSpacing.h,
      child: Center(
        child: Container(
          width: _kDotSize
          // * zoom
          ,
          height: _kDotSize
          //  * zoom
          ,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: selectedness > 0.5
                ? [
                    BoxShadow(
                      color: AppColors.white.withOpacity(0.85),
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                    ),
                  ]
                : null,
          ),
          child: InkWell(onTap: () => onPageSelected(index)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

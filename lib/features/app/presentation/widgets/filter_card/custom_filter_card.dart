import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/filter_card/filter_card_painter.dart';

class CustomFilterCard extends StatelessWidget {
  final bool isSelected;
  final String text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const CustomFilterCard({
    super.key,
    required this.isSelected,
    required this.text,
    required this.textStyle,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 35.h,
      width: width ?? 83.w,
      child: ClipPath(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        clipper: FilterCustomClip(),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: height ?? 35.h,
            width: width ?? 83.w,
            decoration: BoxDecoration(color: context.theme.cardColor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13).r,
              child: CustomPaint(
                painter: FilterCustomBorder(
                    borderThickness: isSelected == true ? 4.r : 3.r,
                    borderColor: isSelected == true
                        ? context.colorScheme.primary
                        : context.colorScheme.primary.withOpacity(0.15)),
                child: Center(
                  child: SizedBox(
                    width: width != null ? width! - 20.w : 78.w,
                    child: Center(
                      child: AppText(text,
                          maxLines: 1,
                          scrollText: true,
                          textAlign: TextAlign.center,
                          style: isSelected == true
                              ? context.textTheme.bodySmall.b
                                  .withColor(AppColors.blackLight)
                              : context.textTheme.bodySmall.m
                                  .withColor(AppColors.blackLight)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum CustomFilterCardType {
  restaurantAndFood,
  foodsType,
}

class CustomFilterCardTypeProperties {
  final double selectedBorderThickness;
  final double unSelectedBorderThickness;
  final TextStyle selectedTextStyle;
  final TextStyle unSelectedTextStyle;

  const CustomFilterCardTypeProperties({
    required this.selectedBorderThickness,
    required this.unSelectedBorderThickness,
    required this.selectedTextStyle,
    required this.unSelectedTextStyle,
  });
}

var customFilterCardTypeProperties = {
  CustomFilterCardType.restaurantAndFood: CustomFilterCardTypeProperties(
    selectedBorderThickness: 4,
    unSelectedBorderThickness: 3,
    selectedTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.blackLight,
    ),
    unSelectedTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.blackLight,
    ),
  ),
  CustomFilterCardType.foodsType: CustomFilterCardTypeProperties(
    selectedBorderThickness: 10,
    unSelectedBorderThickness: 4,
    selectedTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.blackLight,
    ),
    unSelectedTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.blackLight,
    ),
  ),
};

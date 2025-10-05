import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final void Function()? onTap;
  const CustomTextButton({
    super.key,
    required this.title,
    this.height,
    this.width,
    this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 351.w,
        height: height ?? 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 7,
              spreadRadius: -2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.95),
              Color.fromRGBO(255, 255, 255, 0.99),
            ],
            stops: [0.0097, 0.9973],
          ),
        ),
        child: Center(
          child: AppText(
            title,
            style: textStyle ??
                GoogleFonts.tajawal(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: AppColors.blackLight),
          ),
        ),
      ),
    );
  }
}

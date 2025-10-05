import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class CarImageViewer extends StatelessWidget {
  final String imagePath;
  const CarImageViewer({
    super.key,
    this.width = 350,
    this.height = 176,
    this.isSelected = false,
    required this.imagePath,
  });
  final double width;
  final double height;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10).r,
        child: Image.asset(
          imagePath,
          width: width.w,
          height: height.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

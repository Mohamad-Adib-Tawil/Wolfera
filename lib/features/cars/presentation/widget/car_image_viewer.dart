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
    this.heroTag,
  });
  final double width;
  final double height;
  final bool isSelected;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    // Check if image is a network URL or local asset
    final isNetworkImage = imagePath.startsWith('http://') || imagePath.startsWith('https://');
    
    final imageWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10).r,
        child: isNetworkImage
            ? Image.network(
                imagePath,
                width: width.w,
                height: height.h,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: width.w,
                    height: height.h,
                    color: AppColors.greyStroke,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: width.w,
                    height: height.h,
                    color: AppColors.greyStroke,
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              )
            : Image.asset(
                imagePath,
                width: width.w,
                height: height.h,
                fit: BoxFit.cover,
              ),
      ),
    );
    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(tag: heroTag!, child: imageWidget);
    }
    return imageWidget;
  }
}

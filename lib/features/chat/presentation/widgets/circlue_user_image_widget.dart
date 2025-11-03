import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';

class CirclueUserImageWidget extends StatelessWidget {
  const CirclueUserImageWidget({
    super.key,
    this.width = 60,
    this.userImage,
    this.height,
  });
  final double width;
  final double? height;
  final String? userImage;
  @override
  Widget build(BuildContext context) {
    final String? url = (userImage != null &&
            userImage!.trim().isNotEmpty &&
            (Uri.tryParse(userImage!)?.hasScheme == true))
        ? userImage
        : null;
    if (kDebugMode) {
      print('[Avatar] Image URL: $url');
    }
    return Container(
      width: width.w,
      height: (height?.h ?? width.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: url != null
            ? CachedNetworkImage(
                key: ValueKey(url),
                fit: BoxFit.cover,
                imageUrl: url,
                width: width.w,
                height: (height?.h ?? width.w),
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (context, _) => Shimmer.fromColors(
                  period: const Duration(milliseconds: 1000),
                  baseColor: AppColors.grey.withValues(alpha: 0.15),
                  highlightColor: AppColors.primary.withValues(alpha: 0.25),
                  child: Container(
                    width: width.w,
                    height: (height?.h ?? width.w),
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, failedUrl, error) {
                  if (kDebugMode) {
                    print('[Avatar] Load error: $error | URL: $failedUrl');
                  }
                  return AppSvgPicture(
                    Assets.svgNoProfilePicture,
                    width: width.w,
                    height: (height?.h ?? width.w),
                    fit: BoxFit.cover,
                  );
                },
              )
            : AppSvgPicture(
                Assets.svgNoProfilePicture,
                width: width.w,
                height: (height?.h ?? width.w),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

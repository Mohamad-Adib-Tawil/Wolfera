import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/favorate_icon_widget.dart';
import 'package:wolfera/generated/assets.dart';

class SimilarCarCardImage extends StatelessWidget {
  final Map<String, dynamic>? carData;
  final bool isFaviorateIcon;
  
  const SimilarCarCardImage({
    super.key,
    this.carData,
    required this.isFaviorateIcon,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = carData?['main_image_url']?.toString() ??
                     (carData?['image_urls'] as List?)?.firstOrNull?.toString();
    
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.r),
        bottomLeft: Radius.circular(10.r),
      ),
      child: SizedBox(
        width: 135.w,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxHeight * (16 / 9),
                  height: constraints.maxHeight,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                          placeholder: (context, url) => Container(
                            color: AppColors.grey.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const AppSvgPicture(
                            Assets.imagesCar1,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerLeft,
                          ),
                        )
                      : const AppSvgPicture(
                          Assets.imagesCar1,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                        ),
                );
              },
            ),
            isFaviorateIcon ? const FavorateIconWidget() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

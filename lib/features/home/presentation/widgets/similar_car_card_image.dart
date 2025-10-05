import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/favorate_icon_widget.dart';
import 'package:wolfera/generated/assets.dart';

class SimilarCarCardImage extends StatelessWidget {
  const SimilarCarCardImage({
    super.key,
    required this.isFaviorateIcon,
  });

  final bool isFaviorateIcon;

  @override
  Widget build(BuildContext context) {
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
                  child: const AppSvgPicture(
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

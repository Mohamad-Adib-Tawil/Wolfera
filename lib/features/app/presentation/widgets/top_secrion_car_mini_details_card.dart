import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/favorate_icon_widget.dart';
import 'package:wolfera/generated/assets.dart';

class TopSecrionCarMiniDetailsCard extends StatelessWidget {
  const TopSecrionCarMiniDetailsCard({
    super.key,
    required this.isFaviorateIcon,
    this.image,
    this.carData,
  });
  final String? image;
  final bool isFaviorateIcon;
  final Map<String, dynamic>? carData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          border:
              Border(bottom: BorderSide(color: AppColors.grey, width: 1.5.w)),
          image: DecorationImage(
            image: (image != null && (image!.startsWith('http://') || image!.startsWith('https://')))
                ? NetworkImage(image!) as ImageProvider
                : AssetImage(image ?? Assets.imagesCar2),
            fit: BoxFit.cover,
          )),
      child: isFaviorateIcon
          ? FavorateIconWidget(carData: carData ?? const <String, dynamic>{})
          : const SizedBox(),
    );
  }
}

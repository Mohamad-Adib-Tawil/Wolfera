import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/assets.dart';
import 'app_svg_picture.dart';

class AppCachedNetworkImageView extends StatelessWidget {
  final String url;
  final Function()? function;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Widget? placeHolder;
  final double? width;
  final double? height;
  final double? logoWidth;
  final double? logoHeight;
  final Color? logoColor;

  const AppCachedNetworkImageView({
    Key? key,
    required this.url,
    this.function,
    this.fit,
    this.errorWidget,
    this.width,
    this.height,
    this.placeHolder,
    this.logoHeight,
    this.logoWidth,
    this.logoColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        placeholder: (context, imageUrl) => Center(
          child: placeHolder,
        ),
        errorWidget: (context, imageUrl, error) => Center(
          child: errorWidget ??
              AppSvgPicture(
                Assets.imagesLogo,
                width: logoWidth ?? 200.r,
                height: logoHeight ?? 200.r,
                color: logoColor,
              ),
        ),
      ),
    );
  }
}

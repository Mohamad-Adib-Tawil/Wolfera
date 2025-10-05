import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CircleImageProfile extends StatelessWidget {
  final String? image;
  final double height;
  final double width;
  const CircleImageProfile({
    super.key,
    required this.image,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(60),
        child: image != "" && image != null
            ? CachedNetworkImage(
                imageUrl: image!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  return Container(
                    color: AppColors.primary,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const AppText("MA"),
                  );
                },
                fit: BoxFit.cover,
              )
            : Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                ),
                padding: HWEdgeInsets.all(30),
                child: AppText(
                  "MA",
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelMedium.s42.sb,
                ),
              ),
      ),
    );
  }
}

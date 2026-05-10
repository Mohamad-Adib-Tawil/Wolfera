import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_cached_network_image.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/car_stores/domain/entities/car_publisher.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/generated/assets.dart';

class CarStoreCard extends StatelessWidget {
  const CarStoreCard({
    super.key,
    required this.publisher,
    required this.onTap,
  });

  final CarPublisher publisher;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final location = _resolveLocation();

    return Padding(
      padding: HWEdgeInsetsDirectional.only(start: 14, end: 14, bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          padding: HWEdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.dark.shade600.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CirclueUserImageWidget(
                        width: 60,
                        userImage: publisher.avatarUrl,
                      ),
                      if (publisher.isDealer)
                        PositionedDirectional(
                          end: -2,
                          bottom: -2,
                          child: Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.dark.shade600,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.verified_rounded,
                              color: AppColors.white,
                              size: 12.r,
                            ),
                          ),
                        ),
                    ],
                  ),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          publisher.name == 'seller'
                              ? 'seller'.tr()
                              : publisher.name,
                          translation: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium!.s17.b
                              .withColor(AppColors.white),
                        ),
                        7.verticalSpace,
                        Row(
                          children: [
                            AppSvgPicture(
                              Assets.svgNavCarSell,
                              height: 14.h,
                              width: 14.w,
                              color: AppColors.orange,
                            ),
                            6.horizontalSpace,
                            Flexible(
                              child: AppText(
                                '${publisher.carsCount} ${'listed_cars'.tr()}',
                                translation: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium!.s13
                                    .withColor(AppColors.greyStroke),
                              ),
                            ),
                          ],
                        ),
                        if (location != null) ...[
                          6.verticalSpace,
                          Row(
                            children: [
                              AppSvgPicture(
                                Assets.svgLocationPin,
                                height: 13.h,
                                width: 13.w,
                                color: AppColors.grey,
                              ),
                              6.horizontalSpace,
                              Flexible(
                                child: AppText(
                                  location,
                                  translation: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall!.s13
                                      .withColor(AppColors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  _OpenStoreButton(),
                ],
              ),
              if (publisher.previewImageUrls.isNotEmpty ||
                  publisher.latestCarTitle != null) ...[
                14.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: _LatestListingText(
                        latestCarTitle: publisher.latestCarTitle,
                      ),
                    ),
                    12.horizontalSpace,
                    _CarsPreview(images: publisher.previewImageUrls),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _resolveLocation() {
    final city = publisher.city;
    final country = publisher.country;

    final translatedCountry =
        country != null ? CarValueTranslator.translateCountry(country) : null;
    final translatedCity = city != null
        ? CarValueTranslator.translateCity(city, country: country)
        : null;

    if (translatedCity != null &&
        translatedCity.isNotEmpty &&
        translatedCountry != null &&
        translatedCountry != '-') {
      return '$translatedCity, $translatedCountry';
    }
    if (translatedCity != null && translatedCity.isNotEmpty) {
      return translatedCity;
    }
    if (translatedCountry != null &&
        translatedCountry.isNotEmpty &&
        translatedCountry != '-') {
      return translatedCountry;
    }
    return null;
  }
}

class _OpenStoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.24)),
      ),
      child: Icon(
        isArabic
            ? Icons.keyboard_arrow_left_rounded
            : Icons.keyboard_arrow_right_rounded,
        color: AppColors.orange,
        size: 24.r,
      ),
    );
  }
}

class _LatestListingText extends StatelessWidget {
  const _LatestListingText({required this.latestCarTitle});

  final String? latestCarTitle;

  @override
  Widget build(BuildContext context) {
    if (latestCarTitle == null || latestCarTitle!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'latest_listing',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall!.s13.withColor(AppColors.grey),
        ),
        4.verticalSpace,
        AppText(
          latestCarTitle!,
          translation: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium!.s14.m.withColor(AppColors.white),
        ),
      ],
    );
  }
}

class _CarsPreview extends StatelessWidget {
  const _CarsPreview({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        width: 52.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: AppSvgPicture(
            Assets.svgNavCarSell,
            width: 20.w,
            height: 20.h,
            color: AppColors.grey,
          ),
        ),
      );
    }

    return SizedBox(
      width: 92.w,
      height: 42.h,
      child: Stack(
        children: [
          for (var index = 0; index < images.length; index++)
            PositionedDirectional(
              end: (index * 22).w,
              top: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.dark.shade600,
                      width: 2,
                    ),
                  ),
                  child: AppCachedNetworkImageView(
                    url: images[index],
                    width: 42.w,
                    height: 42.h,
                    fit: BoxFit.cover,
                    logoWidth: 18.w,
                    logoHeight: 18.h,
                    logoColor: AppColors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

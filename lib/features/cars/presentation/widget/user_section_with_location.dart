import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/features/app/presentation/widgets/shimmer_loading.dart';

class UserSectionWithLocation extends StatelessWidget {
  final Map<String, dynamic> carData;
  
  const UserSectionWithLocation({
    super.key,
    required this.carData,
  });

  @override
  Widget build(BuildContext context) {
    // استخراج بيانات المالك من owner object أو من carData مباشرة
    final owner = carData['owner'] as Map<String, dynamic>?;
    final bool loadingOwner = owner == null;
    
    final userName = owner?['full_name']?.toString() ?? 
                     carData['seller_name']?.toString() ?? 
                     'car_owner'.tr();
    
    final userCity = owner?['city']?.toString() ?? carData['city']?.toString();
    final userCountry = owner?['country']?.toString() ?? carData['country']?.toString();
    final userLocation = owner?['location']?.toString() ?? carData['location']?.toString();
    
    // بناء نص الموقع
    String locationText = 'Worldwide'.tr();
    if (userCity != null && userCountry != null) {
      locationText = '$userCity, $userCountry';
    } else if (userCity != null) {
      locationText = userCity;
    } else if (userCountry != null) {
      locationText = userCountry;
    } else if (userLocation != null) {
      locationText = userLocation;
    }
    
    // Read avatar from multiple possible keys and ignore empty values
    String? avatarUrl = (owner?['avatar_url'] ?? owner?['picture'] ?? owner?['image_url'] ?? owner?['avatar'] ?? owner?['photo_url'])?.toString();
    if (avatarUrl != null && avatarUrl.trim().isEmpty) {
      avatarUrl = null;
    }
    // Fallback to Supabase Auth metadata if the owner is the current user
    if (avatarUrl == null) {
      final ownerId = owner?['id']?.toString() ?? carData['user_id']?.toString();
      final current = SupabaseService.currentUser;
      if (current != null && current.id == ownerId) {
        final meta = current.userMetadata ?? {};
        final fromAuth = (meta['avatar_url'] ?? meta['picture'])?.toString();
        if (fromAuth != null && fromAuth.trim().isNotEmpty) {
          avatarUrl = fromAuth;
        }
      }
    }
    
    return Row(
      children: [
        CirclueUserImageWidget(
          width: 80,
          userImage: avatarUrl,
        ),
        25.horizontalSpace,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            final offset = Tween<Offset>(
              begin: const Offset(0.12, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
          child: loadingOwner
              ? const _SkeletonNameLocation(key: ValueKey('skel-name'))
              : Column(
                  key: const ValueKey('real-name'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: AppText(
                        userName,
                        translation: false,
                        style: context.textTheme.bodyLarge!.s17.xb
                            .withColor(AppColors.white),
                      ),
                    ),
                    7.verticalSpace,
                    Row(
                      children: [
                        AppSvgPicture(
                          Assets.svgLocationPin,
                          height: 15.h,
                          width: 15.w,
                          color: AppColors.grey,
                        ),
                        9.horizontalSpace,
                        SizedBox(
                          width: 200.w,
                          child: AppText(
                            locationText,
                            translation: false,
                            style: context.textTheme.bodyLarge!.s17.r
                                .withColor(AppColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        )
      ],
    );
  }
}

class _SkeletonNameLocation extends StatelessWidget {
  const _SkeletonNameLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0.08),
          AppColors.primary.withOpacity(0.16),
          AppColors.primary.withOpacity(0.08),
        ],
        stops: const [0.1, 0.3, 0.4],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(
            isLoading: true,
            child: _Bar(width: 180),
          ),
          10.verticalSpace,
          const ShimmerLoading(
            isLoading: true,
            child: _Bar(width: 140),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: AppColors.greyStroke.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}

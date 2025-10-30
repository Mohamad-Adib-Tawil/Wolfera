part of 'app_empty_state.dart';

class _FavoritesEmpty extends AppEmptyState {
  const _FavoritesEmpty({Key? key})
      : super(
            key: key,
            image: Assets.svgNavFavorite,
            title: LocaleKeys.emptyStates_noFavorite,
            subtitle: LocaleKeys.youHaveNotLikedAnyCarYet);

  @override
  Widget build(BuildContext context) {
    // Centered, modern empty state with soft card and subtle entrance animation
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.9 + 0.1 * t,
                child: child,
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark.withOpacity(0.06),
                    blurRadius: 22,
                    spreadRadius: 0,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon inside soft gradient circle
                  Container(
                    width: 96.r,
                    height: 96.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.14),
                          AppColors.primary.withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.20),
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: AppSvgPicture(
                        image,
                        width: 40.r,
                        height: 40.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  AppText(
                    title,
                    style: context.textTheme.titleLarge.b
                        .withColor(AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  AppText(
                    subtitle,
                    style: context.textTheme.bodyLarge
                        .withColor(AppColors.primary.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

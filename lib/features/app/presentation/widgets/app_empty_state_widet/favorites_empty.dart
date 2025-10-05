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
    return Column(
      children: [
        AppSvgPicture(image),
        20.verticalSpace,
        AppText(
          title,
          style: context.textTheme.titleLarge.b.withColor(AppColors.primary),
          textAlign: TextAlign.center,
        ),
        10.verticalSpace,
        AppText(
          subtitle,
          style: context.textTheme.bodyLarge.withColor(AppColors.dark),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

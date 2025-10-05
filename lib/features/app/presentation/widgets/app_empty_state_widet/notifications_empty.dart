part of 'app_empty_state.dart';

class _NotificationsEmpty extends AppEmptyState {
  const _NotificationsEmpty({Key? key})
      : super(
            key: key,
            image: Assets.svgNavFavorite,
            title: LocaleKeys.emptyStates_noNotifications,
            subtitle: LocaleKeys.youHavenNotReceivedAnyNotificationsYet);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
      ),
    );
  }
}

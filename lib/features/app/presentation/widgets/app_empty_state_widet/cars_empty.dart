part of 'app_empty_state.dart';

class _CarsEmpty extends AppEmptyState {
  const _CarsEmpty({Key? key})
      : super(
            key: key,
            image: Assets.imagesLogo,
            title: LocaleKeys.emptyStates_noCars,
            subtitle: "");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSvgPicture(image),
        30.verticalSpace,
        AppText(
          title,
          style: context.textTheme.titleLarge.b.withColor(AppColors.primary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

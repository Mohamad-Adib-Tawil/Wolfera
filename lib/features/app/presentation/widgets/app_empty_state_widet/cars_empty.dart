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
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvgPicture(
          image,
          width: 96.w,
          height: 96.w,
          fit: BoxFit.contain,
        ),
        12.verticalSpace,
        AppText(
          title,
          style: context.textTheme.titleLarge.b.withColor(AppColors.primary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

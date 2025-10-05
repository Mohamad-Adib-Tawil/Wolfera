part of 'sell_my_car_page.dart';

class _EnterCarPriceAndDescriptionPage extends StatefulWidget {
  const _EnterCarPriceAndDescriptionPage();

  @override
  State<_EnterCarPriceAndDescriptionPage> createState() =>
      _EnterCarPriceAndDescriptionPageState();
}

class _EnterCarPriceAndDescriptionPageState
    extends State<_EnterCarPriceAndDescriptionPage> {
  late MyCarsBloc _myCarsBloc;

  @override
  void initState() {
    _myCarsBloc = GetIt.I<MyCarsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReactiveForm(
        formGroup: _myCarsBloc.descriptionSectionForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            SellCarItem(
              title: 'Description',
              isDescription: true,
              formControlName: _myCarsBloc.kFromCarDescription,
            ),
            50.verticalSpace,
            SellCarItem(
              title: 'Price',
              formControlName: _myCarsBloc.kFromCarPrice,
              prefix: AppText(
                "\$",
                style:
                    context.textTheme.bodyLarge?.m.withColor(AppColors.white),
              ),
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            50.verticalSpace,
            SellCarItem(
              title: 'Location',
              formControlName: _myCarsBloc.kFromCarLocation,
            ),
          ],
        ),
      ),
    );
  }
}

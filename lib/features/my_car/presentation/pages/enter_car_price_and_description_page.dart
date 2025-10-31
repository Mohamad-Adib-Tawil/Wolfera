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
              title: 'Price'.tr(),
              formControlName: _myCarsBloc.kFromCarPrice,
              prefix: AppText(
                "\$",
                style:
                    context.textTheme.bodyLarge?.m.withColor(AppColors.white),
              ),
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            30.verticalSpace,
            AppText(
              'Country',
              translation: false,
              style: context.textTheme.titleMedium?.s13.m
                  .withColor(AppColors.white),
            ),
            10.verticalSpace,
            // Country dropdown (with flags)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm.control(_myCarsBloc.kFromCountryCode),
              builder: (context, control, child) {
                final selectedCode = control.value as String?;
                final selectedCountry = LocationsData.findByCode(selectedCode) ?? LocationsData.countries.first;
                final countries = LocationsData.countries;
                return AppDropdownSearch<CountryOption>(
                  items: countries,
                  selectedItem: selectedCountry,
                  itemAsString: (co) => co.name,
                  hintText: 'Country',
                  dropdownBuilder: (context, co) {
                    final code = (co?.code ?? 'WW').toUpperCase();
                    final isWw = code == LocationsData.worldwideCode;
                    return Row(
                      children: [
                        if (isWw)
                          const Icon(Icons.public, size: 18)
                        else
                          CountryFlag.fromCountryCode(
                            code,
                            theme: const ImageTheme(
                              width: 20,
                              height: 14,
                              shape: RoundedRectangle(4),
                            ),
                          ),
                        8.horizontalSpace,
                        Text(co?.name ?? 'Worldwide',
                            style: context.textTheme.titleSmall.b
                                .withColor(AppColors.blackLight)),
                      ],
                    );
                  },
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    itemBuilder: (context, co, isSelected) {
                      final isWw = co.code == LocationsData.worldwideCode;
                      return Padding(
                        padding: HWEdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            if (isWw)
                              const Icon(Icons.public, size: 18)
                            else
                              CountryFlag.fromCountryCode(
                                co.code.toUpperCase(),
                                theme: const ImageTheme(
                                  width: 20,
                                  height: 14,
                                  shape: RoundedRectangle(4),
                                ),
                              ),
                            10.horizontalSpace,
                            Expanded(child: Text(co.name)),
                          ],
                        ),
                      );
                    },
                  ),
                  onChanged: (co) {
                    if (co == null) return;
                    // تحديث الدولة ومسح المدينة
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromCountryCode)
                        .updateValue(co.code == LocationsData.worldwideCode ? null : co.code);
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromRegionOrCity)
                        .updateValue(null);
                    // تحديث worldwide flag
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromWorldwide)
                        .updateValue(co.code == LocationsData.worldwideCode);
                  },
                  borderColor: Colors.transparent,
                  filled: false,
                );
              },
            ),
            // Region/City dropdown (depends on country)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm.control(_myCarsBloc.kFromCountryCode),
              builder: (context, control, child) {
                final selectedCode = control.value as String?;
                if (selectedCode == null || selectedCode == LocationsData.worldwideCode) {
                  return const SizedBox.shrink();
                }
                final selectedCountry = LocationsData.findByCode(selectedCode);
                final regions = selectedCountry?.secondLevel ?? const <String>[];
                if (regions.isEmpty) return const SizedBox.shrink();
                
                final selectedRegion = _myCarsBloc.descriptionSectionForm
                    .control(_myCarsBloc.kFromRegionOrCity)
                    .value as String?;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    AppText(
                      selectedCountry?.secondLevelLabel ?? 'Region',
                      translation: false,
                      style: context.textTheme.titleMedium?.s13.m
                          .withColor(AppColors.white),
                    ),
                    10.verticalSpace,
                    AppDropdownSearch<String>(
                      items: regions,
                      selectedItem: selectedRegion,
                      hintText: selectedCountry?.secondLevelLabel ?? 'Region',
                      onChanged: (val) {
                        _myCarsBloc.descriptionSectionForm
                            .control(_myCarsBloc.kFromRegionOrCity)
                            .updateValue(val);
                      },
                      borderColor: Colors.transparent,
                      filled: false,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

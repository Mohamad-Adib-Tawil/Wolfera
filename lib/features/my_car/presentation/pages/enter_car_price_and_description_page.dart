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
              'Location',
              translation: false,
              style: context.textTheme.titleMedium?.s13.m
                  .withColor(AppColors.white),
            ),
            10.verticalSpace,
            // Worldwide toggle
            Row(
              children: [
                StatefulBuilder(builder: (context, setStateSB) {
                  final isWorldwide = _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromWorldwide)
                          .value as bool? ??
                      true;
                  return Switch.adaptive(
                    value: isWorldwide,
                    onChanged: (val) {
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromWorldwide)
                          .updateValue(val);
                      if (val) {
                        _myCarsBloc.descriptionSectionForm
                            .control(_myCarsBloc.kFromCountryCode)
                            .updateValue(null);
                        _myCarsBloc.descriptionSectionForm
                            .control(_myCarsBloc.kFromRegionOrCity)
                            .updateValue(null);
                      }
                      setStateSB(() {});
                    },
                  );
                }),
                10.horizontalSpace,
                AppText(
                  'Worldwide',
                  translation: false,
                  style: context.textTheme.bodyMedium?.m
                      .withColor(AppColors.white),
                ),
              ],
            ),
            10.verticalSpace,
            // Country dropdown (with flags)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm.control(_myCarsBloc.kFromWorldwide),
              builder: (context, control, child) {
                final isWorldwide = control.value as bool? ?? true;
                final selectedCode = _myCarsBloc.descriptionSectionForm
                    .control(_myCarsBloc.kFromCountryCode)
                    .value as String?;
                final selectedCountry = isWorldwide
                    ? LocationsData.countries.first
                    : (LocationsData.findByCode(selectedCode) ??
                        LocationsData.countries.first);
                final countries = LocationsData.countries;
                return IgnorePointer(
                  ignoring: isWorldwide,
                  child: AppDropdownSearch<CountryOption>(
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
                    if (co.code == LocationsData.worldwideCode) {
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromWorldwide)
                          .updateValue(true);
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromCountryCode)
                          .updateValue(null);
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromRegionOrCity)
                          .updateValue(null);
                    } else {
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromWorldwide)
                          .updateValue(false);
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromCountryCode)
                          .updateValue(co.code);
                      _myCarsBloc.descriptionSectionForm
                          .control(_myCarsBloc.kFromRegionOrCity)
                          .updateValue(null);
                    }
                  },
                  borderColor: Colors.transparent,
                  filled: false,
                ),
              );
            }),
            10.verticalSpace,
            // Region dropdown (depends on country)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm.control(_myCarsBloc.kFromWorldwide),
              builder: (context, control, child) {
                final isWorldwide = control.value as bool? ?? true;
                if (isWorldwide) return const SizedBox.shrink();
                final selectedCode = _myCarsBloc.descriptionSectionForm
                    .control(_myCarsBloc.kFromCountryCode)
                    .value as String?;
                final selectedCountry = LocationsData.findByCode(selectedCode);
                final regions = selectedCountry?.secondLevel ?? const <String>[];
                final selectedRegion = _myCarsBloc.descriptionSectionForm
                    .control(_myCarsBloc.kFromRegionOrCity)
                    .value as String?;
                return AppDropdownSearch<String>(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

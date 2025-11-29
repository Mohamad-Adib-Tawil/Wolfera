part of 'sell_my_car_page.dart';
class _EnterCarPriceAndDescriptionPage extends StatefulWidget {
  const _EnterCarPriceAndDescriptionPage();

  @override
  State<_EnterCarPriceAndDescriptionPage> createState() =>
      _EnterCarPriceAndDescriptionPageState();
}

class _EnterCarPriceAndDescriptionPageState extends State<_EnterCarPriceAndDescriptionPage> {
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
            // Listing Type Selector
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm
                  .control(_myCarsBloc.kFromListingType),
              builder: (context, control, child) {
                return ListingTypeSelector(
                  selectedType: control.value as String?,
                  onTypeChanged: (type) {
                    _myCarsBloc.applyListingType(type);
                  },
                );
              },
            ),
            30.verticalSpace,
            // Description field
            SellCarItem(
              title: 'description',
              isDescription: true,
              formControlName: _myCarsBloc.kFromCarDescription,
            ),
            50.verticalSpace,
            // Show sale price only when listing_type is not 'rent'
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm
                  .control(_myCarsBloc.kFromListingType),
              builder: (context, ltControl, _) {
                final lt = ltControl.value as String?;
                if (lt == 'rent') return const SizedBox.shrink();
                return ReactiveValueListenableBuilder(
                  formControl: _myCarsBloc.descriptionSectionForm
                      .control(_myCarsBloc.kFromCurrencyCode),
                  builder: (context, currencyControl, child) {
                    final code = currencyControl.value as String? ?? 'USD';
                    final selected = CurrenciesData.findByCode(code) ??
                        CurrenciesData.defaultCurrency();
                    return SellCarItem(
                      title: 'price',
                      formControlName: _myCarsBloc.kFromCarPrice,
                      prefix: SizedBox(
                        width: 104,
                        child: AppDropdownSearch<CurrencyOption>(
                          items: CurrenciesData.list,
                          selectedItem: selected,
                          itemAsString: (c) => c.symbol,
                          hintText: 'currency'.tr(),
                          dropdownBuilder: (context, c) => Text(
                            (c?.symbol ?? r'$'),
                            style: context.textTheme.bodySmall?.m
                                .withColor(AppColors.white),
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: false,
                            itemBuilder: (ctx, c, isSel) => Padding(
                              padding: HWEdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Text(c.symbol,
                                      style: context.textTheme.titleSmall?.b),
                                  10.horizontalSpace,
                                  Expanded(
                                      child: Text('${c.code} - ${c.name}')),
                                ],
                              ),
                            ),
                          ),
                          dropdownButtonProps: DropdownButtonProps(
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                size: 16, color: AppColors.white),
                          ),
                          onChanged: (c) async {
                            if (c == null) return;
                            _myCarsBloc.descriptionSectionForm
                                .control(_myCarsBloc.kFromCurrencyCode)
                                .updateValue(c.code);
                            // persist user override
                            try {
                              await GetIt.I<PrefsRepository>().setSelectedCurrencyCode(c.code);
                            } catch (_) {}
                          },
                          borderColor: Colors.transparent,
                          filled: false,
                          contentPadding:
                              HWEdgeInsetsDirectional.only(start: 6, end: 4),
                          baseStyle: context.textTheme.bodySmall?.m
                              .withColor(AppColors.white),
                        ),
                      ),
                      textInputType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                    );
                  },
                );
              },
            ),
            // Rental Prices Section (show only if listing type is rent or both)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm
                  .control(_myCarsBloc.kFromListingType),
              builder: (context, control, child) {
                final listingType = control.value as String?;
                if (listingType == 'rent' || listingType == 'both') {
                  return ReactiveValueListenableBuilder(
                    formControl: _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromCurrencyCode),
                    builder: (context, currencyControl, child) {
                      final code = currencyControl.value as String? ?? 'USD';
                      return Column(
                        children: [
                          30.verticalSpace,
                          RentalPriceSection(
                            rentalPricesForm:
                                _myCarsBloc.descriptionSectionForm,
                            currencyCode: code,
                            onCurrencyChanged: (c) async {
                              _myCarsBloc.descriptionSectionForm
                                  .control(_myCarsBloc.kFromCurrencyCode)
                                  .updateValue(c.code);
                              // persist user override
                              try {
                                await GetIt.I<PrefsRepository>().setSelectedCurrencyCode(c.code);
                              } catch (_) {}
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            30.verticalSpace,
            AppText(
              'select_country',
              style: context.textTheme.titleMedium?.s13.m
                  .withColor(AppColors.white),
            ),
            10.verticalSpace,
            // Country dropdown (with flags)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm
                  .control(_myCarsBloc.kFromCountryCode),
              builder: (context, control, child) {
                final selectedCode = control.value as String?;
                final selectedCountry =
                    LocationsData.findByCode(selectedCode) ??
                        LocationsData.countries.first;
                final countries = LocationsData.countries;
                return AppDropdownSearch<CountryOption>(
                  items: countries,
                  selectedItem: selectedCountry,
                  itemAsString: (co) => co.name,
                  hintText: 'choose_country'.tr(),
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
                        Text(co?.name ?? 'worldwide'.tr(),
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
                        padding: HWEdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                  onChanged: (co) async {
                    if (co == null) return;
                    // تحديث الدولة ومسح المدينة
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromCountryCode)
                        .updateValue(co.code == LocationsData.worldwideCode
                            ? null
                            : co.code);
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromRegionOrCity)
                        .updateValue(null);
                    // تحديث worldwide flag
                    _myCarsBloc.descriptionSectionForm
                        .control(_myCarsBloc.kFromWorldwide)
                        .updateValue(co.code == LocationsData.worldwideCode);

                    // إذا لم يكن هناك اختيار عملة محفوظ من قبل، عيّن عملة افتراضية حسب الوطن/حول العالم
                    try {
                      final prefs = GetIt.I<PrefsRepository>();
                      final saved = prefs.selectedCurrencyCode;
                      if (saved == null || saved.isEmpty) {
                        final isWw = co.code == LocationsData.worldwideCode;
                        final code = isWw
                            ? 'USD'
                            : CurrenciesData.codeForCountry(co.code);
                        _myCarsBloc.descriptionSectionForm
                            .control(_myCarsBloc.kFromCurrencyCode)
                            .updateValue(code);
                      }
                    } catch (_) {}
                  },
                  borderColor: Colors.transparent,
                  filled: false,
                );
              },
            ),
            // Region/City dropdown (depends on country)
            ReactiveValueListenableBuilder(
              formControl: _myCarsBloc.descriptionSectionForm
                  .control(_myCarsBloc.kFromCountryCode),
              builder: (context, control, child) {
                final selectedCode = control.value as String?;
                if (selectedCode == null ||
                    selectedCode == LocationsData.worldwideCode) {
                  return const SizedBox.shrink();
                }
                final selectedCountry = LocationsData.findByCode(selectedCode);
                final regions =
                    selectedCountry?.secondLevel ?? const <String>[];
                if (regions.isEmpty) return const SizedBox.shrink();

                final selectedRegion = _myCarsBloc.descriptionSectionForm
                    .control(_myCarsBloc.kFromRegionOrCity)
                    .value as String?;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Builder(builder: (context) {
                      final sl = selectedCountry?.secondLevelLabel;
                      final labelKey = () {
                        switch (sl) {
                          case 'Governorate':
                            return 'governorate';
                          case 'Emirate':
                            return 'emirate';
                          case 'City':
                            return 'city';
                          case 'Region':
                          default:
                            return 'region';
                        }
                      }();
                      return AppText(
                        labelKey,
                        style: context.textTheme.titleMedium?.s13.m
                            .withColor(AppColors.white),
                      );
                    }),
                    10.verticalSpace,
                    AppDropdownSearch<String>(
                      items: regions,
                      selectedItem: selectedRegion,
                      hintText: (() {
                        final sl = selectedCountry?.secondLevelLabel;
                        switch (sl) {
                          case 'Governorate':
                            return 'governorate'.tr();
                          case 'Emirate':
                            return 'emirate'.tr();
                          case 'City':
                            return 'city'.tr();
                          case 'Region':
                          default:
                            return 'region'.tr();
                        }
                      })(),
                      baseStyle: context.textTheme.titleSmall.b
                          .withColor(AppColors.white),
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

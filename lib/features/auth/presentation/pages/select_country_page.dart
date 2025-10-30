import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:country_flags/country_flags.dart';

class SelectCountyPage extends StatefulWidget {
  final String? country;
  const SelectCountyPage({super.key, this.country});

  @override
  State<SelectCountyPage> createState() => _SelectCountyPageState();
}

class _SelectCountyPageState extends State<SelectCountyPage> {
  CountryOption? _selectedCountry;
  String? _selectedRegion;
  bool _isWorldwide = true;

  @override
  void initState() {
    _initFromPrefsOrArg();
    super.initState();
  }

  void _initFromPrefsOrArg() {
    final prefs = GetIt.I<PrefsRepository>();
    _isWorldwide = prefs.isWorldwide;
    _selectedCountry = LocationsData.findByCode(prefs.selectedCountryCode) ?? LocationsData.countries.first;
    _selectedRegion = prefs.selectedRegionOrCity;
    // If page received a string country name, prefer it
    if (widget.country != null) {
      final byName = LocationsData.findByName(widget.country);
      if (byName != null) {
        _selectedCountry = byName;
        _isWorldwide = byName.code == LocationsData.worldwideCode;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          automaticallyImplyLeading: widget.country != null ? true : false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                HWEdgeInsets.only(top: 85, right: 40, left: 40, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SimpleShadow(
                    color: AppColors.black,
                    opacity: 0.15,
                    offset: const Offset(0, 4),
                    sigma: 4,
                    child: AppText(
                      "Choose Country".tr(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.b.withColor(
                        AppColors.white,
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                AppSvgPicture(
                  Assets.svgLocationPin,
                  width: 120.w,
                  alignment: Alignment.center,
                ),
                100.verticalSpace,
                Padding(
                  padding: HWEdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Worldwide toggle
                      Row(
                        children: [
                          Switch.adaptive(
                            value: _isWorldwide,
                            onChanged: (val) {
                              setState(() {
                                _isWorldwide = val;
                                if (val) {
                                  _selectedCountry = LocationsData.countries.first;
                                  _selectedRegion = null;
                                }
                              });
                            },
                          ),
                          8.horizontalSpace,
                          AppText('Worldwide', translation: false,
                              style: context.textTheme.bodyMedium?.m.withColor(AppColors.white)),
                        ],
                      ),
                      12.verticalSpace,
                      // Country dropdown with flags
                      SizedBox(
                        height: 50.h,
                        child: AppDropdownSearch<CountryOption>(
                          items: LocationsData.countries,
                          selectedItem: _selectedCountry ?? LocationsData.countries.first,
                          itemAsString: (co) => co.name,
                          hintText: 'Country',
                          baseStyle: context.textTheme.titleSmall.b.withColor(AppColors.blackLight),
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
                                10.horizontalSpace,
                                Text(co?.name ?? 'Worldwide', style: context.textTheme.titleSmall.b.withColor(AppColors.blackLight)),
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
                            setState(() {
                              if (co == null) return;
                              _selectedCountry = co;
                              _isWorldwide = co.code == LocationsData.worldwideCode;
                              _selectedRegion = null;
                            });
                          },
                          filled: true,
                          fillColor: const Color(0xffeff1f9),
                          borderColor: Colors.transparent,
                        ),
                      ),
                      10.verticalSpace,
                      if (!_isWorldwide && (_selectedCountry?.secondLevel.isNotEmpty ?? false))
                        AppDropdownSearch<String>(
                          items: _selectedCountry!.secondLevel,
                          selectedItem: _selectedRegion,
                          hintText: _selectedCountry!.secondLevelLabel ?? 'Region',
                          onChanged: (val) => setState(() => _selectedRegion = val),
                          filled: true,
                          fillColor: const Color(0xffeff1f9),
                          borderColor: Colors.transparent,
                        ),
                    ],
                  ),
                ),
                65.verticalSpace,
                TextButton(
                  onPressed: () async {
                    final prefs = GetIt.I<PrefsRepository>();
                    if (_isWorldwide) {
                      await prefs.setWorldwide(true);
                      await prefs.setSelectedCountryCode(null);
                      await prefs.setSelectedRegionOrCity(null);
                      await prefs.setSelectedCity('Worldwide'); // backward compatibility
                    } else if (_selectedCountry != null) {
                      await prefs.setWorldwide(false);
                      await prefs.setSelectedCountryCode(_selectedCountry!.code);
                      await prefs.setSelectedRegionOrCity(_selectedRegion);
                      await prefs.setSelectedCity(_selectedRegion ?? _selectedCountry!.name);
                    }
                    GRouter.router.goNamed(GRouter.config.mainRoutes.home);
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(250.w, 55.h)),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 27)),
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.primary),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.r),
                        ),
                      ),
                    ),
                  ),
                  child: AppText(
                    LocaleKeys.ok,
                    style: context.textTheme.bodyLarge.b
                        .withColor(AppColors.white),
                  ),
                ),
                26.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// legacy _CountryDropdown removed

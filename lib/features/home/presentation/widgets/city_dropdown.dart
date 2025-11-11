import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';
import 'package:country_flags/country_flags.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key, required this.onChanged});

  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 180.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.horizontalSpace,
          const AppSvgPicture(Assets.svgLocationPin),
          10.horizontalSpace,
          Expanded(child: dropDown(context)),
        ],
      ),
    );
  }

  Widget dropDown(BuildContext context) {
    final prefs = GetIt.I<PrefsRepository>();
    // Build combined list: Worldwide + Country + Country - Region
    final List<String> items = [];
    for (final co in LocationsData.countries) {
      if (co.code == LocationsData.worldwideCode) {
        items.add('Worldwide'.tr());
        continue;
      }
      items.add(co.name);
      for (final r in co.secondLevel) {
        items.add('${co.name} - $r');
      }
    }

    // Determine selected item from prefs
    String selected;
    if (prefs.isWorldwide) {
      selected = 'Worldwide'.tr();
    } else {
      final co = LocationsData.findByCode(prefs.selectedCountryCode);
      final region = prefs.selectedRegionOrCity;
      if (co != null && region != null && region.isNotEmpty) {
        selected = '${co.name} - $region';
      } else if (co != null) {
        selected = co.name;
      } else {
        selected = prefs.selectedCity ?? 'Worldwide'.tr();
      }
    }

    String countryNameOf(String item) {
      final idx = item.indexOf(' - ');
      return idx == -1 ? item : item.substring(0, idx);
    }

    String? regionOf(String item) {
      final idx = item.indexOf(' - ');
      return idx == -1 ? null : item.substring(idx + 3);
    }

    return AppDropdownSearch<String?> (
      items: items,
      itemAsString: (item) => item!,
      selectedItem: selected,
      onChanged: (value) async {
        final v = value ?? 'Worldwide'.tr();
        final prefs = GetIt.I<PrefsRepository>();
        if (v == 'Worldwide'.tr()) {
          await prefs.setWorldwide(true);
          await prefs.setSelectedCountryCode(null);
          await prefs.setSelectedRegionOrCity(null);
          await prefs.setSelectedCity('Worldwide'.tr());
        } else {
          final cName = countryNameOf(v);
          final reg = regionOf(v);
          final co = LocationsData.findByName(cName);
          await prefs.setWorldwide(false);
          await prefs.setSelectedCountryCode(co?.code);
          await prefs.setSelectedRegionOrCity(reg);
          await prefs.setSelectedCity(reg ?? cName);
        }
        onChanged?.call(value);
      },
      contentPadding: HWEdgeInsetsDirectional.only(start: 2, end: 0),
      dropdownButtonProps: DropdownButtonProps(
        iconSize: 14.w,
        alignment: Alignment.centerLeft,
        icon: AppSvgPicture(
          Assets.svgArrowDown,
          width: 14.w,
          color: context.colorScheme.white,
        ),
      ),
      baseStyle:
          context.textTheme.titleMedium?.s17.b.withColor(AppColors.white),
      dropdownBuilder: (context, item) {
        final label = item ?? 'Worldwide'.tr();
        if (label == 'Worldwide'.tr()) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(Icons.public, size: 16, color: Colors.white),
              6.horizontalSpace,
              Expanded(
                child: Text(
                  'Worldwide'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall.b.withColor(AppColors.white),
                ),
              ),
            ],
          );
        }
        final cName = countryNameOf(label);
        final co = LocationsData.findByName(cName);
        final region = regionOf(label);
        final code = (co?.code ?? 'WW').toUpperCase();
        final localizedCountry = CarValueTranslator.translateCountry(cName);
        final translatedRegion = region == null
            ? null
            : CarValueTranslator.translateCity(region, country: cName);
        final displayText = region == null
            ? localizedCountry
            : '$localizedCountry - ${translatedRegion ?? region}';
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (code == LocationsData.worldwideCode)
              const Icon(Icons.public, size: 16, color: Colors.white)
            else
              CountryFlag.fromCountryCode(
                code,
                theme: const ImageTheme(
                  width: 18,
                  height: 12,
                  shape: RoundedRectangle(3),
                ),
              ),
            6.horizontalSpace,
            Expanded(
              child: Text(
                label == 'Worldwide'.tr() ? 'Worldwide'.tr() : displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall.b.withColor(AppColors.white),
              ),
            ),
          ],
        );
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(15.r),
        ),
        itemBuilder: (context, item, isSelected) {
          final label = item!;
          final isWw = label == 'Worldwide'.tr();
          final cName = countryNameOf(label);
          final co = LocationsData.findByName(cName);
          final region = regionOf(label);
          final code = (co?.code ?? 'WW').toUpperCase();
          final localizedCountry = CarValueTranslator.translateCountry(cName);
          final translatedRegion = region == null
              ? null
              : CarValueTranslator.translateCity(region, country: cName);
          final displayText = isWw
              ? 'Worldwide'.tr()
              : (region == null ? localizedCountry : '$localizedCountry - ${translatedRegion ?? region}');
          return Padding(
            padding: HWEdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
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
                Expanded(child: Text(displayText, style: context.textTheme.labelLarge.m)),
                if (isSelected) const Icon(Icons.done_rounded)
              ],
            ),
          );
        },
        searchFieldProps: TextFieldProps(
          style:
              context.textTheme.bodyMedium?.b.withColor(AppColors.blackLight),
          maxLines: 1,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              filled: true,
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
              fillColor: AppColors.grey.shade50,
              border: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'searchCountryHint'.tr(),
              hintStyle:
                  context.textTheme.titleSmall.m.withColor(AppColors.grey)),
        ),
      ),
      hintText: 'Choose Country'.tr(),
      filled: false,
      borderColor: Colors.transparent,
      validator: (value) => value == null ? LocaleKeys.required : null,
    );
  }
}

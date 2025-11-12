import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';

class _CountryData {
  final String name; // English canonical name
  final String iso2; // Alpha-2 code
  final String phoneCode; // digits only, no plus
  const _CountryData(this.name, this.iso2, this.phoneCode);
}

// Focused list: Arab countries + common others used in app
const List<_CountryData> _countriesData = [
  // GCC + Levant + North Africa
  _CountryData('United Arab Emirates', 'AE', '971'),
  _CountryData('Saudi Arabia', 'SA', '966'),
  _CountryData('Qatar', 'QA', '974'),
  _CountryData('Kuwait', 'KW', '965'),
  _CountryData('Oman', 'OM', '968'),
  _CountryData('Bahrain', 'BH', '973'),
  _CountryData('Jordan', 'JO', '962'),
  _CountryData('Lebanon', 'LB', '961'),
  _CountryData('Egypt', 'EG', '20'),
  _CountryData('Iraq', 'IQ', '964'),
  _CountryData('Syria', 'SY', '963'),
  _CountryData('Yemen', 'YE', '967'),
  _CountryData('Palestine', 'PS', '970'),
  _CountryData('Morocco', 'MA', '212'),
  _CountryData('Algeria', 'DZ', '213'),
  _CountryData('Tunisia', 'TN', '216'),
  _CountryData('Libya', 'LY', '218'),
  _CountryData('Sudan', 'SD', '249'),
  // Popular others
  _CountryData('Turkey', 'TR', '90'),
  _CountryData('United States', 'US', '1'),
  _CountryData('United Kingdom', 'GB', '44'),
  _CountryData('Germany', 'DE', '49'),
  _CountryData('France', 'FR', '33'),
  _CountryData('Italy', 'IT', '39'),
  _CountryData('Spain', 'ES', '34'),
  _CountryData('India', 'IN', '91'),
  _CountryData('Pakistan', 'PK', '92'),
];

Future<void> showCustomCountryPicker({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
}) async {
  final controller = TextEditingController();
  final theme = Theme.of(context);

  List<_CountryData> filtered = List.of(_countriesData);

  void applyFilter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      filtered = List.of(_countriesData);
    } else {
      filtered = _countriesData.where((c) {
        final name = c.name.toLowerCase();
        return name.contains(query) ||
            c.iso2.toLowerCase() == query ||
            c.phoneCode.contains(query.replaceAll('+', ''));
      }).toList();
    }
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (ctx) {
      final maxH = MediaQuery.of(ctx).size.height * 0.75;
      return SafeArea(
        child: Padding(
          padding: HWEdgeInsets.only(left: 12, right: 12, top: 10, bottom: 12),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxH),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'choose_country'.tr(),
                          style: theme.textTheme.titleMedium?.s17.b
                              .withColor(AppColors.blackLight),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    // Search field
                    TextField(
                      controller: controller,
                      style: theme.textTheme.bodyMedium?.withColor(AppColors.blackLight),
                      cursorColor: AppColors.blackLight,
                      onChanged: (v) => setState(() {
                        applyFilter(v);
                      }),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.black,
                        ),
                        hintText: 'searchCountryHint'.tr(),
                        hintStyle: theme.textTheme.bodyMedium?.withColor(AppColors.blackLight),
                        filled: true,
                        fillColor: AppColors.grey.shade50,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grey.shade100),
                          borderRadius: BorderRadius.circular(12).r,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grey.shade100),
                          borderRadius: BorderRadius.circular(12).r,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grey.shade300),
                          borderRadius: BorderRadius.circular(12).r,
                        ),
                        contentPadding: HWEdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: AppColors.grey.shade200,
                        ),
                        itemBuilder: (c, i) {
                          final item = filtered[i];
                          final localizedName =
                              CarValueTranslator.translateCountry(item.name);
                          return ListTile(
                            onTap: () {
                              // Build Country via CountryParser using phoneCode
                              final country =
                                  CountryParser.parsePhoneCode(item.phoneCode);
                              onSelect(country);
                              Navigator.pop(ctx);
                            },
                            leading: CountryFlag.fromCountryCode(
                              item.iso2,
                              theme: const ImageTheme(
                                width: 28,
                                height: 20,
                                shape: RoundedRectangle(4),
                              ),
                            ),
                            title: Text(
                              localizedName,
                              style: theme.textTheme.titleSmall?.s14.b
                                  .withColor(AppColors.blackLight),
                            ),
                            trailing: Text(
                              '+${item.phoneCode}',
                              style: theme.textTheme.titleSmall?.s14.m
                                  .withColor(AppColors.grey.shade800),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

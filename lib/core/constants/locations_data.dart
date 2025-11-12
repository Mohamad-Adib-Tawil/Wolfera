import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/services/app_settings_service.dart';

class CountryOption {
  final String code; // ISO code or 'WW'
  final String name; // Display name
  final String? secondLevelLabel; // e.g., Governorate, Emirate, City
  final List<String> secondLevel; // List of regions/emirates/cities

  const CountryOption({
    required this.code,
    required this.name,
    this.secondLevelLabel,
    this.secondLevel = const [],
  });

  // Get translated name
  String get translatedName {
    if (code == LocationsData.worldwideCode) {
      return 'worldwide'.tr();
    }
    // Use translation key based on country code
    return 'country_${code.toLowerCase()}'.tr();
  }

  // Get translated second level label
  String? get translatedSecondLevelLabel {
    if (secondLevelLabel == null) return null;
    switch (secondLevelLabel) {
      case 'Governorate':
        return 'governorate'.tr();
      case 'Emirate':
        return 'emirate'.tr();
      case 'City':
        return 'city'.tr();
      default:
        return secondLevelLabel;
    }
  }
}

class LocationsData {
  static const String worldwideCode = 'WW';

  static const List<CountryOption> _allCountries = [
    CountryOption(
      code: worldwideCode,
      name: 'Worldwide',
      secondLevelLabel: null,
      secondLevel: [],
    ),
    CountryOption(
      code: 'SY',
      name: 'Syria',
      secondLevelLabel: 'Governorate',
      secondLevel: [
        'Aleppo',
        'Idlib',
        'Hama',
        'Homs',
        'Damascus',
        'Daraa',
        'Deir ez-Zor',
        'Latakia',
        'Tartus',
        'Hasakah',
        'Raqqa',
        'Quneitra',
        'As-Suwayda',
      ],
    ),
    CountryOption(
      code: 'QA',
      name: 'Qatar',
      secondLevelLabel: 'City',
      secondLevel: [
        'Doha',
        'Al Rayyan',
        'Al Wakrah',
        'Al Khor',
        'Umm Salal',
        'Al Daayen',
        'Madinat ash Shamal',
        'Al Shahaniya',
      ],
    ),
    CountryOption(
      code: 'SA',
      name: 'Saudi Arabia',
      secondLevelLabel: 'Region',
      secondLevel: [
        'Riyadh',
        'Makkah',
        'Madinah',
        'Eastern Province',
        'Asir',
        'Tabuk',
        'Qassim',
        'Ha\'il',
        'Jazan',
        'Najran',
        'Al Bahah',
        'Northern Borders',
        'Al Jawf',
      ],
    ),
    CountryOption(
      code: 'AE',
      name: 'United Arab Emirates',
      secondLevelLabel: 'Emirate',
      secondLevel: [
        'Abu Dhabi',
        'Dubai',
        'Sharjah',
        'Ajman',
        'Umm Al Quwain',
        'Ras Al Khaimah',
        'Fujairah',
      ],
    ),
    CountryOption(
      code: 'DE',
      name: 'Germany',
      secondLevelLabel: 'City',
      secondLevel: [
        'Berlin',
        'Hamburg',
        'Munich',
        'Frankfurt',
        'Stuttgart',
        'Cologne',
        'Dusseldorf',
        'Leipzig',
      ],
    ),
  ];

  /// قائمة الدول المفلترة حسب إعدادات التطبيق (تخفي سوريا إذا كان مطلوباً)
  static List<CountryOption> get countries {
    final settings = AppSettingsService.instance;
    if (!settings.isInitialized || !settings.isSyriaHidden) {
      return _allCountries;
    }
    // إخفاء سوريا
    return _allCountries.where((c) => c.code != 'SY').toList();
  }

  static CountryOption? findByCode(String? code) {
    if (code == null) return null;
    return countries.firstWhere(
      (c) => c.code == code,
      orElse: () => countries.first,
    );
  }

  static CountryOption? findByName(String? name) {
    if (name == null) return null;
    return countries.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => countries.first,
    );
  }

  static List<String> countryNames({bool includeWorldwide = true}) {
    final list = countries.map((c) => c.name).toList();
    if (!includeWorldwide) {
      list.removeWhere((e) => e == 'Worldwide');
    }
    return list;
  }
}

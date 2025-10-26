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
}

class LocationsData {
  static const String worldwideCode = 'WW';

  static const List<CountryOption> countries = [
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
        'Damascus',
        'Aleppo',
        'Homs',
        'Hama',
        'Lattakia',
        'Tartus',
        'Deir ez-Zor',
        'Hasakah',
        'As-Suwayda',
        'Daraa',
        'Raqqa',
        'Idlib',
        'Quneitra',
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

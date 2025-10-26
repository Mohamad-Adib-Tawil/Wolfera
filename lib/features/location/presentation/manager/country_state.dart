part of 'country_cubit.dart';

class CountryState extends Equatable {
  final bool isWorldwide;
  final String? countryCode; // 'WW', 'AE', 'SY', 'DE'
  final String? countryName; // Display name
  final String? region; // Emirate / Governorate / State
  final String? city; // Optional

  const CountryState({
    this.isWorldwide = true,
    this.countryCode,
    this.countryName,
    this.region,
    this.city,
  });

  CountryState copyWith({
    bool? isWorldwide,
    String? countryCode,
    String? countryName,
    String? region,
    String? city,
  }) {
    return CountryState(
      isWorldwide: isWorldwide ?? this.isWorldwide,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      region: region ?? this.region,
      city: city ?? this.city,
    );
  }

  @override
  List<Object?> get props => [isWorldwide, countryCode, countryName, region, city];
}

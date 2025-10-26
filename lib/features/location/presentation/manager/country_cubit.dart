import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
// No direct PrefsKey usage here; we rely on PrefsRepository API.

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(const CountryState());

  PrefsRepository get _prefs => GetIt.I<PrefsRepository>();

  void loadFromPrefs() {
    final isWorldwide = _prefs.isWorldwide;
    final code = _prefs.selectedCountryCode;
    final regionOrCity = _prefs.selectedRegionOrCity;

    if (isWorldwide || code == null) {
      emit(state.copyWith(
          isWorldwide: true,
          countryCode: null,
          countryName: null,
          region: null,
          city: null));
      return;
    }

    final co = LocationsData.findByCode(code);
    emit(state.copyWith(
      isWorldwide: false,
      countryCode: co?.code,
      countryName: co?.name,
      region: regionOrCity,
      city: null,
    ));
  }

  void setWorldwide(bool value) {
    if (value) {
      emit(state.copyWith(
          isWorldwide: true, countryCode: null, countryName: null, region: null, city: null));
    } else {
      // if disabling worldwide without selecting a country, do nothing
      emit(state.copyWith(isWorldwide: false));
    }
  }

  void selectCountryByName(String? name) {
    if (name == null) return;
    if (name == 'Worldwide') {
      setWorldwide(true);
      return;
    }
    final co = LocationsData.findByName(name);
    emit(state.copyWith(
      isWorldwide: false,
      countryCode: co?.code,
      countryName: co?.name,
      // reset lower levels on country change
      region: null,
      city: null,
    ));
  }

  void selectRegion(String? region) {
    emit(state.copyWith(region: region, city: null));
  }

  void selectCity(String? city) {
    emit(state.copyWith(city: city));
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/utils/debouncer.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/utils/nullable.dart';
import 'package:wolfera/services/search_and_filters_service.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';

part 'search_state.dart';

@lazySingleton
class SearchCubit extends Cubit<SearchState> {
  final SearchFilterService _searchFilterService;
  final form = FormGroup({"searchCars": FormControl()});
  late StreamSubscription carsSearchStream;
  final Debounce debounce = Debounce();

  SearchCubit(
    this._searchFilterService,
  ) : super(SearchState.initial()) {
    _initStreams();
    _loadAddressFromPrefs();
  }

  @override
  Future<void> close() {
    carsSearchStream.cancel();
    return super.close();
  }

  void _initStreams() {
    carsSearchStream = form.control('searchCars').valueChanges.listen(
      (event) {
        final query = event?.toString() ?? '';
        debounce.run(() {
          searchCars(query);
        });
      },
      onError: _handleError,
    );
  }

  // دالة البحث عن السيارات (تعمل مع أو بدون نص بحث)
  Future<void> searchCars([String? query]) async {
    try {
      final searchQuery = query ?? state.searchQuery;
      
      // بدء البحث
      emit(state.copyWith(
        isSearching: true,
        searchQuery: searchQuery,
        searchError: const Nullable.value(null),
      ));

      // جلب السيارات من Supabase مع البحث والفلاتر
      final results = await _searchFilterService.searchCars(
        query: searchQuery,
        filters: state,
      );

      emit(state.copyWith(
        isSearching: false,
        searchResults: results,
      ));
    } catch (e) {
      print('🔴 Error searching cars: $e');
      emit(state.copyWith(
        isSearching: false,
        searchError: Nullable.value(e.toString()),
      ));
    }
  }

  // دالة مساعدة لتطبيق الفلاتر فورًا
  Future<void> _applyFiltersAndSearch() async {
    await searchCars();
  }

  // ===================== Address Filters =====================
  void _loadAddressFromPrefs() {
    try {
      final prefs = GetIt.I<PrefsRepository>();
      final isWw = prefs.isWorldwide;
      final code = prefs.selectedCountryCode;
      final region = prefs.selectedRegionOrCity;
      emit(state.copyWith(
        isWorldwide: isWw,
        selectedCountryCode: Nullable.value(code),
        selectedRegionOrCity: Nullable.value(region),
      ));
      _applyFiltersAndSearch();
    } catch (_) {}
  }

  void setWorldwide(bool value) {
    // persist
    try { GetIt.I<PrefsRepository>().setWorldwide(value); } catch (_) {}
    if (value) {
      try {
        GetIt.I<PrefsRepository>().setSelectedCountryCode(null);
        GetIt.I<PrefsRepository>().setSelectedRegionOrCity(null);
      } catch (_) {}
    }
    emit(state.copyWith(
      isWorldwide: value,
      selectedCountryCode: const Nullable.value(null),
      selectedRegionOrCity: const Nullable.value(null),
    ));
    _applyFiltersAndSearch();
  }

  void selectCountryByName(String? countryName) {
    if (countryName == null) return;
    if (countryName == 'Worldwide') {
      setWorldwide(true);
      return;
    }
    final co = LocationsData.findByName(countryName);
    // persist
    try {
      GetIt.I<PrefsRepository>().setWorldwide(false);
      GetIt.I<PrefsRepository>().setSelectedCountryCode(co?.code);
      GetIt.I<PrefsRepository>().setSelectedRegionOrCity(null);
    } catch (_) {}
    emit(state.copyWith(
      isWorldwide: false,
      selectedCountryCode: Nullable.value(co?.code),
      selectedRegionOrCity: const Nullable.value(null),
    ));
    _applyFiltersAndSearch();
  }

  void selectRegionOrCity(String? value) {
    try { GetIt.I<PrefsRepository>().setSelectedRegionOrCity(value); } catch (_) {}
    emit(state.copyWith(selectedRegionOrCity: Nullable.value(value)));
    _applyFiltersAndSearch();
  }

  void resetAllFilters() {
    emit(state.resetAllFilters());
    _applyFiltersAndSearch();
  }

  int getActiveFilterCount() {
    return state.activeFilterCount();
  }

  void toggleMakerSelection(String carMaker) {
    final updatedState =
        _searchFilterService.toggleMakerSelection(state, carMaker);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void changeCarKilometersFilter(
      {String? minKilometers, String? maxKilometers}) {
    final updatedState = _searchFilterService.changeCarKilometersFilter(state,
        minKilometers: minKilometers, maxKilometers: maxKilometers);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void changeCarYearFilter({int? minYear, int? maxYear}) {
    final updatedState = _searchFilterService.changeCarYearFilter(state,
        minYear: minYear, maxYear: maxYear);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectPrice(String? price) {
    final updatedState = _searchFilterService.selectPrice(state, price);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectTransmission(String? transmissionType) {
    final updatedState =
        _searchFilterService.selectTransmission(state, transmissionType);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectBodyType(String? bodyType) {
    final updatedState = _searchFilterService.selectBodyType(state, bodyType);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectCylinders(String? cylinders) {
    final updatedState = _searchFilterService.selectCylinders(state, cylinders);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectSeats(String? seatsCount) {
    final updatedState = _searchFilterService.selectSeats(state, seatsCount);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void toggleColorsSelection(String carColor) {
    final updatedState =
        _searchFilterService.toggleColorsSelection(state, carColor);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectCarCondition(String? carCondition) {
    final updatedState =
        _searchFilterService.selectCarCondition(state, carCondition);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void selectFuelType(String? fuelType) {
    final updatedState = _searchFilterService.selectFuelType(state, fuelType);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  // ===================== Sorting =====================
  void setSort(String sortBy, bool asc) {
    emit(state.copyWith(sortBy: sortBy, sortAsc: asc));
    _applyFiltersAndSearch();
  }

  // Reset Filters Section
  void resetMakerSelectionFilter() {
    final updatedState = _searchFilterService.resetMakerSelectionFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetKilometersFilter(
      {bool? resetMinKilometers, bool? resetMaxKilometers}) {
    final updatedState = _searchFilterService.resetKilometersFilter(state,
        resetMinKilometers: resetMinKilometers,
        resetMaxKilometers: resetMaxKilometers);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetYearFilter({bool? resetMinYear, bool? resetMaxYear}) {
    final updatedState = _searchFilterService.resetYearFilter(state,
        resetMinYear: resetMinYear, resetMaxYear: resetMaxYear);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetPriceFilter() {
    final updatedState = _searchFilterService.resetPriceFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetTransmissionFilter() {
    final updatedState = _searchFilterService.resetTransmissionFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetCarBodyTypeFilter() {
    final updatedState = _searchFilterService.resetCarBodyTypeFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetFuelTypeFilter() {
    final updatedState = _searchFilterService.resetFuelTypeFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetCylindersFilter() {
    final updatedState = _searchFilterService.resetCylindersFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetSeatsFilter() {
    final updatedState = _searchFilterService.resetSeatsFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetColorFilter() {
    final updatedState = _searchFilterService.resetColorFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void resetConditionFilter() {
    final updatedState = _searchFilterService.resetConditionFilter(state);
    emit(updatedState);
    _applyFiltersAndSearch();
  }

  void _handleError(error) {
    if (kDebugMode) {
      print('Error in stream: $error');
    }
  }
}

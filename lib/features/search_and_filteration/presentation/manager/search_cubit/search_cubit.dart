import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/utils/debouncer.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/utils/nullable.dart';
import 'package:wolfera/services/search_and_filters_service.dart';

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

  // دالة البحث عن السيارات
  Future<void> searchCars(String query) async {
    try {
      // إذا كان النص فارغًا، نعيد تعيين النتائج
      if (query.trim().isEmpty) {
        emit(state.copyWith(
          isSearching: false,
          searchQuery: '',
          searchResults: [],
          searchError: const Nullable.value(null),
        ));
        return;
      }

      // بدء البحث
      emit(state.copyWith(
        isSearching: true,
        searchQuery: query,
        searchError: const Nullable.value(null),
      ));

      // جلب السيارات من Supabase مع البحث
      final results = await _searchFilterService.searchCars(
        query: query,
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

  void resetAllFilters() {
    emit(state.resetAllFilters());
  }

  int getActiveFilterCount() {
    return state.activeFilterCount();
  }

  void toggleMakerSelection(String carMaker) {
    final updatedState =
        _searchFilterService.toggleMakerSelection(state, carMaker);
    emit(updatedState);
  }

  void changeCarKilometersFilter(
      {String? minKilometers, String? maxKilometers}) {
    final updatedState = _searchFilterService.changeCarKilometersFilter(state,
        minKilometers: minKilometers, maxKilometers: maxKilometers);
    emit(updatedState);
  }

  void changeCarYearFilter({int? minYear, int? maxYear}) {
    final updatedState = _searchFilterService.changeCarYearFilter(state,
        minYear: minYear, maxYear: maxYear);
    emit(updatedState);
  }

  void selectPrice(String? price) {
    final updatedState = _searchFilterService.selectPrice(state, price);
    emit(updatedState);
  }

  void selectTransmission(String? transmissionType) {
    final updatedState =
        _searchFilterService.selectTransmission(state, transmissionType);
    emit(updatedState);
  }

  void selectBodyType(String? bodyType) {
    final updatedState = _searchFilterService.selectBodyType(state, bodyType);
    emit(updatedState);
  }

  void selectCylinders(String? cylinders) {
    final updatedState = _searchFilterService.selectCylinders(state, cylinders);
    emit(updatedState);
  }

  void selectSeats(String? seatsCount) {
    final updatedState = _searchFilterService.selectSeats(state, seatsCount);
    emit(updatedState);
  }

  void toggleColorsSelection(String carColor) {
    final updatedState =
        _searchFilterService.toggleColorsSelection(state, carColor);
    emit(updatedState);
  }

  void selectCarCondition(String? carCondition) {
    final updatedState =
        _searchFilterService.selectCarCondition(state, carCondition);
    emit(updatedState);
  }

  void selectFuelType(String? fuelType) {
    final updatedState = _searchFilterService.selectFuelType(state, fuelType);
    emit(updatedState);
  }

  // Reset Filters Section
  void resetMakerSelectionFilter() {
    final updatedState = _searchFilterService.resetMakerSelectionFilter(state);
    emit(updatedState);
  }

  void resetKilometersFilter(
      {bool? resetMinKilometers, bool? resetMaxKilometers}) {
    final updatedState = _searchFilterService.resetKilometersFilter(state,
        resetMinKilometers: resetMinKilometers,
        resetMaxKilometers: resetMaxKilometers);
    emit(updatedState);
  }

  void resetYearFilter({bool? resetMinYear, bool? resetMaxYear}) {
    final updatedState = _searchFilterService.resetYearFilter(state,
        resetMinYear: resetMinYear, resetMaxYear: resetMaxYear);
    emit(updatedState);
  }

  void resetPriceFilter() {
    final updatedState = _searchFilterService.resetPriceFilter(state);
    emit(updatedState);
  }

  void resetTransmissionFilter() {
    final updatedState = _searchFilterService.resetTransmissionFilter(state);
    emit(updatedState);
  }

  void resetCarBodyTypeFilter() {
    final updatedState = _searchFilterService.resetCarBodyTypeFilter(state);
    emit(updatedState);
  }

  void resetFuelTypeFilter() {
    final updatedState = _searchFilterService.resetFuelTypeFilter(state);
    emit(updatedState);
  }

  void resetCylindersFilter() {
    final updatedState = _searchFilterService.resetCylindersFilter(state);
    emit(updatedState);
  }

  void resetSeatsFilter() {
    final updatedState = _searchFilterService.resetSeatsFilter(state);
    emit(updatedState);
  }

  void resetColorFilter() {
    final updatedState = _searchFilterService.resetColorFilter(state);
    emit(updatedState);
  }

  void resetConditionFilter() {
    final updatedState = _searchFilterService.resetConditionFilter(state);
    emit(updatedState);
  }

  void _handleError(error) {
    if (kDebugMode) {
      print('Error in stream: $error');
    }
  }
}

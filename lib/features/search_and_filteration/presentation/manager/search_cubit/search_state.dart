part of 'search_cubit.dart';

@immutable
class SearchState {
  final String? selectedPrice;
  final String? selectedTransmission;
  final String? seletedBodyType;
  final String? selectedCarMinKilometers;
  final String? selectedCarMaxKilometers;
  final int? selectedCarMinYear;
  final int? selectedCarMaxYear;
  final List<String> selectedCarMakersFilter;
  final List<String> seletedColors;
  final String? seletedCylinders;
  final String? seletedSeatsCount;
  final String? seletedCondition;
  final String? seletedFuelType;
  @override
  List<Object?> get props => [
        selectedPrice,
        selectedTransmission,
        seletedBodyType,
        selectedCarMinKilometers,
        selectedCarMaxKilometers,
        selectedCarMinYear,
        selectedCarMaxYear,
        selectedCarMakersFilter,
        seletedColors,
        seletedCylinders,
        seletedSeatsCount,
        seletedCondition,
        seletedFuelType,
      ];
  const SearchState({
    this.selectedPrice,
    this.selectedTransmission,
    this.seletedBodyType,
    this.selectedCarMinKilometers,
    this.selectedCarMaxKilometers,
    this.selectedCarMinYear,
    this.selectedCarMaxYear,
    this.selectedCarMakersFilter = const [],
    this.seletedColors = const [],
    this.seletedCylinders,
    this.seletedSeatsCount,
    this.seletedCondition,
    this.seletedFuelType,
  });

  factory SearchState.initial() {
    return const SearchState(
      selectedPrice: null,
      selectedTransmission: null,
      seletedBodyType: null,
      selectedCarMinYear: null,
      selectedCarMaxYear: null,
      selectedCarMinKilometers: null,
      selectedCarMaxKilometers: null,
      selectedCarMakersFilter: [],
      seletedColors: [],
      seletedCylinders: null,
      seletedSeatsCount: null,
      seletedCondition: null,
      seletedFuelType: null,
    );
  }

  SearchState copyWith({
    Nullable<String?>? selectedPrice,
    Nullable<String?>? selectedTransmission,
    Nullable<String?>? seletedBodyType,
    Nullable<int?>? selectedCarMinYear,
    Nullable<int?>? selectedCarMaxYear,
    Nullable<String?>? selectedCarMinKilometers,
    Nullable<String?>? selectedCarMaxKilometers,
    List<String>? selectedCarMakersFilter,
    List<String>? seletedColors,
    Nullable<String?>? seletedCylinders,
    Nullable<String?>? seletedSeatsCount,
    Nullable<String?>? seletedCondition,
    Nullable<String?>? seletedFuelType,
  }) {
    return SearchState(
      selectedPrice:
          selectedPrice != null ? selectedPrice.value : this.selectedPrice,
      selectedTransmission: selectedTransmission != null
          ? selectedTransmission.value
          : this.selectedTransmission,
      seletedBodyType: seletedBodyType != null
          ? seletedBodyType.value
          : this.seletedBodyType,
      selectedCarMinYear: selectedCarMinYear != null
          ? selectedCarMinYear.value
          : this.selectedCarMinYear,
      selectedCarMaxYear: selectedCarMaxYear != null
          ? selectedCarMaxYear.value
          : this.selectedCarMaxYear,
      selectedCarMinKilometers: selectedCarMinKilometers != null
          ? selectedCarMinKilometers.value
          : this.selectedCarMinKilometers,
      selectedCarMaxKilometers: selectedCarMaxKilometers != null
          ? selectedCarMaxKilometers.value
          : this.selectedCarMaxKilometers,
      selectedCarMakersFilter:
          selectedCarMakersFilter ?? this.selectedCarMakersFilter,
      seletedColors: seletedColors ?? this.seletedColors,
      seletedCylinders: seletedCylinders != null
          ? seletedCylinders.value
          : this.seletedCylinders,
      seletedSeatsCount: seletedSeatsCount != null
          ? seletedSeatsCount.value
          : this.seletedSeatsCount,
      seletedCondition: seletedCondition != null
          ? seletedCondition.value
          : this.seletedCondition,
      seletedFuelType: seletedFuelType != null
          ? seletedFuelType.value
          : this.seletedFuelType,
    );
  }

  SearchState resetAllFilters() {
    return SearchState.initial();
  }

  int activeFilterCount() {
    int count = 0;
    if (selectedPrice != null) count++;
    if (selectedTransmission != null) count++;
    if (seletedBodyType != null) count++;
    if (selectedCarMinKilometers != null) count++;
    if (selectedCarMaxKilometers != null) count++;
    if (selectedCarMinYear != null) count++;
    if (selectedCarMaxYear != null) count++;
    if (selectedCarMakersFilter.isNotEmpty) count++;
    if (seletedColors.isNotEmpty) count++;
    if (seletedCylinders != null) count++;
    if (seletedSeatsCount != null) count++;
    if (seletedCondition != null) count++;
    if (seletedFuelType != null) count++;
    return count;
  }
}

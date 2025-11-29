part of 'search_cubit.dart';

@immutable
class SearchState {
  final String? selectedPrice;
  final String? selectedListingType; // 'sale', 'rent', 'both', null = all
  final String? selectedTransmission;
  final String? seletedBodyType;
  final String? selectedCarMinKilometers;
  final String? selectedCarMaxKilometers;
  final int? selectedCarMinYear;
  final int? selectedCarMaxYear;
  final List<String> selectedCarMakersFilter;
  final List<String> selectedCarModelsFilter;
  final List<String> seletedColors;
  final String? seletedCylinders;
  final String? seletedSeatsCount;
  final String? seletedCondition;
  final String? seletedFuelType;
  // Address filters
  final bool isWorldwide;
  final String? selectedCountryCode; // 'WW','AE','SY','DE'
  final String? selectedRegionOrCity; // Emirate/Governorate/City
  
  // حالات البحث والنتائج
  final bool isSearching;
  final String searchQuery;
  final List<Map<String, dynamic>> searchResults;
  final String? searchError;
  // ترتيب النتائج
  final String sortBy; // e.g., 'created_at', 'price', 'year', 'mileage'
  final bool sortAsc;
  
  List<Object?> get props => [
        selectedPrice,
        selectedListingType,
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
        isSearching,
        searchQuery,
        searchResults,
        searchError,
        sortBy,
        sortAsc,
      ];
  const SearchState({
    this.selectedPrice,
    this.selectedListingType,
    this.selectedTransmission,
    this.seletedBodyType,
    this.selectedCarMinKilometers,
    this.selectedCarMaxKilometers,
    this.selectedCarMinYear,
    this.selectedCarMaxYear,
    this.selectedCarMakersFilter = const [],
    this.selectedCarModelsFilter = const [],
    this.seletedColors = const [],
    this.seletedCylinders,
    this.seletedSeatsCount,
    this.seletedCondition,
    this.seletedFuelType,
    this.isWorldwide = true,
    this.selectedCountryCode,
    this.selectedRegionOrCity,
    this.isSearching = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchError,
    this.sortBy = 'created_at',
    this.sortAsc = false,
  });

  factory SearchState.initial() {
    return const SearchState(
      selectedPrice: null,
      selectedListingType: null,
      selectedTransmission: null,
      seletedBodyType: null,
      selectedCarMinYear: null,
      selectedCarMaxYear: null,
      selectedCarMinKilometers: null,
      selectedCarMaxKilometers: null,
      selectedCarMakersFilter: [],
      selectedCarModelsFilter: [],
      seletedColors: [],
      seletedCylinders: null,
      seletedSeatsCount: null,
      seletedCondition: null,
      seletedFuelType: null,
      isWorldwide: true,
      selectedCountryCode: null,
      selectedRegionOrCity: null,
      isSearching: false,
      searchQuery: '',
      searchResults: [],
      searchError: null,
      sortBy: 'created_at',
      sortAsc: false,
    );
  }

  SearchState copyWith({
    Nullable<String?>? selectedPrice,
    Nullable<String?>? selectedListingType,
    Nullable<String?>? selectedTransmission,
    Nullable<String?>? seletedBodyType,
    Nullable<int?>? selectedCarMinYear,
    Nullable<int?>? selectedCarMaxYear,
    Nullable<String?>? selectedCarMinKilometers,
    Nullable<String?>? selectedCarMaxKilometers,
    List<String>? selectedCarMakersFilter,
    List<String>? selectedCarModelsFilter,
    List<String>? seletedColors,
    Nullable<String?>? seletedCylinders,
    Nullable<String?>? seletedSeatsCount,
    Nullable<String?>? seletedCondition,
    Nullable<String?>? seletedFuelType,
    bool? isWorldwide,
    Nullable<String?>? selectedCountryCode,
    Nullable<String?>? selectedRegionOrCity,
    bool? isSearching,
    String? searchQuery,
    List<Map<String, dynamic>>? searchResults,
    Nullable<String?>? searchError,
    String? sortBy,
    bool? sortAsc,
  }) {
    return SearchState(
      selectedPrice:
          selectedPrice != null ? selectedPrice.value : this.selectedPrice,
      selectedListingType: selectedListingType != null
          ? selectedListingType.value
          : this.selectedListingType,
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
      selectedCarModelsFilter:
          selectedCarModelsFilter ?? this.selectedCarModelsFilter,
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
      isWorldwide: isWorldwide ?? this.isWorldwide,
      selectedCountryCode: selectedCountryCode != null
          ? selectedCountryCode.value
          : this.selectedCountryCode,
      selectedRegionOrCity: selectedRegionOrCity != null
          ? selectedRegionOrCity.value
          : this.selectedRegionOrCity,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchError: searchError != null ? searchError.value : this.searchError,
      sortBy: sortBy ?? this.sortBy,
      sortAsc: sortAsc ?? this.sortAsc,
    );
  }

  SearchState resetAllFilters() {
    return SearchState.initial();
  }

  int activeFilterCount() {
    int count = 0;
    if (selectedPrice != null) count++;
    if (selectedListingType != null) count++;
    if (selectedTransmission != null) count++;
    if (seletedBodyType != null) count++;
    if (selectedCarMinKilometers != null) count++;
    if (selectedCarMaxKilometers != null) count++;
    if (selectedCarMinYear != null) count++;
    if (selectedCarMaxYear != null) count++;
    if (selectedCarMakersFilter.isNotEmpty) count++;
    if (selectedCarModelsFilter.isNotEmpty) count++;
    if (seletedColors.isNotEmpty) count++;
    if (seletedCylinders != null) count++;
    if (seletedSeatsCount != null) count++;
    if (seletedCondition != null) count++;
    if (seletedFuelType != null) count++;
    if (!isWorldwide || selectedCountryCode != null) count++;
    if (selectedRegionOrCity != null) count++;
    return count;
  }
}

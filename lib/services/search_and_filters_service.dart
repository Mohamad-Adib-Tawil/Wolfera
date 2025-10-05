import 'package:injectable/injectable.dart';
import 'package:wolfera/core/utils/nullable.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';

@lazySingleton
class SearchFilterService {
  // Toggle Car Maker Selection Filter
  SearchState toggleMakerSelection(SearchState state, String carMaker) {
    final currentSelected = List<String>.from(state.selectedCarMakersFilter);
    if (currentSelected.contains(carMaker)) {
      currentSelected.remove(carMaker);
    } else {
      currentSelected.add(carMaker);
    }
    return state.copyWith(selectedCarMakersFilter: currentSelected);
  }

  // Change Car Year Filter
  SearchState changeCarKilometersFilter(SearchState state,
      {String? minKilometers, String? maxKilometers}) {
    if (minKilometers != null) {
      return state.copyWith(
          selectedCarMinKilometers: Nullable.value(minKilometers));
    } else if (maxKilometers != null) {
      return state.copyWith(
          selectedCarMaxKilometers: Nullable.value(maxKilometers));
    }
    return state;
  }

  SearchState changeCarYearFilter(SearchState state,
      {int? minYear, int? maxYear}) {
    if (minYear != null) {
      return state.copyWith(selectedCarMinYear: Nullable.value(minYear));
    } else if (maxYear != null) {
      return state.copyWith(selectedCarMaxYear: Nullable.value(maxYear));
    }
    return state;
  }

  // Select Price Filter
  SearchState selectPrice(SearchState state, String? price) {
    return state.copyWith(selectedPrice: Nullable.value(price));
  }

  // Select Transmission Filter
  SearchState selectTransmission(SearchState state, String? transmissionType) {
    return state.copyWith(
        selectedTransmission: Nullable.value(transmissionType));
  }

  // Select Car Body Type Filter
  SearchState selectBodyType(SearchState state, String? bodyType) {
    return state.copyWith(seletedBodyType: Nullable.value(bodyType));
  }

  // Select Car Cylinders Filter
  SearchState selectCylinders(SearchState state, String? cylinders) {
    return state.copyWith(seletedCylinders: Nullable.value(cylinders));
  }

  // Select Car Seats Filter
  SearchState selectSeats(SearchState state, String? seatsCount) {
    return state.copyWith(seletedSeatsCount: Nullable.value(seatsCount));
  }

  // Toggle Car Color Selection Filter
  SearchState toggleColorsSelection(SearchState state, String carColor) {
    final currentSelected = List<String>.from(state.seletedColors);
    if (currentSelected.contains(carColor)) {
      currentSelected.remove(carColor);
    } else {
      currentSelected.add(carColor);
    }
    return state.copyWith(seletedColors: currentSelected);
  }

  // Select Car Condition Filter
  SearchState selectCarCondition(SearchState state, String? carCondition) {
    return state.copyWith(seletedCondition: Nullable.value(carCondition));
  }

  // Select Fuel Type Filter
  SearchState selectFuelType(SearchState state, String? fuelType) {
    return state.copyWith(seletedFuelType: Nullable.value(fuelType));
  }

  // Reset Filters
  SearchState resetMakerSelectionFilter(SearchState state) {
    return state.copyWith(selectedCarMakersFilter: []);
  }

  SearchState resetKilometersFilter(SearchState state,
      {bool? resetMinKilometers, bool? resetMaxKilometers}) {
    String? newMinKilometers =
        resetMinKilometers == true ? null : state.selectedCarMinKilometers;
    String? newMaxKilometers =
        resetMaxKilometers == true ? null : state.selectedCarMaxKilometers;
    return state.copyWith(
        selectedCarMinKilometers: Nullable.value(newMinKilometers),
        selectedCarMaxKilometers: Nullable.value(newMaxKilometers));
  }

  SearchState resetYearFilter(SearchState state,
      {bool? resetMinYear, bool? resetMaxYear}) {
    int? newMinYear = resetMinYear == true ? null : state.selectedCarMinYear;
    int? newMaxYear = resetMaxYear == true ? null : state.selectedCarMaxYear;
    return state.copyWith(
        selectedCarMinYear: Nullable.value(newMinYear),
        selectedCarMaxYear: Nullable.value(newMaxYear));
  }

  SearchState resetPriceFilter(SearchState state) {
    return state.copyWith(selectedPrice: const Nullable.value(null));
  }

  SearchState resetTransmissionFilter(SearchState state) {
    return state.copyWith(selectedTransmission: const Nullable.value(null));
  }

  SearchState resetCarBodyTypeFilter(SearchState state) {
    return state.copyWith(seletedBodyType: const Nullable.value(null));
  }

  SearchState resetFuelTypeFilter(SearchState state) {
    return state.copyWith(seletedFuelType: const Nullable.value(null));
  }

  SearchState resetCylindersFilter(SearchState state) {
    return state.copyWith(seletedCylinders: const Nullable.value(null));
  }

  SearchState resetSeatsFilter(SearchState state) {
    return state.copyWith(seletedSeatsCount: const Nullable.value(null));
  }

  SearchState resetColorFilter(SearchState state) {
    return state.copyWith(seletedColors: []);
  }

  SearchState resetConditionFilter(SearchState state) {
    return state.copyWith(seletedCondition: const Nullable.value(null));
  }
}

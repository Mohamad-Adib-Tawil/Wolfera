import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/services/supabase_service.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  // final GetHomeDataUsecase _getHomeDataUsecase;

  HomeCubit(
      // this._getHomeDataUsecase, this._favoriteItemToggleUsecase,
      //   this._favoritecarToggleUsecase
      )
      : super(const HomeState());

  void getRentalCars() async {
    print('\n🚗 HomeCubit: Fetching RENTAL cars from Supabase...');
    emit(state.copyWith(rentalCarsState: const PageState.loading()));
    List<Map<String, dynamic>> rentalCars = [];

    // Primary query
    try {
      final primary = await SupabaseService.client
          .from('cars')
          .select('*')
          .inFilter('listing_type', ['rent', 'both'])
          .inFilter('status', ['active', 'available', 'Active', 'Available'])
          .order('created_at', ascending: false)
          .limit(20);
      rentalCars = (primary as List).cast<Map<String, dynamic>>();
      print('✅ HomeCubit: Primary query returned ${rentalCars.length} cars');
    } catch (e) {
      print('⚠️ HomeCubit: Primary rental query failed: $e');
    }

    // Fallback if primary failed or returned empty
    if (rentalCars.isEmpty) {
      try {
        print('ℹ️ HomeCubit: Trying fallback rental fetch...');
        final fallback = await SupabaseService.client
            .from('cars')
            .select('*')
            .order('created_at', ascending: false)
            .limit(50);
        final list = (fallback as List).cast<Map<String, dynamic>>();
        rentalCars = list.where((c) {
          final lt = c['listing_type']?.toString().toLowerCase();
          final anyRental = c['rental_price_per_day'] != null ||
              c['rental_price_per_week'] != null ||
              c['rental_price_per_month'] != null ||
              c['rental_price_per_3months'] != null ||
              c['rental_price_per_6months'] != null ||
              c['rental_price_per_year'] != null;
          final status = c['status']?.toString().toLowerCase();
          final isActive = status == null || status == 'active' || status == 'available';
          return isActive && (lt == 'rent' || lt == 'both' || anyRental);
        }).take(20).toList();
        print('✅ HomeCubit: Fallback produced ${rentalCars.length} cars');
      } catch (e) {
        print('❌ HomeCubit: Fallback rental fetch failed: $e');
        emit(state.copyWith(
            rentalCarsState: PageState.error(
                exception: e is Exception ? e : Exception(e.toString()))));
        return;
      }
    }

    emit(state.copyWith(rentalCarsState: PageState.loaded(data: rentalCars)));
  }

  void getHomeData() async {
    print('\n🏠 HomeCubit: Fetching FEATURED cars from Supabase...');
    emit(state.copyWith(carsState: const PageState.loading()));
    try {
      // Fetch FEATURED cars only for RecommendedSection
      final cars = await SupabaseService.getFeaturedCars();
      print('📊 HomeCubit: Fetched ${cars.length} FEATURED cars from database');

      // Optionally show only active/available featured cars; if none, fall back to all featured
      final filtered = cars
          .where((e) => (e['status']?.toString().toLowerCase() ?? '')
              .contains('available'))
          .toList();

      final finalList = filtered.isEmpty ? cars : filtered;
      print('✅ HomeCubit: Showing ${finalList.length} featured cars (available subset: ${filtered.length})');

      emit(state.copyWith(carsState: PageState.loaded(data: finalList)));
    } catch (e) {
      print('❌ HomeCubit: Error fetching cars: $e');
      emit(state.copyWith(
          carsState: PageState.error(
              exception: e is Exception ? e : Exception(e.toString()))));
    }
  }

  // favoriteCarToggle(CarViewModel car) async {
  //   try {
  //     car.isFavorite.value = !car.isFavorite.value;

  //     final result = await _favoriteCarToggleUsecase(
  //         FavoriteCarToggleParams(
  //             carId: car.car.id.toString()));

  //     result.fold(
  //       (exception, message) {
  //         car.isFavorite.value = !car.isFavorite.value;
  //       },
  //       (value) => null,
  //     );
  //   } catch (e) {
  //     car.isFavorite.value = !car.isFavorite.value;
  //   }
  // }

  // favoriteItemToggle(ItemViewModel item) async {
  //   try {
  //     item.isFavorite.value = !item.isFavorite.value;

  //     final result = await _favoriteItemToggleUsecase(
  //         FavoriteItemToggleParams(itemId: item.item.id.toString()));

  //     result.fold(
  //       (exception, message) {
  //         item.isFavorite.value = !item.isFavorite.value;
  //       },
  //       (value) => null,
  //     );
  //   } catch (e) {
  //     item.isFavorite.value = !item.isFavorite.value;
  //   }
  // }
  // void getRecommendedcars(int page) async {
  //   final result = await _getRecommendedcarsUsecase(
  //       GetRecommendedcarsParams(page: page));

  //   result.fold(
  //     (exception, message) =>
  //         recommendedcarsController.error = exception,
  //     (value) {
  //       final hasReachedMax =
  //           HelperFunctions.instance.hasReachedMax(value.data);
  //       if (hasReachedMax) {
  //         recommendedcarsController.appendLastPage(value.data ?? []);
  //       } else {
  //         final nextPage =
  //             (recommendedcarsController.nextPageKey ?? 1) + 1;
  //         recommendedcarsController.appendPage(
  //             value.data ?? [], nextPage);
  //       }
  //       emit(state.copyWith(
  //           carsState: PageState.loaded(data: value.data ?? [])));
  //     },
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  // final GetHomeDataUsecase _getHomeDataUsecase;

  HomeCubit(
      // this._getHomeDataUsecase, this._favoriteItemToggleUsecase,
      //   this._favoritecarToggleUsecase
      )
      : super(const HomeState());

  void getHomeData() async {
    // emit(state.copyWith(homeDataState: const PageState.loading()));

    // final response = await _getHomeDataUsecase();

    // response.fold(
    //   (exception, message) => emit(
    //       state.copyWith(homeDataState: PageState.error(exception: exception))),
    //   (value) {
    //     emit(
    //         state.copyWith(homeDataState: PageState.loaded(data: value.data!)));
    //   },
    // );
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

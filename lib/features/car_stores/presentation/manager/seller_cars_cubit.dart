import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/features/car_stores/data/repositories/seller_cars_repository.dart';

class SellerCarsState extends Equatable {
  const SellerCarsState({
    this.carsState = const PageState.init(),
  });

  final PageState<List<Map<String, dynamic>>> carsState;

  SellerCarsState copyWith({
    PageState<List<Map<String, dynamic>>>? carsState,
  }) {
    return SellerCarsState(
      carsState: carsState ?? this.carsState,
    );
  }

  @override
  List<Object?> get props => [carsState];
}

class SellerCarsCubit extends Cubit<SellerCarsState> {
  SellerCarsCubit({
    required SellerCarsRepository repository,
  })  : _repository = repository,
        super(const SellerCarsState());

  final SellerCarsRepository _repository;

  Future<void> loadSellerCars(String sellerId) async {
    if (sellerId.isEmpty) {
      emit(state.copyWith(carsState: const PageState.empty()));
      return;
    }

    emit(state.copyWith(carsState: const PageState.loading()));
    try {
      final cars = await _repository.fetchSellerCars(sellerId);
      emit(
        state.copyWith(
          carsState: cars.isEmpty
              ? const PageState.empty()
              : PageState.loaded(data: cars),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          carsState: PageState.error(
            exception: e is Exception ? e : Exception(e.toString()),
          ),
        ),
      );
    }
  }
}

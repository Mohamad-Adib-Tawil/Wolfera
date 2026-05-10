import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/features/car_stores/data/repositories/seller_cars_repository.dart';
import 'package:wolfera/features/car_stores/domain/entities/car_publisher.dart';

class CarStoresState extends Equatable {
  const CarStoresState({
    this.publishersState = const PageState.init(),
  });

  final PageState<List<CarPublisher>> publishersState;

  CarStoresState copyWith({
    PageState<List<CarPublisher>>? publishersState,
  }) {
    return CarStoresState(
      publishersState: publishersState ?? this.publishersState,
    );
  }

  @override
  List<Object?> get props => [publishersState];
}

class CarStoresCubit extends Cubit<CarStoresState> {
  CarStoresCubit({
    required SellerCarsRepository repository,
  })  : _repository = repository,
        super(const CarStoresState());

  final SellerCarsRepository _repository;

  Future<void> loadCarStores() async {
    emit(state.copyWith(publishersState: const PageState.loading()));
    try {
      final publishers = await _repository.fetchCarPublishers();
      emit(
        state.copyWith(
          publishersState: publishers.isEmpty
              ? const PageState.empty()
              : PageState.loaded(data: publishers),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          publishersState: PageState.error(
            exception: e is Exception ? e : Exception(e.toString()),
          ),
        ),
      );
    }
  }
}

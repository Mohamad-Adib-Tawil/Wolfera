part of 'home_cubit.dart';

@immutable
class HomeState {
  const HomeState({
    this.carsState = const PageState.init(),
    this.rentalCarsState = const PageState.init(),
  });

  final PageState<List<Map<String, dynamic>>> carsState;
  final PageState<List<Map<String, dynamic>>> rentalCarsState;

  List<Object?> get props => [carsState, rentalCarsState];

  HomeState copyWith({
    PageState<List<Map<String, dynamic>>>? carsState,
    PageState<List<Map<String, dynamic>>>? rentalCarsState,
  }) {
    return HomeState(
      carsState: carsState ?? this.carsState,
      rentalCarsState: rentalCarsState ?? this.rentalCarsState,
    );
  }
}

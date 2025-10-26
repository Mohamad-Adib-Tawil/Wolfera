part of 'home_cubit.dart';

@immutable
class HomeState {
  const HomeState({this.carsState = const PageState.init()});

  final PageState<List<Map<String, dynamic>>> carsState;

  @override
  List<Object?> get props => [carsState];

  HomeState copyWith({PageState<List<Map<String, dynamic>>>? carsState}) {
    return HomeState(carsState: carsState ?? this.carsState);
  }
}

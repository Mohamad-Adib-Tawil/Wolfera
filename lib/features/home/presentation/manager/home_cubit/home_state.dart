part of 'home_cubit.dart';

@immutable
class HomeState {
  const HomeState(
      // this.homeDataState = const PageState.init(),
      );

  // final PageState<HomeData> homeDataState;
  @override
  List<Object?> get props => [
        // homeDataState,
      ];
  HomeState copyWith(
      // PageState<HomeData>? homeDataState,
      ) {
    return const HomeState(
        // homeDataState: homeDataState ?? this.homeDataState,
        );
  }
}

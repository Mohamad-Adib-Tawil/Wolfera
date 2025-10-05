part of 'my_cars_bloc.dart';

class MyCarsState extends Equatable {
  final int activeStep;
  final BlocStatus sellMyCarStatus;

  @override
  List<Object?> get props => [
        activeStep,
        sellMyCarStatus,
      ];
  const MyCarsState({
    this.activeStep = 0,
    this.sellMyCarStatus = const BlocStatus.initial(),
  });

  MyCarsState copyWith({
    int? activeStep,
    BlocStatus? sellMyCarStatus,
  }) {
    return MyCarsState(
      activeStep: activeStep ?? this.activeStep,
      sellMyCarStatus: sellMyCarStatus ?? this.sellMyCarStatus,
    );
  }

  factory MyCarsState.initial() {
    return const MyCarsState(
      activeStep: 0,
    );
  }
}

part of 'my_cars_bloc.dart';

class MyCarsState extends Equatable {
  final int activeStep;
  final BlocStatus sellMyCarStatus;
  // حالة جلب السيارات
  final BlocStatus loadCarsStatus;
  // قائمة السيارات الخاصة بالمستخدم
  final List<Map<String, dynamic>> myCars;
  // حالة عرض القالب الافتراضي
  final bool isTemplateVisible;

  @override
  List<Object?> get props => [
        activeStep,
        sellMyCarStatus,
        loadCarsStatus,
        myCars,
        isTemplateVisible,
      ];
  const MyCarsState({
    this.activeStep = 0,
    this.sellMyCarStatus = const BlocStatus.initial(),
    this.loadCarsStatus = const BlocStatus.initial(),
    this.myCars = const [],
    this.isTemplateVisible = true,
  });

  MyCarsState copyWith({
    int? activeStep,
    BlocStatus? sellMyCarStatus,
    BlocStatus? loadCarsStatus,
    List<Map<String, dynamic>>? myCars,
    bool? isTemplateVisible,
  }) {
    return MyCarsState(
      activeStep: activeStep ?? this.activeStep,
      sellMyCarStatus: sellMyCarStatus ?? this.sellMyCarStatus,
      loadCarsStatus: loadCarsStatus ?? this.loadCarsStatus,
      myCars: myCars ?? this.myCars,
      isTemplateVisible: isTemplateVisible ?? this.isTemplateVisible,
    );
  }

  factory MyCarsState.initial() {
    return const MyCarsState(
      activeStep: 0,
      isTemplateVisible: true,
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/utils/nullable.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/features/my_car/domain/usecases/sell_my_car_usecase.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/my_car/presentation/pages/sell_my_car_page.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

part 'my_cars_event.dart';
part 'my_cars_state.dart';

@lazySingleton
class MyCarsBloc extends Bloc<MyCarsEvent, MyCarsState> {
  MyCarsBloc(this._sellMyCarUsecase) : super(const MyCarsState()) {
    on<NextPageEvent>(nextPage);
    on<PreviousPageEvent>(previousPage);
    on<BackPageEvent>(back);
    on<AddOptionalImageEvent>(addOptionalImageControl);
    on<ResetSellMyCarEvent>(resetSellMyCar);
    on<SellMyCarEvent>(sellMyCar);
    on<LoadMyCarsEvent>(_onLoadMyCars);
    on<DeleteMyCarEvent>(_onDeleteMyCar);
  }
  final SellMyCarUsecase _sellMyCarUsecase;
  final String kFromCarMaker = 'carMaker';
  final String kFromCarModel = 'carModel';
  final String kFromCarEngine = 'carEngine';
  final String kFromCarYear = 'carYear';
  final String kFromCarTransmission = 'carTransmission';
  final String kFromCarMileage = 'carMileage';
  final String kFromCarFuelType = 'carFuelType';
  final String kFromCarTrim = 'carTrim';
  final String kFromCarCylinders = 'carCylinders';
  final String kFromCarSeats = 'carSeats';
  final String kFromCarPaintParts = 'carPaintParts';
  final String kFromCarCondition = 'carCondition';
  final String kFromCarPlate = 'carPlate';
  final String kFromCarColor = 'carColor';
  final String kFromCarSeatMaterial = 'carSeatMaterial';
  final String kFromCarWheels = 'carWheels';
  final String kFromCarVehicleType = 'carVehicleType';
  final String kFromCarInteriorColor = 'carInteriorColor';
  final String kFromCarExteriorColor = 'carExteriorColor';
  final String kFromCarSafety = 'carSafety';
  final String kFromCarExterior = 'carExterior';
  final String kFromCarInterior = 'carInterior';
  final String kFromCarDescription = 'carDescription';
  final String kFromCarPrice = 'carPrice';
  final String kFromCarLocation = 'carLocation';
  final String kFromCarImageFullRight = 'carImageFullRight';
  final String kFromCarImageFullLeft = 'carImageFullLeft';
  final String kFromCarImageRear = 'carImageRear';
  final String kFromCarImageFront = 'carImageFront';
  final String kFromCarImageDashboard = 'carImageDashboard';

  FutureOr<void> sellMyCar(
      SellMyCarEvent event, Emitter<MyCarsState> emit) async {
    try {
      emit(state.copyWith(sellMyCarStatus: const BlocStatus.loading()));
      EasyLoading.show(
        status: LocaleKeys.requestIsInProgress.tr(),
        dismissOnTap: false,
      );
      final String userId = SupabaseService.currentUser!.id;
      final params = SellMyCarParams(
        userId: userId,
        location: 'Dubai',
        status: 'Available',
        carMaker: sellMyCarForm.control(kFromCarMaker).value as String,
        carModel: sellMyCarForm.control(kFromCarModel).value as String,
        carEngine: sellMyCarForm.control(kFromCarEngine).value as String,
        carYear: sellMyCarForm.control(kFromCarYear).value as String,
        carTransmission:
            sellMyCarForm.control(kFromCarTransmission).value as String,
        carMileage: sellMyCarForm.control(kFromCarMileage).value as String,
        carFuelType: sellMyCarForm.control(kFromCarFuelType).value as String,
        carTrim: sellMyCarForm.control(kFromCarTrim).value as String,
        carCylinders: sellMyCarForm.control(kFromCarCylinders).value as String,
        carSeats: sellMyCarForm.control(kFromCarSeats).value as String,
        carPaintParts:
            sellMyCarForm.control(kFromCarPaintParts).value as String,
        carCondition: sellMyCarForm.control(kFromCarCondition).value as String,
        carPlate: sellMyCarForm.control(kFromCarPlate).value as String,
        carColor: sellMyCarForm.control(kFromCarColor).value as String,
        carSeatMaterial:
            sellMyCarForm.control(kFromCarSeatMaterial).value as String,
        carWheels: sellMyCarForm.control(kFromCarWheels).value as String,
        carVehicleType:
            sellMyCarForm.control(kFromCarVehicleType).value as String,
        carInteriorColor:
            sellMyCarForm.control(kFromCarInteriorColor).value as String,
        carExteriorColor:
            sellMyCarForm.control(kFromCarExteriorColor).value as String,
        carSafety: sellMyCarForm.control(kFromCarSafety).value as List<String>,
        carExteriorFeatures:
            sellMyCarForm.control(kFromCarExterior).value as List<String>,
        carInteriorFeatures:
            sellMyCarForm.control(kFromCarInterior).value as List<String>,
        carDescription:
            descriptionSectionForm.control(kFromCarDescription).value as String,
        carPrice: descriptionSectionForm.control(kFromCarPrice).value as String,
        carLocation:
            descriptionSectionForm.control(kFromCarLocation).value as String,
        carImages: [
          imagesSectionForm.control(kFromCarImageFullRight).value as File?,
          imagesSectionForm.control(kFromCarImageFullLeft).value as File?,
          imagesSectionForm.control(kFromCarImageRear).value as File?,
          imagesSectionForm.control(kFromCarImageFront).value as File?,
          imagesSectionForm.control(kFromCarImageDashboard).value as File?,
          ...imagesSectionForm.controls.entries
              .where((entry) => entry.key.startsWith('optionalImage'))
              .map((entry) => entry.value.value as File?)
        ],
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
      );
      print('\n🔵 MyCarsBloc: Calling sellMyCarUsecase...');
      final result = await _sellMyCarUsecase(params);
      
      result.fold(
        (exception, message) {
          print('🔴 MyCarsBloc: Sell car FAILED');
          print('   Exception: $exception');
          print('   Message: $message');
          
          EasyLoading.dismiss();

          emit(
              state.copyWith(sellMyCarStatus: BlocStatus.fail(error: message)));
          EasyLoading.showError(
            message ?? "Something went wrong!",
            duration: const Duration(seconds: 2),
            dismissOnTap: true,
          );
        },
        (value) {
          print('🟢 MyCarsBloc: Sell car SUCCESS');
          EasyLoading.dismiss();

          // Refresh Home cars list so the new car appears on Home
          print('🔄 Refreshing Home cars list...');
          try {
            GetIt.I<HomeCubit>().getHomeData();
            print('✅ Home refresh triggered');
          } catch (e) {
            print('⚠️  Failed to refresh home: $e');
          }

          // إعادة تحميل سيارات المستخدم بعد إضافة سيارة جديدة
          add(LoadMyCarsEvent());

          print('🎉 Navigating to congratulations page...');
          GRouter.router
              .pushNamed(GRouter.config.myCarsRoutes.congratulationsPage);

          emit(state.copyWith(sellMyCarStatus: const BlocStatus.success()));
        },
      );
    } catch (e) {
      print('💥 MyCarsBloc: Unexpected error in sellMyCar: $e');
      
      emit(state.copyWith(
          sellMyCarStatus: BlocStatus.fail(error: e.toString())));

      EasyLoading.dismiss();
    }
  }

  FutureOr<void> nextPage(NextPageEvent event, Emitter<MyCarsState> emit) {
    if ((sellMyCarForm.valid && state.activeStep == 0)) {
      emit(state.copyWith(activeStep: state.activeStep + 1));
    } else if (state.activeStep == 1 && sellMyCarForm.valid) {
      emit(state.copyWith(activeStep: state.activeStep + 1));
    } else if (descriptionSectionForm.valid &&
        state.activeStep == 2 &&
        sellMyCarForm.valid) {
      emit(state.copyWith(activeStep: state.activeStep + 1));
    } else if (imagesSectionForm.valid &&
        descriptionSectionForm.valid &&
        state.activeStep == 3 &&
        sellMyCarForm.valid) {
      add(SellMyCarEvent());
    } else {
      if (state.activeStep == 0) {
        sellMyCarForm.markAllAsTouched();
      }

      if (state.activeStep == 2) {
        sellMyCarForm.markAllAsTouched();
        descriptionSectionForm.markAllAsTouched();
      } else if (state.activeStep == 3) {
        sellMyCarForm.markAllAsTouched();
        descriptionSectionForm.markAllAsTouched();
        imagesSectionForm.markAllAsTouched();
      }
    }
  }

  previousPage(PreviousPageEvent event, Emitter<MyCarsState> emit) {
    emit(state.copyWith(activeStep: state.activeStep - 1));
  }

  back(BackPageEvent event, Emitter<MyCarsState> emit) {
    if (state.activeStep != 0) {
      add(PreviousPageEvent());
      return;
    }
    GRouter.router.pop();
  }

  late final sellMyCarForm = FormGroup({
    kFromCarMaker: FormControl<String>(
      value: 'BMW',
      validators: [Validators.required],
    ),
    kFromCarModel: FormControl<String>(
      value: 'M4',
      validators: [Validators.required],
    ),
    kFromCarEngine: FormControl<String>(
      value: '3.0L Twin-Turbo I6',
      validators: [Validators.required],
    ),
    kFromCarYear: FormControl<String>(
      value: '2024',
      validators: [Validators.required],
    ),
    kFromCarTransmission: FormControl<String>(
      value: 'Automatic',
      validators: [Validators.required],
    ),
    kFromCarMileage: FormControl<String>(
      value: '0',
      validators: [Validators.required],
    ),
    kFromCarFuelType: FormControl<String>(
      value: 'Gasoline',
      validators: [Validators.required],
    ),
    kFromCarTrim: FormControl<String>(
      value: 'Competition',
      validators: [Validators.required],
    ),
    kFromCarCylinders: FormControl<String>(
      value: '6',
      validators: [Validators.required],
    ),
    kFromCarSeats: FormControl<String>(
      value: '4',
      validators: [Validators.required],
    ),
    kFromCarPaintParts: FormControl<String>(
      value: 'Original',
      validators: [Validators.required],
    ),
    kFromCarCondition: FormControl<String>(
      value: 'New',
      validators: [Validators.required],
    ),
    kFromCarPlate: FormControl<String>(
      value: 'N/A',
      validators: [Validators.required],
    ),
    kFromCarColor: FormControl<String>(
      value: 'Sapphire Black',
      validators: [Validators.required],
    ),
    kFromCarSeatMaterial: FormControl<String>(
      value: 'Leather',
      validators: [Validators.required],
    ),
    kFromCarWheels: FormControl<String>(
      value: '19" Alloy',
      validators: [Validators.required],
    ),
    kFromCarVehicleType: FormControl<String>(
      value: 'Coupe',
      validators: [Validators.required],
    ),
    kFromCarInteriorColor: FormControl<String>(
      value: 'Black',
      validators: [Validators.required],
    ),
    kFromCarExteriorColor: FormControl<String>(
      value: 'Sapphire Black',
      validators: [Validators.required],
    ),
    kFromCarSafety: FormControl<List<String>>(
      value: ['Airbags', 'ABS', 'Lane Assist'],
    ),
    kFromCarExterior: FormControl<List<String>>(
      value: ['LED Headlights', 'Carbon Fiber Spoiler'],
    ),
    kFromCarInterior: FormControl<List<String>>(
      value: ['Heated Seats', 'Ambient Lighting'],
    ),
  });

  late final descriptionSectionForm = FormGroup({
    kFromCarDescription: FormControl<String>(
        validators: [Validators.required],
        value: "BMW 3.0L Twin-Turbo I6 2024 Automatic."),
    kFromCarPrice:
        FormControl<String>(validators: [Validators.required], value: "15000"),
    kFromCarLocation: FormControl<String>(
        validators: [Validators.required], value: "Germany"),
  });
  late final imagesSectionForm = FormGroup({
    kFromCarImageFullRight:
        FormControl<File?>(validators: [Validators.required]),
    kFromCarImageFullLeft:
        FormControl<File?>(validators: [Validators.required]),
    kFromCarImageRear: FormControl<File?>(validators: [Validators.required]),
    kFromCarImageFront: FormControl<File?>(validators: [Validators.required]),
    kFromCarImageDashboard:
        FormControl<File?>(validators: [Validators.required])
  });
  addOptionalImageControl(
      AddOptionalImageEvent event, Emitter<MyCarsState> emit) {
    if (imagesSectionForm.controls.length < 8) {
      final controlName = 'optionalImage${imagesSectionForm.controls.length}';
      imagesSectionForm.addAll({
        controlName: FormControl<File?>(),
      });
    }
  }

  resetSellMyCar(ResetSellMyCarEvent event, Emitter<MyCarsState> emit) {
    emit(state.copyWith(activeStep: 0));

    for (int i = imagesSectionForm.controls.length; i > 4; i--) {
      if (imagesSectionForm.contains("optionalImage$i")) {
        imagesSectionForm.removeControl("optionalImage$i");
      }
    }

    imagesSectionForm.reset();
    descriptionSectionForm.reset();
    sellMyCarForm.reset();
  }

  // جلب السيارات الخاصة بالمستخدم الحالي
  Future<void> _onLoadMyCars(
    LoadMyCarsEvent event,
    Emitter<MyCarsState> emit,
  ) async {
    try {
      emit(state.copyWith(loadCarsStatus: const BlocStatus.loading()));

      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(
          loadCarsStatus: const BlocStatus.fail(error: 'User not logged in'),
          myCars: [],
        ));
        return;
      }

      // جلب السيارات من Supabase مع تصفية حسب user_id
      final response = await SupabaseService.client
          .from('cars')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final cars = (response as List).cast<Map<String, dynamic>>();

      emit(state.copyWith(
        loadCarsStatus: const BlocStatus.success(),
        myCars: cars,
      ));
    } catch (e, stackTrace) {
      print('🔴 Error loading my cars: $e');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        loadCarsStatus: BlocStatus.fail(error: e.toString()),
        myCars: [],
      ));
    }
  }

  // حذف سيارة
  Future<void> _onDeleteMyCar(
    DeleteMyCarEvent event,
    Emitter<MyCarsState> emit,
  ) async {
    try {
      EasyLoading.show(status: 'Deleting car...');

      await SupabaseService.deleteCar(event.carId);

      // إعادة تحميل القائمة بعد الحذف
      add(LoadMyCarsEvent());

      EasyLoading.showSuccess('Car deleted successfully');
    } catch (e) {
      print('🔴 Error deleting car: $e');
      EasyLoading.showError('Failed to delete car');
    }
  }
}

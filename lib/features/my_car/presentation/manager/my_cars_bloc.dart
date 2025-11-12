import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/features/my_car/domain/usecases/sell_my_car_usecase.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:wolfera/core/constants/locations_data.dart';
import 'package:wolfera/core/constants/currencies.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';

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
    on<DeleteAllMyCarsEvent>(_onDeleteAllMyCars);
    on<UpdateMyCarStatusEvent>(_onUpdateMyCarStatus);
    on<UpdateMyCarPriceEvent>(_onUpdateMyCarPrice);
    on<UpdateMyCarRentalPricesEvent>(_onUpdateMyCarRentalPrices);
    on<ToggleTemplateEvent>(_onToggleTemplate);

    // Initialize dynamic validators for description form
    try {
      final lt = descriptionSectionForm.control(kFromListingType).value as String? ?? 'sale';
      updateValidatorsByListingType(lt);
    } catch (e) {
      // ignore
    }
    
    // تطبيق القالب الافتراضي عند بدء التطبيق
    _applyTemplate();
  }

  // تحديث أسعار الإيجار للسيارة
  Future<void> _onUpdateMyCarRentalPrices(
    UpdateMyCarRentalPricesEvent event,
    Emitter<MyCarsState> emit,
  ) async {
    try {
      EasyLoading.show(status: 'Updating rental prices...');

      Map<String, dynamic> update = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      bool anyField = false;
      void setField(String key, String? v) {
        if (v == null) return; // skip if not provided
        anyField = true;
        final s = v.trim();
        if (s.isEmpty) {
          update[key] = null; // clear value
          return;
        }
        final num? parsed = num.tryParse(s);
        if (parsed == null) {
          throw Exception('Invalid number for $key');
        }
        update[key] = parsed;
      }

      setField('rental_price_per_day', event.perDay);
      setField('rental_price_per_week', event.perWeek);
      setField('rental_price_per_month', event.perMonth);
      setField('rental_price_per_3months', event.per3Months);
      setField('rental_price_per_6months', event.per6Months);
      setField('rental_price_per_year', event.perYear);

      if (!anyField) {
        EasyLoading.dismiss();
        EasyLoading.showInfo('No changes to update');
        return;
      }

      // استخدام updateCar بدلاً من التحديث المباشر لضمان إرسال الإشعارات
      await SupabaseService.updateCar(event.carId, update);

      // إعادة تحميل القائمة بعد التحديث
      add(LoadMyCarsEvent());

      // تحديث الصفحة الرئيسية
      try {
        GetIt.I<HomeCubit>().getHomeData();
        GetIt.I<SearchCubit>().searchCars();
      } catch (_) {}

      EasyLoading.showSuccess('Rental prices updated');
    } catch (e) {
      print('🔴 Error updating rental prices: $e');
      EasyLoading.showError('Failed to update rental prices');
    }
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
  // Address selections (new)
  final String kFromWorldwide = 'worldwide';
  final String kFromCountryCode = 'countryCode';
  final String kFromRegionOrCity = 'regionOrCity';
  // Price currency selection (new)
  final String kFromCurrencyCode = 'currencyCode';
  // Listing type and rental prices (new)
  final String kFromListingType = 'listingType';
  final String kFromRentalPricePerDay = 'rental_price_per_day';
  final String kFromRentalPricePerWeek = 'rental_price_per_week';
  final String kFromRentalPricePerMonth = 'rental_price_per_month';
  final String kFromRentalPricePerThreeMonths = 'rental_price_per_3months';
  final String kFromRentalPricePerSixMonths = 'rental_price_per_6months';
  final String kFromRentalPricePerYear = 'rental_price_per_year';
  final String kFromCarImageFullRight = 'carImageFullRight';
  final String kFromCarImageFullLeft = 'carImageFullLeft';
  final String kFromCarImageRear = 'carImageRear';
  final String kFromCarImageFront = 'carImageFront';
  final String kFromCarImageDashboard = 'carImageDashboard';

  String _computeCountryName() {
    try {
      final bool worldwide =
          descriptionSectionForm.control(kFromWorldwide).value as bool? ?? true;
      if (worldwide) return 'Worldwide';
      final String? code =
          descriptionSectionForm.control(kFromCountryCode).value as String?;
      if (code == null) return 'Worldwide';
      return LocationsData.findByCode(code)?.name ?? 'Worldwide';
    } catch (_) {
      return 'Worldwide';
    }
  }

  // حذف جميع سيارات المستخدم الحالي
  Future<void> _onDeleteAllMyCars(
    DeleteAllMyCarsEvent event,
    Emitter<MyCarsState> emit,
  ) async {
    try {
      EasyLoading.show(status: 'Deleting all cars...');

      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('User not logged in');
        return;
      }

      bool bulkDeleted = false;
    try {
      await SupabaseService.client.from('cars').delete().eq('user_id', userId);
      bulkDeleted = true;
    } catch (e) {
      print('⚠️ Bulk delete failed, falling back to per-car delete: $e');
    }

    if (!bulkDeleted) {
      final rows = await SupabaseService.client
          .from('cars')
          .select('id')
          .eq('user_id', userId);
      for (final row in (rows as List)) {
        final id = row['id']?.toString();
        if (id != null && id.isNotEmpty) {
          try {
            await SupabaseService.deleteCar(id);
          } catch (e) {
            print('🔴 Failed to delete car $id during delete-all fallback: $e');
          }
        }
      }
    }

      // إعادة تحميل القائمة بعد الحذف
      add(LoadMyCarsEvent());

      // تحديث قائمة السيارات في الصفحة الرئيسية بعد الحذف الكلي + تحديث المفضلة
      try {
        GetIt.I<HomeCubit>().getHomeData();
        GetIt.I<SearchCubit>().searchCars();
        GetIt.I<FavoriteCubit>().init();
      } catch (e) {
        print('⚠️ Failed to refresh after delete-all: $e');
      }

      EasyLoading.showSuccess('All cars deleted successfully');
    } catch (e) {
      print('🔴 Error deleting all cars: $e');
      EasyLoading.showError('Failed to delete all cars');
    }
  }

  FutureOr<void> sellMyCar(
      SellMyCarEvent event, Emitter<MyCarsState> emit) async {
    try {
      emit(state.copyWith(sellMyCarStatus: const BlocStatus.loading()));
      EasyLoading.show(
        status: LocaleKeys.requestIsInProgress.tr(),
        dismissOnTap: false,
      );
      final String userId = SupabaseService.currentUser!.id;

      // Validate listing type / pricing consistency before building params
      final listingType = descriptionSectionForm.control(kFromListingType).value as String? ?? 'sale';
      final salePriceStr = (descriptionSectionForm.control(kFromCarPrice).value as String?)?.trim() ?? '';
      final rentals = <String?>[
        descriptionSectionForm.control(kFromRentalPricePerDay).value as String?,
        descriptionSectionForm.control(kFromRentalPricePerWeek).value as String?,
        descriptionSectionForm.control(kFromRentalPricePerMonth).value as String?,
        descriptionSectionForm.control(kFromRentalPricePerThreeMonths).value as String?,
        descriptionSectionForm.control(kFromRentalPricePerSixMonths).value as String?,
        descriptionSectionForm.control(kFromRentalPricePerYear).value as String?,
      ].map((e) => e?.trim()).toList();
      final hasAnyRental = rentals.any((v) => v != null && v.isNotEmpty);
      if (listingType == 'rent' && !hasAnyRental) {
        EasyLoading.dismiss();
        emit(state.copyWith(
            sellMyCarStatus:
                const BlocStatus.fail(error: 'Please enter at least one rental price')));
        EasyLoading.showError('Please enter at least one rental price');
        return;
      }
      if (listingType == 'both' && (!hasAnyRental || salePriceStr.isEmpty)) {
        EasyLoading.dismiss();
        emit(state.copyWith(
            sellMyCarStatus: const BlocStatus.fail(
                error: 'Please enter sale price and at least one rental price')));
        EasyLoading.showError('Please enter sale price and at least one rental price');
        return;
      }

      // ===== Address validation (required unless Worldwide) =====
      final bool isWorldwide =
          descriptionSectionForm.control(kFromWorldwide).value as bool? ?? true;
      final String? countryCode =
          descriptionSectionForm.control(kFromCountryCode).value as String?;
      // Region is optional. If not Worldwide, require country only.
      if (!isWorldwide && countryCode == null) {
        EasyLoading.dismiss();
        emit(state.copyWith(
            sellMyCarStatus: const BlocStatus.fail(
                error: 'Please select country')));
        EasyLoading.showError('Please select country');
        return;
      }
      final params = SellMyCarParams(
        userId: userId,
        // Use countryName for 'location' param (legacy mapping)
        location: _computeCountryName(),
        status: 'Available',
        currency: CurrenciesData.symbolFor(
          descriptionSectionForm.control(kFromCurrencyCode).value as String?
        ),
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
        // regionOrCity stored in 'carLocation' (legacy mapping)
        carLocation: descriptionSectionForm.control(kFromRegionOrCity).value as String? ?? '',
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
        // Listing type and rental prices
        listingType: descriptionSectionForm.control(kFromListingType).value as String?,
        rentalPricePerDay: descriptionSectionForm.control(kFromRentalPricePerDay).value as String?,
        rentalPricePerWeek: descriptionSectionForm.control(kFromRentalPricePerWeek).value as String?,
        rentalPricePerMonth: descriptionSectionForm.control(kFromRentalPricePerMonth).value as String?,
        rentalPricePerThreeMonths: descriptionSectionForm.control(kFromRentalPricePerThreeMonths).value as String?,
        rentalPricePerSixMonths: descriptionSectionForm.control(kFromRentalPricePerSixMonths).value as String?,
        rentalPricePerYear: descriptionSectionForm.control(kFromRentalPricePerYear).value as String?,
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
            GetIt.I<SearchCubit>().searchCars();
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

  // Apply validators based on listing type selection
  void updateValidatorsByListingType(String type) {
    final priceControl = descriptionSectionForm.control(kFromCarPrice) as FormControl<String>;
    if (type == 'rent') {
      priceControl.setValidators([]);
    } else {
      priceControl.setValidators([Validators.required]);
    }
    priceControl.updateValueAndValidity();
    descriptionSectionForm.updateValueAndValidity();
  }

  // Central method to change listing type and normalize fields
  void applyListingType(String type) {
    descriptionSectionForm.control(kFromListingType).updateValue(type);
    updateValidatorsByListingType(type);
    if (type == 'rent') {
      // Clear sale price when rent-only
      descriptionSectionForm.control(kFromCarPrice).updateValue('');
    }
    if (type == 'sale') {
      // Clear rental prices when sale-only
      for (final name in [
        kFromRentalPricePerDay,
        kFromRentalPricePerWeek,
        kFromRentalPricePerMonth,
        kFromRentalPricePerThreeMonths,
        kFromRentalPricePerSixMonths,
        kFromRentalPricePerYear,
      ]) {
        descriptionSectionForm.control(name).updateValue('');
      }
    }
    descriptionSectionForm.markAsDirty();
    descriptionSectionForm.updateValueAndValidity();
  }


  late final descriptionSectionForm = FormGroup({
    kFromCarDescription: FormControl<String>(
        validators: [Validators.required],
        value: "BMW 3.0L Twin-Turbo I6 2024 Automatic."),
    kFromCarPrice: FormControl<String>(validators: [Validators.required], value: "15000"),
    // currency code with default USD
    kFromCurrencyCode: FormControl<String>(value: 'USD'),
    // Listing type (sale/rent/both)
    kFromListingType: FormControl<String>(value: 'sale', validators: [Validators.required]),
    // Rental prices (optional, only required if listing type is rent or both)
    kFromRentalPricePerDay: FormControl<String>(),
    kFromRentalPricePerWeek: FormControl<String>(),
    kFromRentalPricePerMonth: FormControl<String>(),
    kFromRentalPricePerThreeMonths: FormControl<String>(),
    kFromRentalPricePerSixMonths: FormControl<String>(),
    kFromRentalPricePerYear: FormControl<String>(),
    // legacy location field (unused now in mapping, kept to avoid breaking)
    kFromCarLocation: FormControl<String>(value: ''),
    // Address selections (new) - will be initialized from user prefs
    kFromWorldwide: FormControl<bool>(value: true),
    kFromCountryCode: FormControl<String?>(),
    kFromRegionOrCity: FormControl<String?>(),
  });
  
  /// تحميل القيم الافتراضية للموقع من عنوان المستخدم المحفوظ
  void loadDefaultLocationFromPrefs() {
    try {
      final prefs = GetIt.I<PrefsRepository>();
      final countryCode = prefs.selectedCountryCode;
      final regionOrCity = prefs.selectedRegionOrCity;
      
      print('📍 Loading user address as default location:');
      print('   - countryCode: $countryCode');
      print('   - regionOrCity: $regionOrCity');
      
      // تعيين القيم في الفورم (إذا كانت موجودة)
      if (countryCode != null && countryCode.isNotEmpty && countryCode != 'WW') {
        descriptionSectionForm.control(kFromCountryCode).updateValue(countryCode);
        descriptionSectionForm.control(kFromWorldwide).updateValue(false);
        if (regionOrCity != null && regionOrCity.isNotEmpty) {
          descriptionSectionForm.control(kFromRegionOrCity).updateValue(regionOrCity);
        }
        print('✅ User address loaded: $countryCode - $regionOrCity');
      } else {
        // إذا لم يكن هناك عنوان محفوظ، استخدام Worldwide
        descriptionSectionForm.control(kFromWorldwide).updateValue(true);
        descriptionSectionForm.control(kFromCountryCode).updateValue(null);
        descriptionSectionForm.control(kFromRegionOrCity).updateValue(null);
        print('ℹ️ No saved address, using Worldwide');
      }
    } catch (e, stackTrace) {
      print('⚠️ Failed to load default location: $e');
      print('Stack trace: $stackTrace');
      // في حالة الفشل، استخدام Worldwide
      descriptionSectionForm.control(kFromWorldwide).updateValue(true);
      descriptionSectionForm.control(kFromCountryCode).updateValue(null);
      descriptionSectionForm.control(kFromRegionOrCity).updateValue(null);
    }
  }
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
    
    // إعادة تحميل القيم الافتراضية للموقع بعد الـ reset
    loadDefaultLocationFromPrefs();
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

      // تحديث قائمة السيارات في الصفحة الرئيسية بعد الحذف + تحديث المفضلة
      try {
        GetIt.I<HomeCubit>().getHomeData();
        GetIt.I<SearchCubit>().searchCars();
        GetIt.I<FavoriteCubit>().init();
      } catch (e) {
        print('⚠️ Failed to refresh after delete: $e');
      }

      EasyLoading.showSuccess('Car deleted successfully');
    } catch (e) {
      print('🔴 Error deleting car: $e');
      EasyLoading.showError('Failed to delete car');
    }
  }

  // تحديث حالة السيارة (active, sold, pending, inactive)
  Future<void> _onUpdateMyCarStatus(
      UpdateMyCarStatusEvent event,
      Emitter<MyCarsState> emit,
  ) async {
    try {
      EasyLoading.show(status: 'Updating status...');
      final status = event.status.toLowerCase();
      final update = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (status == 'sold') {
        update['sold_at'] = DateTime.now().toIso8601String();
      }

      await SupabaseService.client
          .from('cars')
          .update(update)
          .eq('id', event.carId);

      // إعادة تحميل القائمة بعد التحديث
      add(LoadMyCarsEvent());

      // تحديث الصفحة الرئيسية وقائمة البحث المجمّعة
      try {
        GetIt.I<HomeCubit>().getHomeData();
        GetIt.I<SearchCubit>().searchCars();
      } catch (_) {}

      EasyLoading.showSuccess('Status updated');
    } catch (e) {
      print('🔴 Error updating car status: $e');
      EasyLoading.showError('Failed to update status');
    }
  }

  // تحديث سعر السيارة
  Future<void> _onUpdateMyCarPrice(
    UpdateMyCarPriceEvent event,
    Emitter<MyCarsState> emit,
  ) async {
    try {
      EasyLoading.show(status: 'Updating price...');
      // استخدام updateCar بدلاً من التحديث المباشر لضمان إرسال الإشعارات
      await SupabaseService.updateCar(event.carId, {
        'price': event.newPrice,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // إعادة تحميل القائمة بعد التحديث
      add(LoadMyCarsEvent());

      // تحديث الصفحة الرئيسية وقائمة البحث المجمّعة
      try {
        GetIt.I<HomeCubit>().getHomeData();
        GetIt.I<SearchCubit>().searchCars();
      } catch (_) {}

      EasyLoading.showSuccess('Price updated');
    } catch (e) {
      print('🔴 Error updating car price: $e');
      EasyLoading.showError('Failed to update price');
    }
  }

  // معالج تبديل عرض القالب الافتراضي
  void _onToggleTemplate(ToggleTemplateEvent event, Emitter<MyCarsState> emit) {
    emit(state.copyWith(isTemplateVisible: !state.isTemplateVisible));
    
    if (state.isTemplateVisible) {
      _applyTemplate();
    } else {
      _clearTemplate();
    }
  }

  // تطبيق القالب الافتراضي (سيارة BMW X5 2024)
  void _applyTemplate() {
    // بيانات السيارة الافتراضية
    final templateData = _getTemplateData();
    
    // تطبيق البيانات على نموذج تفاصيل السيارة
    sellMyCarForm.control(kFromCarMaker).value = templateData['maker'];
    sellMyCarForm.control(kFromCarModel).value = templateData['model'];
    sellMyCarForm.control(kFromCarEngine).value = templateData['engine'];
    sellMyCarForm.control(kFromCarYear).value = templateData['year'];
    sellMyCarForm.control(kFromCarTransmission).value = templateData['transmission'];
    sellMyCarForm.control(kFromCarFuelType).value = templateData['fuelType'];
    sellMyCarForm.control(kFromCarVehicleType).value = templateData['bodyType'];
    sellMyCarForm.control(kFromCarCondition).value = templateData['condition'];
    sellMyCarForm.control(kFromCarColor).value = templateData['color'];
    sellMyCarForm.control(kFromCarSeats).value = templateData['seats'];
    sellMyCarForm.control(kFromCarCylinders).value = templateData['cylinders'];
    sellMyCarForm.control(kFromCarMileage).value = templateData['mileage'];
    sellMyCarForm.control(kFromCarTrim).value = templateData['trim'];
    sellMyCarForm.control(kFromCarPaintParts).value = templateData['paintParts'];
    sellMyCarForm.control(kFromCarPlate).value = templateData['plate'];
    sellMyCarForm.control(kFromCarSeatMaterial).value = templateData['seatMaterial'];
    sellMyCarForm.control(kFromCarWheels).value = templateData['wheels'];
    sellMyCarForm.control(kFromCarInteriorColor).value = templateData['interiorColor'];
    sellMyCarForm.control(kFromCarExteriorColor).value = templateData['exteriorColor'];
    
    // تطبيق البيانات على نموذج السعر والوصف
    descriptionSectionForm.control(kFromListingType).value = templateData['listingType'];
    descriptionSectionForm.control(kFromCarPrice).value = templateData['salePrice'];
    descriptionSectionForm.control(kFromCarDescription).value = templateData['description'];
    descriptionSectionForm.control(kFromCountryCode).value = templateData['countryCode'];
    descriptionSectionForm.control(kFromRegionOrCity).value = templateData['regionOrCity'];
    descriptionSectionForm.control(kFromCurrencyCode).value = templateData['currencyCode'];
    
    // تطبيق أسعار الإيجار
    descriptionSectionForm.control(kFromRentalPricePerDay).value = templateData['rentalPricePerDay'];
    descriptionSectionForm.control(kFromRentalPricePerWeek).value = templateData['rentalPricePerWeek'];
    descriptionSectionForm.control(kFromRentalPricePerMonth).value = templateData['rentalPricePerMonth'];
    descriptionSectionForm.control(kFromRentalPricePerThreeMonths).value = templateData['rentalPricePerThreeMonths'];
    descriptionSectionForm.control(kFromRentalPricePerSixMonths).value = templateData['rentalPricePerSixMonths'];
    descriptionSectionForm.control(kFromRentalPricePerYear).value = templateData['rentalPricePerYear'];
    
    // تطبيق المميزات الافتراضية
    _applyDefaultFeatures();
    
    // تحديث validators حسب نوع الإعلان
    updateValidatorsByListingType(templateData['listingType']);
  }

  // تطبيق المميزات الافتراضية للسيارة
  void _applyDefaultFeatures() {
    // التحقق من اللغة الحالية
    bool isArabic = false;
    try {
      isArabic = EasyLocalization.of(GRouter.router.routerDelegate.navigatorKey.currentContext!)?.locale.languageCode == 'ar';
    } catch (e) {
      isArabic = false;
    }
    
    if (isArabic) {
      // مميزات السلامة بالعربية
      sellMyCarForm.control(kFromCarSafety).value = [
        'نظام ABS',
        'وسائد هوائية',
        'نظام التحكم بالثبات',
        'نظام التحكم بالجر',
        'حساسات ركن',
        'كاميرا خلفية',
        'كاميرات 360 درجة',
        'مراقب النقطة العمياء',
        'تحذير مغادرة المسار',
        'تحذير التصادم'
      ];
      
      // المميزات الداخلية بالعربية
      sellMyCarForm.control(kFromCarInterior).value = [
        'مقاعد جلدية',
        'مقاعد مدفأة',
        'مقاعد مبردة',
        'مقاعد كهربائية',
        'مقاعد بذاكرة',
        'أزرار المقود',
        'مثبت السرعة',
        'نظام ملاحة',
        'نظام صوتي فاخر',
        'شاحن لاسلكي',
        'منافذ USB',
        'بلوتوث',
        'Apple CarPlay',
        'Android Auto',
        'تحكم بالمناخ',
        'إضاءة محيطية'
      ];
      
      // المميزات الخارجية بالعربية
      sellMyCarForm.control(kFromCarExterior).value = [
        'مصابيح LED أمامية',
        'مصابيح LED خلفية',
        'مصابيح تكيفية',
        'مصابيح ضباب',
        'فتحة سقف',
        'فتحة سقف بانوراما',
        'جنوط معدنية',
        'مرايا كهربائية',
        'مرايا مدفأة',
        'حساسات مطر',
        'دخول بدون مفتاح',
        'تشغيل بالضغط',
        'تشغيل عن بعد',
        'مساعد ركن'
      ];
    } else {
      // مميزات السلامة بالإنجليزية
      sellMyCarForm.control(kFromCarSafety).value = [
        'ABS System',
        'Airbags',
        'Stability Control',
        'Traction Control',
        'Parking Sensors',
        'Backup Camera',
        '360 Camera',
        'Blind Spot Monitor',
        'Lane Departure Warning',
        'Collision Warning'
      ];
      
      // المميزات الداخلية بالإنجليزية
      sellMyCarForm.control(kFromCarInterior).value = [
        'Leather Seats',
        'Heated Seats',
        'Ventilated Seats',
        'Power Seats',
        'Memory Seats',
        'Steering Wheel Controls',
        'Cruise Control',
        'Navigation System',
        'Premium Sound System',
        'Wireless Charger',
        'USB Ports',
        'Bluetooth',
        'Apple CarPlay',
        'Android Auto',
        'Climate Control',
        'Ambient Lighting'
      ];
      
      // المميزات الخارجية بالإنجليزية
      sellMyCarForm.control(kFromCarExterior).value = [
        'LED Headlights',
        'LED Taillights',
        'Adaptive Headlights',
        'Fog Lights',
        'Sunroof',
        'Panoramic Sunroof',
        'Alloy Wheels',
        'Power Mirrors',
        'Heated Mirrors',
        'Rain Sensors',
        'Keyless Entry',
        'Push Start',
        'Remote Start',
        'Parking Assist'
      ];
    }
  }

  // مسح القالب الافتراضي
  void _clearTemplate() {
    // مسح جميع الحقول
    sellMyCarForm.reset();
    descriptionSectionForm.reset();
    imagesSectionForm.reset();
  }

  // الحصول على بيانات القالب حسب اللغة
  Map<String, dynamic> _getTemplateData() {
    // افتراض اللغة الإنجليزية كافتراضي
    bool isArabic = false;
    try {
      // محاولة الحصول على اللغة الحالية
      isArabic = EasyLocalization.of(GRouter.router.routerDelegate.navigatorKey.currentContext!)?.locale.languageCode == 'ar';
    } catch (e) {
      // في حالة الخطأ، استخدم الإنجليزية
      isArabic = false;
    }
    
    if (isArabic) {
      return {
        'maker': 'BMW',
        'model': 'X5',
        'engine': '3.0 لتر توربو 6 سلندر',
        'year': '2024',
        'transmission': 'أوتوماتيك',
        'fuelType': 'بنزين',
        'bodyType': 'SUV',
        'condition': 'جديد',
        'color': 'أسود',
        'seats': '5',
        'cylinders': '6',
        'mileage': '15000',
        'trim': 'xDrive40i M Sport',
        'paintParts': 'أصلي',
        'plate': 'دبي',
        'seatMaterial': 'جلد',
        'wheels': '21 بوصة',
        'interiorColor': 'أسود',
        'exteriorColor': 'أسود معدني',
        'listingType': 'both',
        'salePrice': '485000',
        'rentalPricePerDay': '850',
        'rentalPricePerWeek': '5500',
        'rentalPricePerMonth': '18000',
        'rentalPricePerThreeMonths': '50000',
        'rentalPricePerSixMonths': '95000',
        'rentalPricePerYear': '180000',
        'countryCode': 'AE',
        'regionOrCity': 'دبي',
        'currencyCode': 'AED',
        'description': 'BMW X5 xDrive40i M Sport 2024 في حالة ممتازة، محرك 3.0 لتر توربو 6 سلندر بقوة 375 حصان، ناقل حركة أوتوماتيك 8 سرعات، نظام دفع رباعي xDrive الذكي، مقاعد جلدية فاخرة مع تدفئة وتبريد، نظام ملاحة BMW Live Cockpit Professional، شاشة 12.3 بوصة، كاميرات 360 درجة، نظام صوتي هارمان كاردون بـ16 مكبر صوت، إضاءة LED تكيفية، فتحة سقف بانوراما، مقاعد كهربائية مع ذاكرة، نظام مساعد القيادة BMW Driving Assistant، نظام ركن تلقائي، شاحن لاسلكي، منافذ USB-C، نظام تحكم بالمناخ 4 مناطق، جنوط M Sport 21 بوصة، فرامل M Sport، نظام عادم رياضي، حماية كاملة وتظليل حراري.'
      };
    } else {
      return {
        'maker': 'BMW',
        'model': 'X5',
        'engine': '3.0L Twin-Turbo I6',
        'year': '2024',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'bodyType': 'SUV',
        'condition': 'Excellent',
        'color': 'Black',
        'seats': '5',
        'cylinders': '6',
        'mileage': '15000',
        'trim': 'xDrive40i M Sport',
        'paintParts': 'Original',
        'plate': 'Dubai',
        'seatMaterial': 'Leather',
        'wheels': '21 inch',
        'interiorColor': 'Black',
        'exteriorColor': 'Metallic Black',
        'listingType': 'both',
        'salePrice': '485000',
        'rentalPricePerDay': '850',
        'rentalPricePerWeek': '5500',
        'rentalPricePerMonth': '18000',
        'rentalPricePerThreeMonths': '50000',
        'rentalPricePerSixMonths': '95000',
        'rentalPricePerYear': '180000',
        'countryCode': 'AE',
        'regionOrCity': 'Dubai',
        'currencyCode': 'AED',
        'description': 'BMW X5 xDrive40i M Sport 2024 in excellent condition, 3.0L Twin-Turbo I6 engine with 375 HP, 8-speed automatic transmission, intelligent xDrive all-wheel drive system, premium leather seats with heating and ventilation, BMW Live Cockpit Professional navigation system, 12.3-inch display, 360-degree cameras, Harman Kardon sound system with 16 speakers, adaptive LED lighting, panoramic sunroof, electric seats with memory, BMW Driving Assistant, automatic parking system, wireless charger, USB-C ports, 4-zone climate control, M Sport 21-inch wheels, M Sport brakes, sport exhaust system, full protection and heat tinting.'
      };
    }
  }
}

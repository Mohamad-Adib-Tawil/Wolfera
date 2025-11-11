part of 'sell_my_car_page.dart';

class _EnterCarDetailsPage extends StatefulWidget {
  const _EnterCarDetailsPage();

  @override
  State<_EnterCarDetailsPage> createState() => _EnterCarDetailsPageState();
}

class _EnterCarDetailsPageState extends State<_EnterCarDetailsPage> {
  late MyCarsBloc _myCarsBloc;

  @override
  void initState() {
    _myCarsBloc = GetIt.I<MyCarsBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReactiveForm(
        formGroup: _myCarsBloc.sellMyCarForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SellCarItem(
              title: 'label_make'.tr(),
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarMaker,
              dialogWidget: CarsMakersDialog(
                isMultiSelect: false,
                onSelectionConfirmed: (selected) {
                  if (selected is CarMaker) {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarMaker)
                        .updateValue(selected.name);
                  } else {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarMaker)
                        .value = null;
                  }
                },
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_model'.tr(),
              formControlName: _myCarsBloc.kFromCarModel,
            ),
            SellCarItem(
              title: 'engine_variant'.tr(),
              formControlName: _myCarsBloc.kFromCarEngine,
            ),
            SellCarItem(
              title: 'label_year'.tr(),
              formControlName: _myCarsBloc.kFromCarYear,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: YearPickerDialog(
                onYearChanged: (selectedYear) {
                  _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarYear)
                      .updateValue(selectedYear.toString());
                },
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_transmission'.tr(),
              formControlName: _myCarsBloc.kFromCarTransmission,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: TranmissionDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarTransmission)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_mileage'.tr(),
              formControlName: _myCarsBloc.kFromCarMileage,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: true),
            ),
            SellCarItem(
              title: 'fuel_type_label'.tr(),
              formControlName: _myCarsBloc.kFromCarFuelType,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: FuelTypeDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarFuelType)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_trim'.tr(),
              formControlName: _myCarsBloc.kFromCarTrim,
              form: _myCarsBloc.sellMyCarForm,
            ),
            SellCarItem(
              title: 'label_cylinders'.tr(),
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCylinders,
              dialogWidget: CylindersDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarCylinders)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'seats_number'.tr(),
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarSeats,
              dialogWidget: SeatsNumberDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarSeats)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'paint_parts'.tr(),
              formControlName: _myCarsBloc.kFromCarPaintParts,
            ),
            SellCarItem(
              title: 'label_condition'.tr(),
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCondition,
              dialogWidget: ConditionDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarCondition)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_plate'.tr(),
              formControlName: _myCarsBloc.kFromCarPlate,
            ),
            SellCarItem(
              title: 'label_color'.tr(),
              formControlName: _myCarsBloc.kFromCarColor,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: ColorsDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarColor)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'seat_material'.tr(),
              formControlName: _myCarsBloc.kFromCarSeatMaterial,
            ),
            SellCarItem(
              title: 'label_wheels'.tr(),
              formControlName: _myCarsBloc.kFromCarWheels,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            SellCarItem(
              title: 'vehicle_type'.tr(),
              formControlName: _myCarsBloc.kFromCarVehicleType,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: VehicleTypeDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarVehicleType)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'interior_color'.tr(),
              formControlName: _myCarsBloc.kFromCarInteriorColor,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: ColorsDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarInteriorColor)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'exterior_color'.tr(),
              formControlName: _myCarsBloc.kFromCarExteriorColor,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: ColorsDialog(
                onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                    .control(_myCarsBloc.kFromCarExteriorColor)
                    .updateValue(p0),
              ),
              isDialog: true,
            ),
          ],
        ),
      ),
    );
  }
}
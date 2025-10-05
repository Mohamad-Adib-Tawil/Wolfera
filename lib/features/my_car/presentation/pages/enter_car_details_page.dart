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
              title: 'Make',
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
              title: 'Model',
              formControlName: _myCarsBloc.kFromCarModel,
            ),
            SellCarItem(
              title: 'Engine Variant',
              formControlName: _myCarsBloc.kFromCarEngine,
            ),
            SellCarItem(
              title: 'Year',
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
              title: 'Transmission',
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
              title: 'Mileage',
              formControlName: _myCarsBloc.kFromCarMileage,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: true),
            ),
            SellCarItem(
              title: 'Fuel Type',
              formControlName: _myCarsBloc.kFromCarFuelType,
              form: _myCarsBloc.sellMyCarForm,
              dialogWidget: FuelTypeDialog(
                  onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarFuelType)
                      .updateValue(p0)),
              isDialog: true,
            ),
            SellCarItem(
              title: 'Trim',
              formControlName: _myCarsBloc.kFromCarTrim,
              form: _myCarsBloc.sellMyCarForm,
            ),
            SellCarItem(
              title: 'Cylinders',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCylinders,
              dialogWidget: CylindersDialog(
                  onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarCylinders)
                      .updateValue(p0)),
              isDialog: true,
            ),
            SellCarItem(
              title: 'Seats Number',
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
              title: 'Paint Parts',
              formControlName: _myCarsBloc.kFromCarPaintParts,
            ),
            SellCarItem(
              title: 'Condition',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCondition,
              dialogWidget: ConditionDialog(
                  onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarCondition)
                      .updateValue(p0)),
              isDialog: true,
            ),
            SellCarItem(
              title: 'Plate',
              formControlName: _myCarsBloc.kFromCarPlate,
            ),
            SellCarItem(
              title: 'Color',
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
              title: 'Seat Material',
              formControlName: _myCarsBloc.kFromCarSeatMaterial,
            ),
            SellCarItem(
              title: 'Wheels',
              formControlName: _myCarsBloc.kFromCarWheels,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            SellCarItem(
              title: 'Vehicle Type',
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
              title: 'Interior Color',
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
              title: 'Exterior Color',
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

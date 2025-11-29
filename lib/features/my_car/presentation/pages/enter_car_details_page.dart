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
              title: 'label_make',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarMaker,
              dialogWidget: CarsMakersDialog(
                isMultiSelect: false,
                onSelectionConfirmed: (selected) {
                  if (selected is CarMaker) {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarMaker)
                        .updateValue(selected.name);
                    // Reset model when maker changes
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarModel)
                        .value = null;
                    // Auto-open models dialog immediately after maker selection
                    Future.delayed(const Duration(milliseconds: 50), () {
                      AnimatedDialog.show(
                        context,
                        insetPadding: HWEdgeInsets.only(
                            top: 60, left: 40, right: 40, bottom: 30),
                        child: CarModelsDialog(
                          isMultiSelect: false,
                          maker: selected,
                          onSelectionConfirmed: (selectedModel) {
                            if (selectedModel is String && selectedModel.isNotEmpty) {
                              _myCarsBloc.sellMyCarForm
                                  .control(_myCarsBloc.kFromCarModel)
                                  .updateValue(selectedModel);
                            }
                          },
                        ),
                        barrierDismissible: true,
                        barrierLabel: 'ModelsDialogAfterMaker',
                      );
                    });
                  } else {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarMaker)
                        .value = null;
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarModel)
                        .value = null;
                  }
                },
              ),
              isDialog: true,
            ),
            SellCarItem(
              title: 'label_model',
              formControlName: _myCarsBloc.kFromCarModel,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.directions_car, color: Colors.white),
                onPressed: () {
                  final makerStr = _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarMaker)
                      .value as String?;
                  CarMaker? maker;
                  try {
                    if (makerStr != null && makerStr.trim().isNotEmpty) {
                      maker = makerStr.toEnum();
                    }
                  } catch (_) {}
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: CarModelsDialog(
                      isMultiSelect: false,
                      maker: maker,
                      onSelectionConfirmed: (selected) {
                        if (selected is String && selected.isNotEmpty) {
                          _myCarsBloc.sellMyCarForm
                              .control(_myCarsBloc.kFromCarModel)
                              .updateValue(selected);
                        }
                      },
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'ModelsDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'engine_variant',
              formControlName: _myCarsBloc.kFromCarEngine,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: () {
                  final current = _myCarsBloc.sellMyCarForm
                      .control(_myCarsBloc.kFromCarEngine)
                      .value as String?;
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: EngineVariantsDialog(
                      selected: current,
                      onSelectionConfirmed: (selected) {
                        if (selected != null && selected.trim().isNotEmpty) {
                          _myCarsBloc.sellMyCarForm
                              .control(_myCarsBloc.kFromCarEngine)
                              .updateValue(selected);
                        } else {
                          _myCarsBloc.sellMyCarForm
                              .control(_myCarsBloc.kFromCarEngine)
                              .value = null;
                        }
                      },
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'EngineVariantsDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'label_year',
              formControlName: _myCarsBloc.kFromCarYear,
              form: _myCarsBloc.sellMyCarForm,
              textInputType:
                  const TextInputType.numberWithOptions(signed: false, decimal: false),
              suffixIcon: IconButton(
                icon: const Icon(Icons.event, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: YearPickerDialog(
                      onYearChanged: (selectedYear) {
                        _myCarsBloc.sellMyCarForm
                            .control(_myCarsBloc.kFromCarYear)
                            .updateValue(selectedYear.toString());
                      },
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'YearPickerDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'label_transmission',
              formControlName: _myCarsBloc.kFromCarTransmission,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: TranmissionDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarTransmission)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'TransmissionDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'label_mileage',
              formControlName: _myCarsBloc.kFromCarMileage,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: true),
            ),
            SellCarItem(
              title: 'fuel_type_label',
              formControlName: _myCarsBloc.kFromCarFuelType,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.local_gas_station, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: FuelTypeDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarFuelType)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'FuelTypeDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'label_trim',
              formControlName: _myCarsBloc.kFromCarTrim,
              form: _myCarsBloc.sellMyCarForm,
            ),
            SellCarItem(
              title: 'label_cylinders',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCylinders,
              textInputType:
                  const TextInputType.numberWithOptions(signed: false, decimal: false),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: CylindersDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarCylinders)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'CylindersDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'seats_number',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarSeats,
              textInputType:
                  const TextInputType.numberWithOptions(signed: false, decimal: false),
              suffixIcon: IconButton(
                icon: const Icon(Icons.event_seat, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: SeatsNumberDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarSeats)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'SeatsNumberDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'paint_parts',
              formControlName: _myCarsBloc.kFromCarPaintParts,
            ),
            SellCarItem(
              title: 'label_condition',
              form: _myCarsBloc.sellMyCarForm,
              formControlName: _myCarsBloc.kFromCarCondition,
              suffixIcon: IconButton(
                icon: const Icon(Icons.handyman, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: ConditionDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarCondition)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'ConditionDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'label_plate',
              formControlName: _myCarsBloc.kFromCarPlate,
            ),
            SellCarItem(
              title: 'label_color',
              formControlName: _myCarsBloc.kFromCarColor,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.color_lens, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: ColorsDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarColor)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'ColorsDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'seat_material',
              formControlName: _myCarsBloc.kFromCarSeatMaterial,
            ),
            SellCarItem(
              title: 'label_wheels',
              formControlName: _myCarsBloc.kFromCarWheels,
              textInputType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            SellCarItem(
              title: 'vehicle_type',
              formControlName: _myCarsBloc.kFromCarVehicleType,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.directions_car, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: VehicleTypeDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarVehicleType)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'VehicleTypeDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'interior_color',
              formControlName: _myCarsBloc.kFromCarInteriorColor,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.colorize, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: ColorsDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarInteriorColor)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'InteriorColorsDialog',
                  );
                },
              ),
            ),
            SellCarItem(
              title: 'exterior_color',
              formControlName: _myCarsBloc.kFromCarExteriorColor,
              form: _myCarsBloc.sellMyCarForm,
              suffixIcon: IconButton(
                icon: const Icon(Icons.palette_outlined, color: Colors.white),
                onPressed: () {
                  AnimatedDialog.show(
                    context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60, left: 40, right: 40, bottom: 30),
                    child: ColorsDialog(
                      onItemSelected: (p0) => _myCarsBloc.sellMyCarForm
                          .control(_myCarsBloc.kFromCarExteriorColor)
                          .updateValue(p0),
                    ),
                    barrierDismissible: true,
                    barrierLabel: 'ExteriorColorsDialog',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
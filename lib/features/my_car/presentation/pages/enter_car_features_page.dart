part of 'sell_my_car_page.dart';

class _EnterCarFeaturesPage extends StatefulWidget {
  const _EnterCarFeaturesPage();

  @override
  State<_EnterCarFeaturesPage> createState() => _EnterCarFeaturesPageState();
}

class _EnterCarFeaturesPageState extends State<_EnterCarFeaturesPage> {
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
        child: Padding(
          padding: HWEdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeatureSection(
                title: 'Safety',
                formControlName: _myCarsBloc.kFromCarSafety,
                onTap: () => AnimatedDialog.show(context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60,
                        left: 40,
                        right: 40,
                        bottom: 30), child: SafetyFeaturesDialog(
                  onItemSelected: (p0) {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarSafety)
                        .updateValue(p0);
                  },
                ),
                    alignment: Alignment.center,
                    barrierDismissible: true,
                    barrierLabel: "SafetyFeaturesDialog"),
              ),
              10.verticalSpace,
              FeatureSection(
                title: 'Interior',
                formControlName: _myCarsBloc.kFromCarInterior,
                onTap: () => AnimatedDialog.show(context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60,
                        left: 40,
                        right: 40,
                        bottom: 30), child: InteriorFeaturesDialog(
                  onItemSelected: (p0) {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarInterior)
                        .updateValue(p0);
                  },
                ),
                    alignment: Alignment.center,
                    barrierDismissible: true,
                    barrierLabel: "InteriorFeaturesDialog"),
              ),
              10.verticalSpace,
              FeatureSection(
                title: 'Exterior',
                formControlName: _myCarsBloc.kFromCarExterior,
                onTap: () => AnimatedDialog.show(context,
                    insetPadding: HWEdgeInsets.only(
                        top: 60,
                        left: 40,
                        right: 40,
                        bottom: 30), child: ExteriorFeaturesDialog(
                  onItemSelected: (p0) {
                    _myCarsBloc.sellMyCarForm
                        .control(_myCarsBloc.kFromCarExterior)
                        .updateValue(p0);
                  },
                ),
                    alignment: Alignment.center,
                    barrierDismissible: true,
                    barrierLabel: "InteriorFeaturesDialog"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/my_car/presentation/manager/my_cars_bloc.dart';
import 'package:wolfera/features/my_car/presentation/widgets/my_cars_list_view_builder.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  @override
  void initState() {
    super.initState();
    // تحميل سيارات المستخدم عند فتح الصفحة
    Future.microtask(() => context.read<MyCarsBloc>().add(LoadMyCarsEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Padding(
          padding: HWEdgeInsets.only(bottom: 18),
          child: ElevatedButton(
              style: ButtonStyle(
                  alignment: Alignment.center,
                  minimumSize: WidgetStatePropertyAll(Size(200.w, 40.h)),
                  backgroundColor:
                      const WidgetStatePropertyAll(AppColors.white)),
              onPressed: () {
                //!!******** MakersDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding:  HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const CarsMakersDialog(),
                //     barrierDismissible: true,
                //     barrierLabel: "MakersDialog");

                //!!******** YearsDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: YearPickerDialog(
                //       currentYear: DateTime.now().year,
                //       onYearChanged: (selectedYear) {
                //         if (kDebugMode) {
                //           print('Selected Year: $selectedYear');
                //         }
                //         // Todo: Select car year
                //       },
                //     ),
                //     barrierDismissible: true,
                //     barrierLabel: "YearPickerDialog");

                //!!******** TranmissionDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const TranmissionDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "TransmissionDialog");

                //!!******** FuelTypeDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const FuelTypeDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "FuelTypeDialog");

                //!!******** ColorsDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const ColorsDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "ColorsDialog");

                //!!******** VehicleTypeDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const VehicleTypeDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "VehicleType");

                //!!******** InteriorFeaturesDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const InteriorFeaturesDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "InteriorDialog");

                //!!******** ExteriorFeaturesDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const ExteriorFeaturesDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "ExteriorDialog");

                //!!******** SafetyFeaturesDialog Display ********
                // AnimatedDialog.show(context,
                //     insetPadding: HWEdgeInsets.only(
                //         top: 60, left: 40, right: 40, bottom: 30),
                //     child: const SafetyFeaturesDialog(),
                //     alignment: Alignment.center,
                //     barrierDismissible: true,
                //     barrierLabel: "SafetyFeaturesDialog");

                //!!******** End ********

                GRouter.router
                    .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage);
              },
              child: AppText(
                "Sell My Car".tr(),
                style: context.textTheme.bodyLarge?.b
                    .withColor(AppColors.blackLight),
              )),
        ),
        appBar: CustomAppbar(
          text: 'My Cars'.tr(),
        ),
        body: BlocBuilder<MyCarsBloc, MyCarsState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: MyCarsListViewBuilder(
                    loadCarsStatus: state.loadCarsStatus,
                    myCars: state.myCars,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/models/page_state/bloc_status.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/my_car/presentation/manager/my_cars_bloc.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';

class MyCarsListViewBuilder extends StatelessWidget {
  const MyCarsListViewBuilder({
    super.key,
    required this.loadCarsStatus,
    required this.myCars,
  });

  final BlocStatus loadCarsStatus;
  final List<Map<String, dynamic>> myCars;

  @override
  Widget build(BuildContext context) {
    late final Widget content;
    if (loadCarsStatus.isLoading() || loadCarsStatus.isInitial()) {
      content = const Center(
        key: ValueKey('mycars-loading'),
        child: AppLoader(color: AppColors.primary),
      );
    } else if (myCars.isEmpty) {
      content = SingleChildScrollView(
        key: const ValueKey('mycars-empty'),
        padding: HWEdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.verticalSpace,
            Container(
              width: double.infinity,
              padding: HWEdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.25), width: 1.2),
              ),
              child: Column(
                children: [
                  AppSvgPicture(Assets.svgNoProfilePicture,
                      width: 72.w, height: 72.w),
                  16.verticalSpace,
                  AppText('mycars_empty_title',
                      style: context.textTheme.titleMedium?.s18.xb
                          .withColor(Colors.white)),
                  8.verticalSpace,
                  AppText('mycars_empty_subtitle',
                      style: context.textTheme.bodyMedium
                          ?.withColor(Colors.white70),
                      maxLines: 2),
                  18.verticalSpace,
                  AppElevatedButton(
                    text: 'sell_my_car'.tr(),
                    onPressed: () => GRouter.router
                        .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    textStyle: context.textTheme.titleMedium?.s15.xb
                        .withColor(Colors.white),
                  ),
                ],
              ),
            ),
            60.verticalSpace,
          ],
        ),
      );
    } else {
      content = ListView.builder(
        key: const ValueKey('mycars-list'),
        physics: const BouncingScrollPhysics(),
        itemCount: myCars.length,
        padding: HWEdgeInsets.only(top: 12, bottom: 75),
        itemBuilder: (context, index) {
          final car = myCars[index];
          final carId = car['id']?.toString();

          // استخراج البيانات من carData
          final imageUrls =
              (car['image_urls'] as List?)?.cast<dynamic>() ?? const [];
          final mainImage = car['main_image_url']?.toString();
          final imageUrl =
              imageUrls.isNotEmpty ? imageUrls.first?.toString() : mainImage;

          final title = [
            car['year']?.toString(),
            car['brand']?.toString(),
            car['model']?.toString()
          ].where((e) => e != null && e.isNotEmpty).join(' ');

          final spec1 =
              (car['body_type'] ?? car['engine_capacity'])?.toString();
          final spec2 = car['transmission']?.toString();
          final mileageVal = car['mileage']?.toString();
          final mileage = (mileageVal != null && mileageVal.isNotEmpty)
              ? '$mileageVal KM'
              : null;
          final fuel = car['fuel_type']?.toString();
          final location = (car['city'] ?? car['location'])?.toString();
          final priceVal = car['price']?.toString();
          final currency = car['currency']?.toString() ?? '\$';
          final price =
              MoneyFormatter.compactFromString(priceVal, symbol: currency);

          return Padding(
            padding: HWEdgeInsets.only(top: 20, right: 14, left: 14),
            child: Stack(
              children: [
                CarMiniDetailsCardWidget(
                  isFaviorateIcon: false,
                  isStatus: true,
                  image: imageUrl,
                  title: title.isNotEmpty ? title : null,
                  spec1: spec1,
                  spec2: spec2,
                  mileage: mileage,
                  fuel: fuel,
                  location: location,
                  price: price,
                  carData: car,
                  fullWidth: true,
                ),
                if (carId != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        color: const Color(0xFF1E1F24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        onSelected: (value) async {
                          final status = (car['status']?.toString() ?? 'active')
                              .toLowerCase();
                          final isSold = status == 'sold';

                          if (value == 'edit_price') {
                            final controller = TextEditingController(
                                text: car['price']?.toString() ?? '');
                            final newPrice = await showDialog<num?>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF1E1F24),
                                  title: Text('edit_price'.tr(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  content: TextField(
                                    controller: controller,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'enter_new_price'.tr(),
                                      hintStyle: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(null),
                                        child: Text('cancel'.tr())),
                                    TextButton(
                                      onPressed: () {
                                        final parsed = num.tryParse(
                                            controller.text.trim());
                                        Navigator.of(ctx).pop(parsed);
                                      },
                                      child: Text('save'.tr()),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (newPrice != null) {
                              // Dispatch update price event
                              // ignore: use_build_context_synchronously
                              context.read<MyCarsBloc>().add(
                                  UpdateMyCarPriceEvent(
                                      carId: carId, newPrice: newPrice));
                            }
                          } else if (value == 'edit_rental_prices') {
                            final dayCtrl = TextEditingController(
                                text: car['rental_price_per_day']?.toString() ??
                                    '');
                            final weekCtrl = TextEditingController(
                                text:
                                    car['rental_price_per_week']?.toString() ??
                                        '');
                            final monthCtrl = TextEditingController(
                                text:
                                    car['rental_price_per_month']?.toString() ??
                                        '');
                            final m3Ctrl = TextEditingController(
                                text: car['rental_price_per_3months']
                                        ?.toString() ??
                                    '');
                            final m6Ctrl = TextEditingController(
                                text: car['rental_price_per_6months']
                                        ?.toString() ??
                                    '');
                            final yearCtrl = TextEditingController(
                                text:
                                    car['rental_price_per_year']?.toString() ??
                                        '');

                            final result =
                                await showDialog<Map<String, String>?>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF1E1F24),
                                  title: Text('edit_rental_prices'.tr(),
                                      style: const TextStyle(color: Colors.white)),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _rentalField('rental_periods.per_day'.tr(), dayCtrl),
                                        _rentalField('rental_periods.per_week'.tr(), weekCtrl),
                                        _rentalField('rental_periods.per_month'.tr(), monthCtrl),
                                        _rentalField('rental_periods.per_3months'.tr(), m3Ctrl),
                                        _rentalField('rental_periods.per_6months'.tr(), m6Ctrl),
                                        _rentalField('rental_periods.per_year'.tr(), yearCtrl),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(null),
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                                color: Colors.white70))),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop({
                                          'perDay': dayCtrl.text.trim(),
                                          'perWeek': weekCtrl.text.trim(),
                                          'perMonth': monthCtrl.text.trim(),
                                          'per3Months': m3Ctrl.text.trim(),
                                          'per6Months': m6Ctrl.text.trim(),
                                          'perYear': yearCtrl.text.trim(),
                                        });
                                      },
                                      child: const Text('Save',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result != null) {
                              // ignore: use_build_context_synchronously
                              context.read<MyCarsBloc>().add(
                                    UpdateMyCarRentalPricesEvent(
                                      carId: carId,
                                      perDay: result['perDay'],
                                      perWeek: result['perWeek'],
                                      perMonth: result['perMonth'],
                                      per3Months: result['per3Months'],
                                      per6Months: result['per6Months'],
                                      perYear: result['perYear'],
                                    ),
                                  );
                            }
                          } else if (value == 'toggle_sold') {
                            final target = isSold ? 'active' : 'sold';
                            // ignore: use_build_context_synchronously
                            context.read<MyCarsBloc>().add(
                                UpdateMyCarStatusEvent(
                                    carId: carId, status: target));
                          } else if (value == 'delete') {
                            final confirmed = await showModalBottomSheet<bool>(
                                  context: context,
                                  backgroundColor: const Color(0xFF1E1F24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.r)),
                                  ),
                                  builder: (ctx) => Padding(
                                    padding: HWEdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText('delete_car_q',
                                                style: context.textTheme
                                                    .titleMedium?.s18.xb
                                                    .withColor(Colors.white)),
                                            IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                icon: const Icon(Icons.close,
                                                    color: Colors.white70)),
                                          ],
                                        ),
                                        6.verticalSpace,
                                        AppText('delete_car_confirm',
                                            style: context.textTheme.bodyMedium
                                                ?.withColor(Colors.white70)),
                                        14.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AppElevatedButton(
                                                text: 'cancel',
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                appButtonStyle:
                                                    AppButtonStyle.secondary,
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(
                                                        double.infinity, 46.h)),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: AppElevatedButton(
                                                text: 'delete',
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  minimumSize: Size(
                                                      double.infinity, 46.h),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        8.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ) ??
                                false;
                            if (confirmed) {
                              // ignore: use_build_context_synchronously
                              context
                                  .read<MyCarsBloc>()
                                  .add(DeleteMyCarEvent(carId));
                            }
                          }
                        },
                        itemBuilder: (ctx) {
                          final status = (car['status']?.toString() ?? 'active')
                              .toLowerCase();
                          final isSold = status == 'sold';
                          final listingType =
                              (car['listing_type']?.toString() ?? '')
                                  .toLowerCase();
                          final isRental =
                              listingType == 'rent' || listingType == 'both';
                          final items = <PopupMenuEntry<String>>[
                            PopupMenuItem(
                              value: 'edit_price',
                              child: ListTile(
                                leading:
                                    Icon(Icons.edit, color: Colors.white70),
                                title: Text('edit_price'.tr(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ];
                          if (isRental) {
                            items.add(
                              PopupMenuItem(
                                value: 'edit_rental_prices',
                                child: ListTile(
                                  leading: const Icon(Icons.car_rental,
                                      color: Colors.white70),
                                  title: Text('edit_rental_prices'.tr(),
                                      style: const TextStyle(color: Colors.white)),
                                ),
                              ),
                            );
                          }
                          items.addAll([
                            PopupMenuItem(
                              value: 'toggle_sold',
                              child: ListTile(
                                leading: Icon(
                                    isSold ? Icons.undo : Icons.sell_outlined,
                                    color: Colors.white70),
                                title: Text(
                                    isSold
                                        ? 'mark_as_active'.tr()
                                        : 'mark_as_sold'.tr(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline,
                                    color: Colors.white70),
                                title: Text('delete'.tr(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ]);
                          return items;
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: content,
    );
  }
}

// Helper: numeric rental price input field for the edit dialog
Widget _rentalField(String label, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: 'Enter amount or leave empty',
        hintStyle: const TextStyle(color: Colors.white38),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    ),
  );
}

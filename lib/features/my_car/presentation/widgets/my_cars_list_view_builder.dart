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
                border: Border.all(color: AppColors.primary.withOpacity(0.25), width: 1.2),
              ),
              child: Column(
                children: [
                  AppSvgPicture(Assets.svgNoProfilePicture, width: 72.w, height: 72.w),
                  16.verticalSpace,
                  AppText(
                    'You have no cars yet',
                    translation: false,
                    style: context.textTheme.titleMedium?.s18.xb.withColor(Colors.white),
                  ),
                  8.verticalSpace,
                  AppText(
                    'Start by adding your first car to sell it on Wolfera.',
                    translation: false,
                    style: context.textTheme.bodyMedium?.withColor(Colors.white70),
                    maxLines: 2,
                  ),
                  18.verticalSpace,
                  AppElevatedButton(
                    text: 'Sell My Car',
                    onPressed: () => GRouter.router.pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    textStyle: context.textTheme.titleMedium?.s15.xb.withColor(Colors.white),
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
          final mileage =
              (mileageVal != null && mileageVal.isNotEmpty) ? '$mileageVal KM' : null;
          final fuel = car['fuel_type']?.toString();
          final location = (car['city'] ?? car['location'])?.toString();
          final priceVal = car['price']?.toString();
          final currency = car['currency']?.toString() ?? '\$';
          final price = MoneyFormatter.compactFromString(priceVal, symbol: currency);

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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        onSelected: (value) async {
                          final status = (car['status']?.toString() ?? 'active').toLowerCase();
                          final isSold = status == 'sold';

                          if (value == 'edit_price') {
                            final controller = TextEditingController(text: car['price']?.toString() ?? '');
                            final newPrice = await showDialog<num?>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF1E1F24),
                                  title: const Text('Edit price', style: TextStyle(color: Colors.white)),
                                  content: TextField(
                                    controller: controller,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new price',
                                      hintStyle: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(null),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final parsed = num.tryParse(controller.text.trim());
                                        Navigator.of(ctx).pop(parsed);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (newPrice != null) {
                              // Dispatch update price event
                              // ignore: use_build_context_synchronously
                              context.read<MyCarsBloc>().add(UpdateMyCarPriceEvent(carId: carId, newPrice: newPrice));
                            }
                          } else if (value == 'toggle_sold') {
                            final target = isSold ? 'active' : 'sold';
                            // ignore: use_build_context_synchronously
                            context.read<MyCarsBloc>().add(UpdateMyCarStatusEvent(carId: carId, status: target));
                          } else if (value == 'delete') {
                            final confirmed = await showModalBottomSheet<bool>(
                                  context: context,
                                  backgroundColor: const Color(0xFF1E1F24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                                  ),
                                  builder: (ctx) => Padding(
                                    padding: HWEdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText('Delete car?', translation: false, style: context.textTheme.titleMedium?.s18.xb.withColor(Colors.white)),
                                            IconButton(onPressed: () => Navigator.pop(ctx, false), icon: const Icon(Icons.close, color: Colors.white70)),
                                          ],
                                        ),
                                        6.verticalSpace,
                                        AppText(
                                          'Are you sure you want to delete this car? This action cannot be undone.',
                                          translation: false,
                                          style: context.textTheme.bodyMedium?.withColor(Colors.white70),
                                        ),
                                        14.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AppElevatedButton(
                                                text: 'Cancel',
                                                onPressed: () => Navigator.pop(ctx, false),
                                                appButtonStyle: AppButtonStyle.secondary,
                                                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 46.h)),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: AppElevatedButton(
                                                text: 'Delete',
                                                onPressed: () => Navigator.pop(ctx, true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent,
                                                  minimumSize: Size(double.infinity, 46.h),
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
                              context.read<MyCarsBloc>().add(DeleteMyCarEvent(carId));
                            }
                          }
                        },
                        itemBuilder: (ctx) {
                          final status = (car['status']?.toString() ?? 'active').toLowerCase();
                          final isSold = status == 'sold';
                          return [
                            const PopupMenuItem(
                              value: 'edit_price',
                              child: ListTile(
                                leading: Icon(Icons.edit, color: Colors.white70),
                                title: Text('Edit price', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle_sold',
                              child: ListTile(
                                leading: Icon(isSold ? Icons.undo : Icons.sell_outlined, color: Colors.white70),
                                title: Text(isSold ? 'Mark as active' : 'Mark as sold', style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_outline, color: Colors.white70),
                                title: Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ];
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
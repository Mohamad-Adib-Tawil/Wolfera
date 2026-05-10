import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/car_stores/presentation/manager/seller_cars_cubit.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';

class SellerCarsListView extends StatelessWidget {
  const SellerCarsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerCarsCubit, SellerCarsState>(
      builder: (context, state) {
        return state.carsState.when(
          init: () => const SizedBox.shrink(),
          loading: () => const Center(child: AppLoader()),
          loaded: (cars) => CarsListViewBuilder(
            scrollDirection: Axis.vertical,
            padding: HWEdgeInsets.symmetric(horizontal: 10, vertical: 10),
            cars: cars,
          ),
          empty: () => _MessageState(text: 'no_cars_for_sale'.tr()),
          error: (_) => _MessageState(text: 'failed_to_load_seller_cars'.tr()),
        );
      },
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: HWEdgeInsets.symmetric(horizontal: 24),
        child: AppText(
          text,
          style: context.textTheme.bodyLarge!.s15.withColor(AppColors.grey),
          textAlign: TextAlign.center,
          translation: false,
        ),
      ),
    );
  }
}

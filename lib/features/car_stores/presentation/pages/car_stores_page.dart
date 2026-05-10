import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/refresh_list_widget.dart';
import 'package:wolfera/features/car_stores/data/repositories/seller_cars_repository.dart';
import 'package:wolfera/features/car_stores/domain/entities/car_publisher.dart';
import 'package:wolfera/features/car_stores/presentation/manager/car_stores_cubit.dart';
import 'package:wolfera/features/car_stores/presentation/widgets/car_store_card.dart';
import 'package:wolfera/generated/assets.dart';

class CarStoresPage extends StatefulWidget {
  const CarStoresPage({super.key});

  @override
  State<CarStoresPage> createState() => _CarStoresPageState();
}

class _CarStoresPageState extends State<CarStoresPage>
    with AutomaticKeepAliveClientMixin {
  late final CarStoresCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CarStoresCubit(repository: SellerCarsRepository())
      ..loadCarStores();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: const CustomAppbar(
          text: 'car_stores_title',
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<CarStoresCubit, CarStoresState>(
          builder: (context, state) {
            return RefreshListWidget(
              onRefresh: _cubit.loadCarStores,
              child: state.publishersState.when(
                init: () => const SizedBox.shrink(),
                loading: () => const _ScrollableState(child: AppLoader()),
                loaded: (publishers) => _CarStoresList(
                  publishers: publishers,
                  onTapPublisher: _openPublisherCars,
                ),
                empty: () => const _ScrollableState(
                  child: _EmptyStoresState(),
                ),
                error: (_) => const _ScrollableState(
                  child: _ErrorStoresState(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openPublisherCars(CarPublisher publisher) {
    GRouter.router.pushNamed(
      GRouter.config.chatsRoutes.sellerProfile,
      extra: {
        'seller_id': publisher.id,
        'seller_name': publisher.name,
        'seller_avatar': publisher.avatarUrl,
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CarStoresList extends StatelessWidget {
  const _CarStoresList({
    required this.publishers,
    required this.onTapPublisher,
  });

  final List<CarPublisher> publishers;
  final ValueChanged<CarPublisher> onTapPublisher;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: HWEdgeInsets.only(top: 8, bottom: 92),
      itemCount: publishers.length,
      itemBuilder: (context, index) {
        final publisher = publishers[index];
        return CarStoreCard(
          publisher: publisher,
          onTap: () => onTapPublisher(publisher),
        );
      },
    );
  }
}

class _ScrollableState extends StatelessWidget {
  const _ScrollableState({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: HWEdgeInsets.only(left: 24, right: 24, bottom: 92),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
        Center(child: child),
      ],
    );
  }
}

class _EmptyStoresState extends StatelessWidget {
  const _EmptyStoresState();

  @override
  Widget build(BuildContext context) {
    return const _StoresMessageState(
      icon: Assets.svgCarDealer,
      title: 'car_stores_empty_title',
      subtitle: 'car_stores_empty_subtitle',
    );
  }
}

class _ErrorStoresState extends StatelessWidget {
  const _ErrorStoresState();

  @override
  Widget build(BuildContext context) {
    return const _StoresMessageState(
      icon: Assets.svgInfoRect,
      title: 'failed_to_load_car_stores',
      subtitle: 'tryAgain',
    );
  }
}

class _StoresMessageState extends StatelessWidget {
  const _StoresMessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 74.w,
          height: 74.w,
          decoration: BoxDecoration(
            color: AppColors.orange.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AppSvgPicture(
              icon,
              width: 34.w,
              height: 34.h,
              color: AppColors.orange,
            ),
          ),
        ),
        18.verticalSpace,
        AppText(
          title,
          textAlign: TextAlign.center,
          style:
              context.textTheme.titleMedium!.s18.b.withColor(AppColors.white),
        ),
        8.verticalSpace,
        AppText(
          subtitle,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.s14.withColor(AppColors.grey),
        ),
      ],
    );
  }
}

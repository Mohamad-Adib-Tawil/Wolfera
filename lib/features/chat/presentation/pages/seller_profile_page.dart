import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/features/car_stores/data/repositories/seller_cars_repository.dart';
import 'package:wolfera/features/car_stores/presentation/manager/seller_cars_cubit.dart';
import 'package:wolfera/features/car_stores/presentation/widgets/seller_cars_list_view.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_app_bar.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({
    super.key,
    required this.sellerId,
    this.sellerName,
    this.sellerAvatar,
  });

  final String sellerId;
  final String? sellerName;
  final String? sellerAvatar;

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  late final SellerCarsCubit _sellerCarsCubit;

  @override
  void initState() {
    super.initState();
    _sellerCarsCubit = SellerCarsCubit(repository: SellerCarsRepository());
    Future.microtask(() => _sellerCarsCubit.loadSellerCars(widget.sellerId));
  }

  @override
  void didUpdateWidget(covariant SellerProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sellerId != widget.sellerId) {
      _sellerCarsCubit.loadSellerCars(widget.sellerId);
    }
  }

  @override
  void dispose() {
    _sellerCarsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sellerCarsCubit,
      child: Scaffold(
        appBar: ChatAppbar(
          otherUserName: widget.sellerName ?? 'Seller',
          carTitle: null,
          otherUserAvatar: widget.sellerAvatar,
        ),
        body: const SellerCarsListView(),
      ),
    );
  }
}

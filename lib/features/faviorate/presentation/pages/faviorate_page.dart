import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_state.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';

class FavioratePage extends StatefulWidget {
  const FavioratePage({super.key});

  @override
  State<FavioratePage> createState() => _FavioratePageState();
}

class _FavioratePageState extends State<FavioratePage> {
  @override
  void initState() {
    super.initState();
    // إعادة تحميل المفضلات عند فتح الصفحة لضمان عرض البيانات الفعلية
    Future.microtask(() => context.read<FavoriteCubit>().init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: 'Faviorate'.tr(),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final list = state.favoriteCars;
          if (list.isEmpty) {
            // لا توجد مفضلات: عرضها في منتصف الشاشة بشكل جميل
            return Center(child: AppEmptyState.favoritesEmpty());
          }

          // عرض قائمة المفضلة باستخدام نفس تصميم بطاقات السيارات
          return CarsListViewBuilder(
            scrollDirection: Axis.vertical,
            padding:
                HWEdgeInsetsDirectional.only(start: 14, end: 14, top: 10),
            cars: list,
          );
        },
      ),
    );
  }
}

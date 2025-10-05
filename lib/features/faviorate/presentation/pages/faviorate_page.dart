import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';

class FavioratePage extends StatelessWidget {
  const FavioratePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: 'Faviorate'.tr(),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: CarsListViewBuilder(
              scrollDirection: Axis.vertical,
              padding:
                  HWEdgeInsetsDirectional.only(start: 14, end: 14, top: 10),
            ),
          ),
        ],
      ),
    );
  }
}

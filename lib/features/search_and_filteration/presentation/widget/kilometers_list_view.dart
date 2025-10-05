import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/max_kilometers.dart';
import 'package:wolfera/common/enums/min_kilometers.dart';
import 'package:wolfera/core/utils/extensions/kilometers_extention.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/text_with_border_item_widget.dart';

class KilometersListView extends StatelessWidget {
  final bool isMin;
  final Function(String) onTap;
  const KilometersListView(
      {super.key, required this.isMin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(top: 10, bottom: 10, right: 10),
          itemCount:
              isMin ? MinKilometers.values.length : MaxKilometers.values.length,
          itemBuilder: (context, index) {
            final item = isMin
                ? MinKilometers.values[index]
                : MaxKilometers.values[index];

            final stateVal = isMin
                ? state.selectedCarMinKilometers
                : state.selectedCarMaxKilometers;

            final bool isSelected = item.value == stateVal;

            return Padding(
              padding: HWEdgeInsets.only(right: 8, top: 16),
              child: TextWithBorderItemWidget(
                title: item.value,
                isSelected: isSelected,
                onTap: () => onTap(item.value),
              ),
            );
          },
        );
      },
    );
  }
}

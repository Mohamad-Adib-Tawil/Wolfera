import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/car_color.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/color_item.dart';

class ColorsListView extends StatelessWidget {
  const ColorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(left: 4, right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: CarColor.values.length,
          itemBuilder: (context, index) {
            final item = CarColor.values[index];
            bool isSelected =
                state.seletedColors.contains(CarColor.values[index].name);
            return ColorItem(
                colorItem: item,
                isSelected: isSelected,
                onTap: () => context
                    .read<SearchCubit>()
                    .toggleColorsSelection(item.name));
          },
        );
      },
    );
  }
}

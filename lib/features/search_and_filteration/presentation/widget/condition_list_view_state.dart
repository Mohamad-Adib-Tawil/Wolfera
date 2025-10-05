import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/car_condition.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/text_with_border_item_widget.dart';

class ConditionListView extends StatelessWidget {
  const ConditionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(left: 4, right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: CarCondition.values.length,
          itemBuilder: (context, index) {
            final item = CarCondition.values[index];
            final isSelected = item.title == state.seletedCondition;
            return TextWithBorderItemWidget(
                title: item.title,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectCarCondition(item.title));
          },
        );
      },
    );
  }
}
